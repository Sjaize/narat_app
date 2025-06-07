import 'package:flutter/material.dart';
import 'dart:ui';
import 'result_page.dart'; // 결과 페이지 임포트

enum AnswerStatus {
  correct,
  incorrect,
}

class ProblemPage extends StatefulWidget {
  const ProblemPage({super.key});

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  // TODO: 정답 오버레이 표시 여부를 관리하는 상태 변수 추가
  AnswerStatus? _answerStatus; // 오버레이 상태를 AnswerStatus enum으로 관리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2), // 배경색
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // 홈 아이콘
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), // 하트 아이콘 (Outline 버전 사용)
            label: '찜',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined), // 가방 아이콘 (Outline 버전 사용)
            label: '가방',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // 설정 아이콘
            label: '설정',
          ),
        ],
        currentIndex: 0, // TODO: 현재 선택된 탭 인덱스 관리
        selectedItemColor: const Color(0xFF2D2A1E), // 선택된 아이템 색상 (이미지 기반)
        unselectedItemColor: const Color(0xFF8B6E4E), // 선택되지 않은 아이템 색상 (이미지 기반)
        backgroundColor: const Color(0xFFFFF8E2), // 네비게이션 바 배경색 (이미지 기반)
        iconSize: 25.0, // 아이콘 크기를 메인 페이지와 동일하게 변경
        onTap: (index) {
          // TODO: 탭 전환 로직 구현
        },
        type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 때 고정
      ),
      body: Stack(
        children: [
          // 기존 페이지 콘텐츠
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 헤더 콘텐츠 (메인 페이지와 동일한 구조)
              SafeArea( // 헤더 콘텐츠에만 SafeArea 적용하여 상태 표시줄 아래 배치
                bottom: false, // 하단 시스템 바 영역은 피하지 않음
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // 원래 수직 패딩 유지
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 이미지 (onboarding.png)
                      Center(
                        child: Image.asset(
                          'assets/images/onboarding.png', // 이미지 파일 경로
                          height: 50.0, // 이미지 높이
                        ),
                      ),
                      const SizedBox(height: 18.0), // 이미지와 구분선 사이 간격
                      const Divider(height: 1.0, thickness: 0.5, color: Colors.grey), // 새로운 구분선 추가
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0), // 좌우 및 상하 여백
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center가 이미 처리하지만 명시
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // 문제 번호
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF2D2A1E)), // 갈색 테두리
                            borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                          ),
                          child: const Text(
                            '하나',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D2A1E), // 갈색 텍스트
                            ),
                          ),
                        ),
                        const SizedBox(height: 48.0), // 문제 번호와 텍스트 사이 간격

                        // 문제 텍스트
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            // 기본 스타일은 Text 위젯의 스타일과 동일하게 적용
                            style: const TextStyle(
                              fontSize: 32, // 이미지 기반 글자 크기
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2A1E), // 메인 텍스트 색상
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: '일을 '),
                              TextSpan(
                                text: '하던지 말던지',
                                style: TextStyle(
                                  backgroundColor: null, // 배경색 하이라이트 제거
                                  color: const Color(0xFFE57373), // 0xFFE57373 색상으로 글자색 변경
                                  decoration: TextDecoration.underline, // 밑줄 추가
                                  decorationColor: const Color(0xFFE57373), // 밑줄 색상 (글자 색상과 동일하게)
                                  decorationThickness: 2.0, // 밑줄 두께 조정
                                ),
                              ),
                              const TextSpan(text: '\n마음을 정해야지.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 64.0), // 문제 텍스트와 버튼 사이 간격

                        // 선택 버튼 1
                        SizedBox(
                          width: 250.0,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _answerStatus = AnswerStatus.incorrect; // 오답 선택
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 흰색 배경
                              foregroundColor: Colors.black, // 글자색 검은색으로 변경
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // 패딩 조정
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black, width: 1.0), // 검은색 윤곽선 추가
                                borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
                              ),
                              elevation: 0, // 그림자 효과 제거
                            ),
                            child: const Text(
                              '하던지 말던지',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0), // 버튼 사이 간격

                        // 선택 버튼 2 (정답)
                        SizedBox(
                          width: 250.0,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: 이 버튼이 정답을 선택했을 때의 액션
                              setState(() {
                                _answerStatus = AnswerStatus.correct;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 흰색 배경
                              foregroundColor: Colors.black, // 글자색 검은색으로 변경
                              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0), // 패딩 조정
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black, width: 1.0), // 검은색 윤곽선 추가
                                borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
                              ),
                              elevation: 0, // 그림자 효과 제거
                            ),
                            child: const Text(
                              '하든지 말든지',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // 텍스트 볼드체
                              ),
                            ),
                          ),
                        ),

                        // TODO: 문제 넘어가기, 정답/오답 표시 등의 추가 UI 요소

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // TODO: 오버레이 조건부 표시
          if (_answerStatus != null) _buildAnswerOverlay(context, _answerStatus!),
        ],
      ),
    );
  }

  Widget _buildAnswerOverlay(BuildContext context, AnswerStatus status) {
    return Stack(
      children: [
        // 배경 블러 처리
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.1), // 블러 외 추가적인 어두운 효과
            ),
          ),
        ),

        // 정답 오버레이 콘텐츠
        Align(
          alignment: Alignment(0.0, 0.2), // 세로 방향으로 0.2만큼 이동 (아래로)
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 42.0), // 오버레이 전체 좌우 여백을 이전 상태로 되돌림
            child: AspectRatio(
              aspectRatio: 0.65, // 가로/세로 비율을 이전 상태로 되돌림
              child: Container(
                padding: const EdgeInsets.all(24.0), // 내부 패딩 (상하좌우 24.0 유지)
                decoration: BoxDecoration(
                  color: Colors.white, // 오버레이 배경색
                  borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 콘텐츠 크기만큼만 높이 차지 (세로 길이 최소화) - 이전 상태로 되돌림
                  mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // 정답/오답 이미지
                    Image.asset(
                      status == AnswerStatus.correct ? 'assets/images/right.png' : 'assets/images/wrong.png', // status에 따라 이미지 변경
                      height: 120.0, // 이미지 높이를 이전 상태로 되돌림
                    ),
                    const SizedBox(height: 8.0), // 이미지와 텍스트 사이 간격을 이전 상태로 되돌림

                    // 정답/오답 텍스트
                    Text(
                      status == AnswerStatus.correct ? '정답입니다' : '틀렸습니다', // status에 따라 텍스트 변경
                      style: TextStyle(
                        fontSize: 28, // 글자 크기를 이전 상태로 되돌림
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFE57373), // 이미지 참고 (연한 빨강)
                      ),
                    ),
                    const SizedBox(height: 8.0), // 정답 텍스트와 문제 텍스트 사이 간격을 이전 상태로 되돌림

                    // 문제 텍스트 및 해설 (이미지 참고)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 24, // 문제 텍스트 크기를 이전 상태로 되돌림
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // 기본 텍스트 색상
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: '일을 '),
                          TextSpan(
                            text: '하든지 말든지', // 이미지 참고
                            style: TextStyle(
                              color: const Color(0xFF2D2A1E), // 0xFF2D2A1E 색상 적용
                              decoration: TextDecoration.none, // 밑줄 제거
                            ),
                          ),
                          const TextSpan(text: '\n마음을 정해야지.'), // 이미지 참고
                          const TextSpan(text: '\n\n'), // 문제와 해설 사이 간격
                          const TextSpan(
                            text: "‘-던’은 과거에 일어난 일을 회상하여\n말할 때 쓰는 어미입니다.\n따라서 하던지 말던지는 문법적으로\n맞지 않습니다.", // 이미지 참고
                            style: TextStyle(
                              fontSize: 16, // 해설 텍스트 크기를 이전 상태로 되돌림
                              fontWeight: FontWeight.normal,
                              color: Colors.grey, // 이미지 참고
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28.0), // 해설과 버튼 사이 간격을 이전 상태로 되돌림

                    // 다음 문제로 버튼
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResultPage()),
                        ); // 정답/오답 여부와 상관없이 결과 페이지로 이동
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC67C4E), // 0xFFC67C4E 색상으로 통일
                        foregroundColor: Colors.white, // 글자색 흰색
                        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0), // 패딩
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
                        ),
                      ),
                      child: Text(
                        '다음 문제로', // 정답/오답 모두 '다음 문제로' 텍스트 사용
                        style: const TextStyle(fontWeight: FontWeight.bold), // 볼드체
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 