import 'package:flutter/material.dart';
import 'problem_page.dart'; // 문제 페이지 임포트

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2), // 온보딩/로그인 페이지와 동일한 배경색 사용
      body: Column(
        children: <Widget>[
          // 헤더 콘텐츠 (기존 헤더 영역에서 분리)
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
                      height: 50.0, // 이미지 높이 키움
                    ),
                  ),
                  const SizedBox(height: 18.0), // 이미지와 구분선 사이 간격 조정
                  const Divider(height: 1.0, thickness: 0.5, color: Colors.grey), // 새로운 구분선 추가
                ],
              ),
            ),
          ),

          // 스크롤 가능한 본문 영역
          Expanded(
            child: SafeArea(
              bottom: false, // 하단 시스템 바 영역까지 콘텐츠 확장
              top: false, // 상단 시스템 바 영역 패딩 제거
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 18.0), // 좌우 및 상하 여백 조정 (아래로 내림)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 사용자 정보 섹션
                    Row(
                      children: [
                        // TODO: 사용자 아이콘 이미지 추가
                        // CircleAvatar( // 예시: 사용자 프로필 이미지
                        //   radius: 30,
                        //   backgroundColor: Colors.grey[300],
                        //   child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
                        // ),
                        const SizedBox(width: 8.0), // 아이콘과 텍스트 사이 간격
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '{USER_NICKNAME} 님, 반가워요',
                              style: TextStyle(
                                fontSize: 14, // 텍스트 크기 줄임
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2A1E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12.0), // 사용자 정보와 다음 섹션 간 간격 조정

                    // 누적 학습 현황 카드
                    Card(
                      color: Colors.white, // 카드 배경색
                      elevation: 2.0, // 그림자 효과
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '누적 학습현황',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2A1E),
                              ),
                            ),
                            const Divider(height: 24.0), // 구분선
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      '평균 풀이 시간',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF8B6E4C),
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '오늘의 정답률',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF8B6E4C),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: const [
                                        Text(
                                          '90%',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D2A1E),
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          '90%',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D2A1E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16.0), // 텍스트와 원형 표시 사이 간격
                                    Container(
                                      width: 60, // 원형 크기
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFFFBCFE8), // 연한 분홍색 테두리
                                          width: 4.0,
                                        ),
                                        color: const Color(0xFFFBCFE8).withOpacity(0.3), // 연한 분홍색 배경
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'S',
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE57373), // 연한 빨강색
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24.0), // 누적 학습 현황 카드와 다음 섹션 간 간격 조정

                    // 최근에 틀린 문장 섹션
                    Card(
                      color: Colors.white, // 카드 배경색
                      elevation: 2.0, // 그림자 효과
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '최근에 틀린 문장',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2A1E),
                              ),
                            ),
                            Divider(height: 24.0), // 구분선
                            // TODO: 실제 틀린 문장 목록 표시
                            SizedBox(
                              height: 80.0, // 이미지에 맞춰 임시 높이 설정
                              // child: ListView.builder(...), // 실제 목록을 표시할 위젯
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24.0), // 최근에 틀린 문장 카드와 다음 섹션 간 간격 조정

                    // 카테고리별/난이도별 학습현황 섹션 (나란히 배치)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '카테고리별 학습현황',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D2A1E),
                                    ),
                                  ),
                                  Divider(height: 24.0), // 구분선
                                  // TODO: 카테고리별 학습 현황 그래프/표시 추가
                                  SizedBox(height: 60.0), // 이미지에 맞춰 임시 높이
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0), // 두 카드 사이 간격
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '난이도별 학습현황',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D2A1E),
                                    ),
                                  ),
                                  Divider(height: 24.0), // 구분선
                                  // TODO: 난이도별 학습 현황 그래프/표시 추가
                                   SizedBox(height: 60.0), // 이미지에 맞춰 임시 높이
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24.0), // 학습 현황 카드와 버튼 간 간격 조정

                    // 오늘의 문제 풀어보기 버튼
                    ElevatedButton(
                      onPressed: () {
                        // 문제 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProblemPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                           backgroundColor: const Color(0xFF2D2A1E), // 갈색 배경색으로 변경
                           foregroundColor: Colors.white, // 글자색 흰색으로 변경
                           padding: const EdgeInsets.symmetric(vertical: 16.0), // 이미지 기반 패딩
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(48.0), // 이미지 기반 둥근 모서리
                           ),
                           minimumSize: const Size(double.infinity, 50), // 너비를 double.infinity로 설정
                           textStyle: const TextStyle(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                           ), // 이미지 기반 텍스트 스타일
                           elevation: 6, // 이미지 기반 그림자
                       ),
                       child: const Text('오늘의 문제 풀어보기'), // 버튼 텍스트
                     ),

                    // TODO: 하단 네비게이션 바 추가

                  ],
                ),
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
        iconSize: 25.0, // 아이콘 크기 늘리기
        onTap: (index) {
          // TODO: 탭 전환 로직 구현
        },
        type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 때 고정
      ),
    );
  }
} 