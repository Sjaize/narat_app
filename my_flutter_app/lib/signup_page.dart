import 'package:flutter/material.dart';
import 'package:my_flutter_app/login_page.dart'; // 로그인 페이지 import

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('회원가입'),
      //   backgroundColor: const Color(0xFFFFF8E2), // 온보딩 페이지와 동일한 배경색 사용
      //   elevation: 0, // AppBar 그림자 제거
      // ),
      backgroundColor: const Color(0xFFFFF8E2), // 온보딩 페이지와 동일한 배경색 사용
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0), // 좌우 여백 조정
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 이미지 기반 좌측 정렬
            children: <Widget>[
              const SizedBox(height: 100.0), // 화면 중앙에 가깝게 내리기 위한 상단 여백 조정
              Center(
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 40, // 글자 크기 더 키움
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A1E), // 이미지 기반 색상 (어두운 갈색)
                  ),
                ),
              ),
              const SizedBox(height: 32.0), // 이전 설명 텍스트와 첫 번째 입력 필드 간 간격

              // 이름 입력 필드
              const Text(
                '이름',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6E4C), // 이미지 기반 색상 (갈색 계열)
                ),
              ),
              const SizedBox(height: 4.0), // 라벨과 입력 필드 간 간격
              TextField(
                decoration: InputDecoration(
                  hintText: '이름을 입력하세요',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)), // 이미지 기반 색상
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF6B7280)), // 이미지 기반 아이콘
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0), // 이미지 기반 둥근 모서리
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)), // 이미지 기반 테두리 색상 (노란색 계열)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  filled: true, // 배경 채우기
                  fillColor: Colors.white, // 배경색 흰색
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // 내부 패딩
                ),
              ),
              const SizedBox(height: 20.0), // 입력 필드 간 간격

              // 이메일 입력 필드
              const Text(
                '이메일',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6E4C),
                ),
              ),
              const SizedBox(height: 4.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '이메일을 입력하세요',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF6B7280)), // 이미지 기반 아이콘
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                ),
              ),
              const SizedBox(height: 20.0), // 입력 필드 간 간격

              // 비밀번호 입력 필드
              const Text(
                '비밀번호',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6E4C),
                ),
              ),
              const SizedBox(height: 4.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력하세요',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF6B7280)), // 이미지 기반 아이콘
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                ),
              ),
              const SizedBox(height: 20.0), // 입력 필드 간 간격

              // 비밀번호 확인 입력 필드
              const Text(
                '비밀번호 확인',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6E4C),
                ),
              ),
              const SizedBox(height: 4.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호를 다시 입력하세요',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.verified, color: Color(0xFF6B7280)), // 이미지 기반 아이콘
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(48.0),
                    borderSide: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                ),
              ),

              const SizedBox(height: 32.0), // 마지막 입력 필드와 버튼 간 간격

              // 회원가입 버튼
              ElevatedButton(
                onPressed: () {
                  // TODO: 실제 회원가입 로직 구현 후 이동
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()), // 로그인 페이지로 이동
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2A1E), // 이미지 기반 배경색 (어두운 갈색)
                  foregroundColor: Colors.white, // 글자색 흰색
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // 이미지 기반 패딩
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48.0), // 이미지 기반 둥근 모서리
                  ),
                  minimumSize: const Size(double.infinity, 50), // 이미지 기반 너비 및 높이
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ), // 이미지 기반 텍스트 스타일
                  elevation: 6, // 이미지 기반 그림자
                ),
                child: const Text('회원가입'),
              ),

              const SizedBox(height: 16.0), // 버튼과 하단 텍스트 그룹 간 간격 조정

              // 하단 텍스트 및 로그인 링크
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: <Widget>[
                  const Text(
                    '계정이 있으신가요?',
                    style: TextStyle(
                      fontSize: 14, // 이미지 기반 글자 크기
                      color: Color(0xFF8B6E4C), // 이미지 기반 색상 (갈색 계열)
                    ),
                  ),
                  const SizedBox(width: 4.0), // 텍스트와 링크 간 간격 (이미지 기반)
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 온보딩 페이지로 돌아가기
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 기본 패딩 제거
                      minimumSize: Size.zero, // 기본 최소 크기 제거
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 탭 영역 축소
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        fontSize: 14, // 이미지 기반 글자 크기
                        fontWeight: FontWeight.w500, // 이미지 기반 폰트 두께 (Medium)
                        color: Color(0xFF5A3D28), // 이미지 기반 색상 (더 진한 갈색)
                        decoration: TextDecoration.underline, // 이미지 기반 밑줄
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }
}
