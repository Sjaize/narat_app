import 'package:flutter/material.dart';
import 'problem_page.dart';
import 'main_page.dart'; // 홈으로 돌아가기 위한 메인 페이지 임포트

class ResultPage extends StatelessWidget {
  final int score;

  const ResultPage({
    super.key,
    this.score = 90, // 임시 기본값 90점
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2), // 배경색
      body: Column( // Main Column for the page
        children: [
          // 헤더 콘텐츠 (기존 헤더 영역에서 분리)
          SafeArea( // 헤더 콘텐츠에만 SafeArea 적용하여 상태 표시줄 아래 배치
            bottom: false, // 하단 시스템 바 영역은 피하지 않음
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0), // 원래 수직 패딩 유지
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

          // 스크롤 가능한 본문 영역
          Expanded( // Expanded widget to take available vertical space
            child: SingleChildScrollView( // Allows content inside to scroll
              child: Column( // Column for the actual page content
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TODO: 점수 섹션, 프로그레스 바, 오답 섹션, 버튼들 추가
                  const SizedBox(height: 24.0), // 헤더와 점수 섹션 사이 간격 조정 (기존 24.0에서 감소)

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
                          Text(
                            '$score', // 실제 점수 변수 사용
                            style: const TextStyle(
                              fontSize: 85, // 이미지 기반 글자 크기
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.1, // 줄 간격 조정
                            ),
                          ),
                          const Text(
                            '점', // '점' 텍스트
                            style: TextStyle(
                              fontSize: 32, // 이미지 기반 글자 크기
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: 90,
                        bottom: 5.0, // star.png 위치 유지
                        child: Image.asset(
                          'assets/images/star.png', // 별 이미지 경로
                          height: 40.0, // star.png 높이를 원래대로 되돌림
                          color: const Color(0xFFE57373), // 빨간색으로 변경
                        ),
                      ),
                      Positioned(
                        bottom: -12.0, // 밑줄 이미지를 점수 텍스트 아래에 보이도록 조정
                        child: Image.asset(
                          'assets/images/underline.png', // 밑줄 이미지 경로
                          width: 200.0, // underline.png 너비 조정
                          color: const Color(0xFFE57373), // 빨간색으로 변경
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18.0), // 점수와 텍스트 사이 간격 조정

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
                  const SizedBox(height: 24.0), // 텍스트와 "오답 문장" 사이 간격 (이전 `텍스트와 프로그레스 바 사이 간격`)

                  // 오답 문장 모아보기 섹션
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 48.0), // 좌우 여백을 main_page와 동일하게 조정
                    padding: const EdgeInsets.all(16.0), // 내부 패딩
                    height: 200.0, // 고정 높이 설정
                    decoration: BoxDecoration(
                      color: Colors.white, // 배경색 흰색으로 변경
                      borderRadius: BorderRadius.circular(15.0), // 둥근 모서리
                      boxShadow: [ // 그림자 효과 추가
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // x, y 축으로 그림자 위치 조정
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '오답 문장 모아보기', // 이미지 참고
                          textAlign: TextAlign.start, // 텍스트 좌측 정렬
                          style: TextStyle(
                            fontSize: 18, // 이미지 기반 글자 크기
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const Divider(height: 16.0, thickness: 0.5, color: Colors.grey), // 구분선 추가
                        const SizedBox(height: 4.0), // 제목과 오답 목록 사이 간격 조정

                        // 오답 목록 텍스트 (스크롤 가능하게)
                        Expanded( // Take remaining space in the fixed-height container
                          child: SingleChildScrollView(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 15,
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
                                  const TextSpan(text: ''' 마음을 정해야지.'''), // 이미지 참고
                                  const TextSpan(text: '''\n   하든지 말든지'''), // 이미지 참고 (수정: 삼중 따옴표 사용)
                                  const TextSpan(text: '''\n\n'''), // 스크롤 테스트용 추가 내용 (수정: 삼중 따옴표 사용)
                                  const TextSpan(text: '2. 다른 오답 문장입니다. 스크롤이 되는지 확인해보세요.'),
                                  const TextSpan(text: '''\n   스크롤 테스트 텍스트 1'''), // 수정: 삼중 따옴표 사용
                                  const TextSpan(text: '''\n   스크롤 테스트 텍스트 2'''), // 수정: 삼중 따옴표 사용
                                  const TextSpan(text: '''\n   스크롤 테스트 텍스트 3'''), // 수정: 삼중 따옴표 사용
                                  const TextSpan(text: '''\n   스크롤 테스트 텍스트 4'''), // 수정: 삼중 따옴표 사용
                                  const TextSpan(text: '''\n   스크롤 테스트 텍스트 5'''), // 수정: 삼중 따옴표 사용
                                  const TextSpan(text: '''\n   스크롤 테스트 텍스트 6'''), // 수정: 삼중 따옴표 사용
                                  const TextSpan(text: '''\n   스크롤 테스트 텍스트 7'''), // 수정: 삼중 따옴표 사용
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0), // 오답 섹션과 버튼들 사이 간격

                  // 버튼들
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0), // 버튼 좌우 여백을 줄여 사이즈 조정
                    child: Column(
                      children: [
                        // 다시 도전하기 버튼
                        ElevatedButton(
                          onPressed: () {
                            // TODO: 다시 도전하기 액션
                            // Navigator.pushReplacementNamed(context, '/problem');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D2A1E), // main_page의 버튼 색상으로 변경
                            foregroundColor: Colors.white, // 글자색 흰색 유지
                            padding: const EdgeInsets.symmetric(vertical: 16.0), // 세로 패딩 유지
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48.0), // 모서리 둥글기 48.0으로 변경
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ), // 텍스트 스타일 유지
                            elevation: 6.0, // 그림자 효과 추가
                            minimumSize: const Size(double.infinity, 50), // 너비를 double.infinity로 설정
                          ),
                          child: const Text(
                            '다시 도전하기', // 이미지 참고
                          ),
                        ),
                        const SizedBox(height: 16.0), // 버튼 사이 간격

                        // 결과 공유하기 버튼
                        ElevatedButton(
                          onPressed: () {
                            // TODO: 결과 공유하기 액션
                          },
                           style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D2A1E), // main_page의 버튼 색상으로 변경
                            foregroundColor: Colors.white, // 글자색 흰색 유지
                            padding: const EdgeInsets.symmetric(vertical: 16.0), // 세로 패딩 유지
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48.0), // 모서리 둥글기 48.0으로 변경
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ), // 텍스트 스타일 유지
                            elevation: 6.0, // 그림자 효과 추가
                             minimumSize: const Size(double.infinity, 50), // 너비를 double.infinity로 설정
                          ),
                          child: const Text(
                            '결과 공유하기', // 이미지 참고
                          ),
                        ),
                        const SizedBox(height: 16.0), // 버튼 사이 간격

                        // 홈으로 돌아가기 버튼
                        ElevatedButton(
                          onPressed: () {
                            // 홈으로 돌아가기 액션
                             Navigator.pushAndRemoveUntil(
                               context,
                               MaterialPageRoute(builder: (context) => const MainPage()),
                               (Route<dynamic> route) => false, // 모든 이전 라우트 제거
                             );
                          },
                           style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D2A1E), // main_page의 버튼 색상으로 변경
                            foregroundColor: Colors.white, // 글자색 흰색 유지
                            padding: const EdgeInsets.symmetric(vertical: 16.0), // 세로 패딩 유지
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(48.0), // 모서리 둥글기 48.0으로 변경
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ), // 텍스트 스타일 유지
                            elevation: 6.0, // 그림자 효과 추가
                             minimumSize: const Size(double.infinity, 50), // 너비를 double.infinity로 설정
                          ),
                          child: const Text(
                            '홈으로 돌아가기', // 이미지 참고
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // 홈 아이콘
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box), // 하트 아이콘을 체크 박스 아이콘으로 변경
            label: '오답노트', // '찜'을 '오답노트'로 변경
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
        iconSize: 25.0, // 아이콘 크기 (메인/문제 페이지와 동일)
        onTap: (index) {
          // TODO: 탭 전환 로직 구현
        },
        type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 때 고정
      ),
    );
  }
} 