import 'package:flutter/material.dart';
import 'package:my_flutter_app/signup_page.dart';
import 'package:my_flutter_app/login_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2), // 배경색 변경
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0), // 회원가입 페이지와 동일한 좌우/상하 패딩 적용
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // 자식 위젯들을 중앙에 정렬
              children: <Widget>[
                // Column 전체에 패딩을 적용했으므로 상단 여백을 Spacer 대신 SizedBox로 조정할 수 있습니다.
                const SizedBox(height: 200.0), // 상단 여백 추가 (한 번 더)
                // 로고 이미지
                Center(
                  child: Image.asset('assets/images/onboarding.png'), // 이미지 중앙 정렬
                ),
                const SizedBox(height: 24), // 이미지와 아래 텍스트 간 간격 조정
                const Text(
                  '당신은 한국어를\n얼마나 잘 사용하고 계신가요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 36.0), // 텍스트와 하단 버튼 간 간격 줄임
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()), // 로그인 페이지로 이동
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D2A1E), // 이미지 기반 배경색 (어두운 갈색)
                        foregroundColor: Colors.white, // 글자색 흰색
                        padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0), // 좌우 패딩을 더 늘려 버튼 사이즈를 더 크게 조정
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(48.0), // 이미지 기반 둥근 모서리
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ), // 이미지 기반 텍스트 스타일
                        elevation: 6, // 이미지 기반 그림자
                    ),
                    child: const Text(
                      '지금 시작하기', // 텍스트 유지
                    ),
                  ),
                ),
                 const SizedBox(height: 40.0), // 하단 여백 (회원가입 페이지와 동일)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 