import 'package:flutter/material.dart';
import 'main_page.dart'; // 홈으로 돌아가기 위한 메인 페이지 임포트
import 'wrong_answer_note_page.dart'; // 오답노트 페이지 임포트

class SettingsPage extends StatefulWidget {
  final String? sessionToken;
  final String? displayName;
  final String? studyLevel;

  const SettingsPage({
    super.key,
    this.sessionToken,
    this.displayName,
    this.studyLevel,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: '오답노트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
        currentIndex: 2, // 설정 탭을 선택된 상태로 설정
        selectedItemColor: const Color(0xFF2D2A1E),
        unselectedItemColor: const Color(0xFF8B6E4E),
        backgroundColor: const Color(0xFFFFF8E2),
        iconSize: 25.0,
        onTap: (index) {
          if (index == 0) { // '홈' 탭 인덱스
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(
                  sessionToken: widget.sessionToken,
                  displayName: widget.displayName,
                  studyLevel: widget.studyLevel,
                  fetchRecommendationsOnLoad: false,
                ),
              ),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) { // '오답노트' 탭 인덱스
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WrongAnswerNotePage(
                  sessionToken: widget.sessionToken,
                  displayName: widget.displayName,
                  studyLevel: widget.studyLevel,
                ),
              ),
            );
          } else if (index == 2) { // '설정' 탭 인덱스 (현재 페이지)
            // 현재 페이지이므로 아무것도 하지 않음
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
      body: Column(
        children: <Widget>[
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/onboarding.png',
                      height: 50.0,
                    ),
                  ),
                  const SizedBox(height: 18.0),
                  const Divider(height: 1.0, thickness: 0.5, color: Colors.grey),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '설정 페이지',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 