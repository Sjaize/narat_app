import 'package:flutter/material.dart';
import 'package:my_flutter_app/login_page.dart'; // 로그인 페이지 import
import 'package:http/http.dart' as http; // http 패키지 임포트
import 'dart:convert'; // JSON 처리를 위한 임포트

class SignupPage extends StatefulWidget { // StatelessWidget에서 StatefulWidget으로 변경
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState(); // State 생성
}

class _SignupPageState extends State<SignupPage> { // State 클래스 정의
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 회원가입 로직 함수
  Future<void> _signup() async {
    final String nickname = _nicknameController.text;
    final String id = _idController.text; // 아이디로 사용
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _showAlertDialog('오류', '비밀번호가 일치하지 않습니다.');
      return;
    }

    // 백엔드 URL (로컬에서 테스트 시 IP 주소 또는 localhost 사용)
    // 실제 배포 시에는 서버 도메인으로 변경해야 합니다.
    const String apiUrl = 'http://10.0.2.2:8000/api/auth/signup'; // 백엔드 API 주소

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': id, // 백엔드는 email 필드를 사용
          'password': password,
          'display_name': nickname,
        }),
      );

      if (response.statusCode == 200) {
        // 성공적으로 회원가입
        _showAlertDialog('성공', '회원가입이 완료되었습니다. 로그인 해주세요.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        _showAlertDialog('오류', responseBody['detail'] ?? '회원가입에 실패했습니다.');
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

              // 닉네임 입력 필드
              const Text(
                '닉네임',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6E4C), // 이미지 기반 색상 (갈색 계열)
                ),
              ),
              const SizedBox(height: 4.0), // 라벨과 입력 필드 간 간격
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: '닉네임을 입력하세요',
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

              // 아이디 입력 필드
              const Text(
                '아이디',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6E4C),
                ),
              ),
              const SizedBox(height: 4.0),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: '아이디를 입력하세요',
                  hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF6B7280)), // 이미지 기반 아이콘
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
                controller: _passwordController,
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
                controller: _confirmPasswordController,
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
                onPressed: _signup,
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
 