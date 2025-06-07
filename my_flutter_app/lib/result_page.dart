import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  // TODO: 결과 데이터를 받을 변수 추가 (예: 점수, 틀린 문제 목록)
  // final int score;
  // final List<Problem> incorrectProblems;

  const ResultPage({
    super.key,
    // required this.score,
    // required this.incorrectProblems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2), // 배경색
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView( // 콘텐츠가 화면을 넘어갈 경우 스크롤 가능하도록
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24.0), // 상단 여백

              // 나랏말싸미 로고 (텍스트로 임시 구현 또는 이미지 사용)
              Text(
                '나랏말싸미',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600], // 회색 계열
                  // TODO: 이미지 사용 시 Image.asset('assets/images/...') 사용
                ),
              ),
              const SizedBox(height: 24.0), // 로고와 점수 사이 간격

              // 점수 섹션
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // 점수 텍스트
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '90', // TODO: 실제 점수 변수 사용
                        style: TextStyle(
                          fontSize: 96, // 이미지 기반 글자 크기
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.0, // 줄 간격 조정
                        ),
                      ),
                      const Text(
                        '점', // TODO: '점' 텍스트
                        style: TextStyle(
                          fontSize: 32, // 이미지 기반 글자 크기
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0), // 점수와 텍스트 사이 간격

              // 차곡차곡 쌓아나가는 우리글 실력 텍스트
              const Text(
                '''차곡차곡 쌓아나가는
우리글 실력''', // 이미지 참고
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20, // 이미지 기반 글자 크기
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24.0), // 텍스트와 프로그레스 바 사이 간격

              // 프로그레스 바 및 달리는 캐릭터 이미지
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0), // 좌우 여백 유지
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 프로그레스 바 (임시 구현)
                    Expanded(
                      child: Container(
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // 프로그레스 바 배경색 임시 표시
                          borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
                        ),
                        // TODO: 실제 프로그레스 상태 반영
                        // child: LinearProgressIndicator(...),
                      ),
                    ),
                    const SizedBox(width: 16.0), // 프로그레스 바와 이미지 사이 간격
                    // 달리는 캐릭터 이미지
                    // Image.asset(
                    //   'assets/images/loading.png', // 달리는 캐릭터 이미지 경로
                    //   height: 40.0, // 이미지 크기 조정 (이미지 참고)
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0), // 프로그레스 바와 오답 섹션 사이 간격


              // 오답 문장 모아보기 섹션
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0), // 좌우 여백
                padding: const EdgeInsets.all(16.0), // 내부 패딩
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3B0), // 연한 노란색 배경
                  borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '오답 문장 모아보기', // 이미지 참고
                      style: TextStyle(
                        fontSize: 18, // 이미지 기반 글자 크기
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12.0), // 제목과 오답 목록 사이 간격
                    // TODO: 틀린 문제 목록 표시 (ListView.builder 또는 Column 사용)
                    // 현재는 이미지에 있는 오답 예시 하드코딩
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: '1. 일을 '),
                          TextSpan(
                            text: '하던지 말던지', // 이미지 참고
                            style: TextStyle(
                               color: Colors.red, // 이미지 참고 (빨간색)
                            ),
                          ),
                          const TextSpan(text: ' 마음을 정해야지.'), // 이미지 참고
                          const TextSpan(text: '\n   하든지 말든지'), // 이미지 참고
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0), // 오답 섹션과 버튼들 사이 간격

              // 버튼들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0), // 버튼 좌우 여백
                child: Column(
                  children: [
                    // 다시 도전하기 버튼
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 다시 도전하기 액션
                        // Navigator.pushReplacementNamed(context, '/problem');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9CCC65), // 녹색 배경 (이미지 참고)
                        foregroundColor: Colors.white, // 글자색 흰색
                        padding: const EdgeInsets.symmetric(vertical: 16.0), // 세로 패딩
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
                        ),
                        minimumSize: const Size(double.infinity, 50), // 너비를 double.infinity로 설정
                      ),
                      child: const Text(
                        '다시 도전하기', // 이미지 참고
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16.0), // 버튼 사이 간격

                    // 결과 공유하기 버튼
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 결과 공유하기 액션
                      },
                       style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9CCC65), // 녹색 배경 (이미지 참고)
                        foregroundColor: Colors.white, // 글자색 흰색
                        padding: const EdgeInsets.symmetric(vertical: 16.0), // 세로 패딩
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
                        ),
                         minimumSize: const Size(double.infinity, 50), // 너비를 double.infinity로 설정
                      ),
                      child: const Text(
                        '결과 공유하기', // 이미지 참고
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16.0), // 버튼 사이 간격

                    // 홈으로 돌아가기 버튼
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 홈으로 돌아가기 액션
                         // Navigator.popUntil(context, ModalRoute.withName('/')); // 예시: 홈 경로로 pop
                      },
                       style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9CCC65), // 녹색 배경 (이미지 참고)
                        foregroundColor: Colors.white, // 글자색 흰색
                        padding: const EdgeInsets.symmetric(vertical: 16.0), // 세로 패딩
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
                        ),
                         minimumSize: const Size(double.infinity, 50), // 너비를 double.infinity로 설정
                      ),
                      child: const Text(
                        '홈으로 돌아가기', // 이미지 참고
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0), // 버튼들 하단 여백
            ],
          ),
        ),
      ),
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
        iconSize: 30.0, // 아이콘 크기 유지
        onTap: (index) {
          // TODO: 탭 전환 로직 구현
        },
        type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 때 고정
      ),
    );
  }
} 