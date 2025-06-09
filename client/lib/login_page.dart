import 'package:flutter/material.dart';
import 'package:my_flutter_app/signup_page.dart'; // 회원가입 페이지로 이동하기 위해 import
import 'package:flutter_svg/flutter_svg.dart'; // SVG 이미지 사용을 위해 import
import 'package:my_flutter_app/main_page.dart'; // 메인 페이지로 이동하기 위해 import
import 'package:http/http.dart' as http; // http 패키지 임포트
import 'dart:convert'; // JSON 처리를 위한 임포트

class LoginPage extends StatefulWidget { // StatelessWidget에서 StatefulWidget으로 변경
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState(); // State 생성
}

class _LoginPageState extends State<LoginPage> { // State 클래스 정의
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 로직 함수
  Future<void> _login() async {
    final String id = _idController.text; // 아이디로 사용
    final String password = _passwordController.text;

    // 백엔드 URL (로컬에서 테스트 시 IP 주소 또는 localhost 사용)
    const String apiUrl = 'http://10.0.2.2:8000/api/auth/login'; // 백엔드 API 주소

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': id, // 백엔드는 email 필드를 사용
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // 성공적으로 로그인
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String? sessionToken = responseBody['token']; // 세션 토큰 추출
        final String? displayName = responseBody['display_name']; // 닉네임 추출
        final String? studyLevel = responseBody['study_level']; // 학습 레벨 추출 (문자열로 유지)
        
        _showAlertDialog('성공', '로그인이 완료되었습니다.');
        
        // TODO: 로그인 성공 후 세션 토큰 등을 안전하게 저장하는 로직 추가 (예: shared_preferences)
        if (sessionToken != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage(sessionToken: sessionToken, displayName: displayName, studyLevel: studyLevel)), // 세션 토큰, 닉네임, 학습 레벨 전달
          );
        } else {
          _showAlertDialog('오류', '세션 토큰을 받지 못했습니다. 다시 시도해주세요.');
        }
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        _showAlertDialog('오류', responseBody['detail'] ?? '로그인에 실패했습니다.');
      } else {
        _showAlertDialog('오류', '서버 오류가 발생했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      _showAlertDialog('오류', '네트워크 오류가 발생했습니다: $e');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2), // 온보딩/회원가입 페이지와 동일한 배경색 사용
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0), // 회원가입 페이지와 동일한 좌우 여백 사용
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 이미지 기반 좌측 정렬
            children: <Widget>[
              const SizedBox(height: 150.0), // 온보딩 페이지와 동일한 상단 여백 사용
              Center(
                child: const Text(
                  '로그인', // 제목 변경
                  style: TextStyle(
                    fontSize: 40, // 회원가입 페이지와 동일한 글자 크기
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2A1E), // 이미지 기반 색상 (어두운 갈색)
                  ),
                ),
              ),
              const SizedBox(height: 32.0), // 제목과 첫 번째 입력 필드 간 간격

              // 아이디 입력 필드
              const Text(
                '아이디',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6E4C), // 이미지 기반 색상 (갈색 계열)
                ),
              ),
              const SizedBox(height: 4.0), // 라벨과 입력 필드 간 간격
              TextField(
                controller: _idController, // 아이디 컨트롤러 연결
                keyboardType: TextInputType.emailAddress, // 이메일 주소 형식 키보드
                decoration: InputDecoration(
                  hintText: '아이디를 입력하세요',
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
                controller: _passwordController, // 비밀번호 컨트롤러 연결
                obscureText: true, // 비밀번호 숨김
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

              const SizedBox(height: 32.0), // 마지막 입력 필드와 버튼 간 간격

              // 로그인 버튼
              ElevatedButton(
                onPressed: _login,
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
                child: const Text('로그인'), // 버튼 텍스트 변경
              ),

              const SizedBox(height: 24.0), // 버튼과 하단 텍스트 그룹 간 간격 더 넓힘

              // 하단 텍스트 및 회원가입 링크
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                children: <Widget>[
                  const Text(
                    '아직 회원이 아니신가요?', // 텍스트 변경
                    style: TextStyle(
                      fontSize: 14, // 이미지 기반 글자 크기
                      color: Color(0xFF8B6E4C), // 이미지 기반 색상 (갈색 계열)
                    ),
                  ),
                  const SizedBox(width: 4.0), // 텍스트와 링크 간 간격 (이미지 기반)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupPage()), // 회원가입 페이지로 이동
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 기본 패딩 제거
                      minimumSize: Size.zero, // 기본 최소 크기 제거
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 탭 영역 축소
                    ),
                    child: const Text(
                      '회원가입', // 링크 텍스트 변경
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
              const SizedBox(height: 16.0), // 하단 여백 줄임 (또는 텍스트와의 간격 조정)

              // '또는' 텍스트 및 구분선
              const SizedBox(height: 0.0), // 버튼 그룹과 소셜 로그인 섹션 사이 간격 완전히 제거
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Divider( // 왼쪽 구분선
                      color: Color(0xFFD1D5DB), // 이미지 기반 색상 (연한 회색)
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0), // 구분선과 텍스트 사이 간격
                    child: Text(
                      '또는',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF8B6E4C), // 이미지 기반 색상 (갈색 계열)
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider( // 오른쪽 구분선
                      color: Color(0xFFD1D5DB), // 이미지 기반 색상 (연한 회색)
                      height: 1,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // '또는' 텍스트와 소셜 로그인 버튼 사이 간격

              // Google 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  // TODO: Google 로그인 기능 구현
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 흰색 배경
                  foregroundColor: Colors.black, // 검은색 글자색
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // 이미지 기반 패딩
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(48.0), // 이미지 기반 둥근 모서리
                    side: const BorderSide(color: Color(0xFFD1D5DB)), // 연한 회색 테두리
                  ),
                  minimumSize: const Size(double.infinity, 50), // 이미지 기반 너비 및 높이
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ), // 이미지 기반 텍스트 스타일
                  elevation: 2, // 그림자
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 내용을 중앙 정렬
                  mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞춤
                  children: <Widget>[
                    // Google 로고 이미지 (SVG)
                    SvgPicture.asset(
                      'assets/images/google-logo-NePEveMl.svg', // SVG 파일 경로
                      height: 24.0, // 이미지 높이 설정
                    ),
                    const SizedBox(width: 8.0), // 로고와 텍스트 사이 간격
                    const Text('Google로 계속하기'), // 버튼 텍스트
                  ],
                ),
              ),
              // 추가된 내용 끝

              const SizedBox(height: 24.0), // 소셜 로그인 버튼과 화면 하단 사이 여백
            ],
          ),
        ),
      ),
    );
  }
} 