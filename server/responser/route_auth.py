from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import datetime
import models
from dbmanage import get_db
from sqlalchemy.orm import Session
from google.auth.transport import requests
from google.oauth2 import id_token
from uuid import uuid4
import os
from dotenv import load_dotenv
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

header = "/api/auth"
router = APIRouter(
    prefix = header,
    tags   = ['auth']
)
load_dotenv()
GOOGLE_CLIENT_ID = os.environ.get('GOOGLE_CLIENT_ID')

@router.get('/')
async def root():
    return {"success": "true"}

class GoogleLogin(BaseModel):
    credential: str
    email: str
    name: str
    picture: str

# 일반 회원가입을 위한 Pydantic 모델
class UserCreate(BaseModel):
    email: str # 아이디로 사용
    password: str
    display_name: str # 닉네임으로 사용

# 일반 로그인을 위한 Pydantic 모델
class UserLogin(BaseModel):
    email: str # 아이디로 사용
    password: str

@router.post('/google')
async def google_login(item: GoogleLogin, db: Session = Depends(get_db)):
    try:
        # 받은 토큰 검증
        id_info = id_token.verify_oauth2_token(item.credential, requests.Request(), GOOGLE_CLIENT_ID)

        # 이메일과 이름 추출
        email = id_info.get("email")
        name = id_info.get("name")

        if not email or not name:
            raise HTTPException(status_code=400, detail="Invalid token payload")

        # 사용자 조회 또는 생성
        user = db.query(models.UserDB).filter(models.UserDB.email == email).first()
        if user is None:
            user = models.UserDB(
                google_id=str(uuid4()),
                email=email,
                display_name=name
            )
            db.add(user)
            db.commit()
            db.refresh(user)
        else:
            user.last_login = datetime.datetime.now()
            db.commit()

        # 세션 생성
        session = models.SessionDB(
            session_id=str(uuid4()),
            google_id=user.google_id
        )
        db.add(session)
        db.commit()

        return JSONResponse({
            "token": session.session_id,
            "display_name": user.display_name,
            "study_level": user.study_level if user.study_level is not None else 'B'
        })
    
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid token")

@router.post('/signup')
async def signup(item: UserCreate, db: Session = Depends(get_db)):
    # 1. 아이디(이메일) 중복 확인
    existing_user = db.query(models.UserDB).filter(models.UserDB.email == item.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    # 2. 비밀번호 해싱
    hashed_password = pwd_context.hash(item.password)

    # 3. 새로운 사용자 생성 (google_id는 고유하게 생성)
    new_user = models.UserDB(
        google_id=str(uuid4()), # 고유한 UUID 생성
        email=item.email,
        hashed_password=hashed_password,
        display_name=item.display_name,
        study_level='B' # study_level을 명시적으로 'B'로 설정
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # 새로운 사용자 회원가입 시 세션 생성
    session = models.SessionDB(
        session_id=str(uuid4()),
        google_id=new_user.google_id
    )
    db.add(session)
    db.commit()

    print(f"DEBUG: New user created with study_level: {new_user.study_level}")

    return JSONResponse({
        "success": True,
        "message": "User created successfully",
        "token": session.session_id, # 새로 생성된 세션의 ID 반환
        "display_name": new_user.display_name,
        "study_level": new_user.study_level if new_user.study_level is not None else 'B'
    })

@router.post('/login')
async def login(item: UserLogin, db: Session = Depends(get_db)):
    # 1. 아이디(이메일)로 사용자 조회
    user = db.query(models.UserDB).filter(models.UserDB.email == item.email).first()
    if user is None:
        raise HTTPException(status_code=400, detail="Incorrect email or password")

    # 2. 비밀번호 검증
    if not pwd_context.verify(item.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect email or password")

    # 3. 세션 생성
    session = models.SessionDB(
        session_id=str(uuid4()),
        google_id=user.google_id # 일반 회원가입 사용자도 google_id 필드를 사용
    )
    db.add(session)
    db.commit()

    return JSONResponse({
        "token": session.session_id,
        "display_name": user.display_name,
        "study_level": user.study_level if user.study_level is not None else 'B'
    })

class Verify(BaseModel):
    session_token: str

@router.post('/verify')
async def verify_session(item: Verify, db: Session = Depends(get_db)):
    session = db.query(models.SessionDB).filter(models.SessionDB.session_id == item.session_token).first()
    if session is None:
        raise HTTPException(status_code=400, detail="Invalid session token")
    
    return JSONResponse({
        "is_valid": True,
        "display_name": session.session_owner.display_name,
        "study_level": session.session_owner.study_level if session.session_owner.study_level is not None else 'B'
    })

@router.post('/logout')
async def logout(item: Verify, db: Session = Depends(get_db)):
    session = db.query(models.SessionDB).filter(models.SessionDB.session_id == item.session_token).first()
    if session is None:
        raise HTTPException(status_code=400, detail="Invalid session token")
    
    db.delete(session)
    db.commit()
    return JSONResponse({
        "success": True
    })

@router.post('/test_session_create')
async def test_session_create(item: GoogleLogin, db: Session = Depends(get_db)):
    if os.environ.get('TEST_SESSION_TOKEN') != item.credential:
        raise HTTPException(status_code=400, detail="Invalid environment")
    data = db.query(models.UserDB).filter(models.UserDB.email == "test@test.com").first()
    if data is not None:
        session = models.SessionDB(session_id=str(uuid4()), google_id=data.google_id)
        db.add(session)
        db.commit()
        return JSONResponse({
            "session_token": session.session_id,
            "display_name": data.display_name,
            "study_level" : data.study_level if data.study_level is not None else 'B'
        })
    else:
        raise HTTPException(status_code=400, detail="User not found")