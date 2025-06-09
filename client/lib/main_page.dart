import 'package:flutter/material.dart';
import 'problem_page.dart'; // 문제 페이지 임포트
import 'package:http/http.dart' as http; // http 패키지 임포트
import 'dart:convert'; // JSON 처리를 위한 임포트
import 'wrong_answer_note_page.dart'; // WrongAnswerNotePage 임포트
import 'settings_page.dart'; // SettingsPage 임포트
import 'widgets/gauge_bar.dart'; // GaugeBar 위젯 임포트
import 'dart:io'; // exit(0) 사용을 위해 추가
import 'onboarding_page.dart'; // 온보딩 페이지 임포트

class MainPage extends StatefulWidget { // StatelessWidget에서 StatefulWidget으로 변경
  final String? sessionToken; // 로그인 페이지로부터 세션 토큰을 받을 수 있도록 추가
  final bool fetchRecommendationsOnLoad; // 페이지 로드 시 추천 문제를 가져올지 여부
  final String? displayName; // 사용자 닉네임 추가
  final String? studyLevel; // 학습 레벨 타입 String?으로 변경

  const MainPage({super.key, this.sessionToken, this.fetchRecommendationsOnLoad = false, this.displayName, this.studyLevel});

  @override
  _MainPageState createState() => _MainPageState(); // State 생성
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = false; // 로딩 상태를 관리하는 변수
  int? _totalQuestions;
  double? _averageTime;
  double? _todayCorrectRate;
  List<dynamic> _categoryStats = [];
  List<dynamic> _difficultyStats = [];
  double? _totalLearningTime;

  @override
  void initState() {
    super.initState();
    _fetchStudyStats(); // 학습 통계 가져오기
    if (widget.fetchRecommendationsOnLoad) {
      _fetchRecommendations();
    }
  }

  Future<void> _fetchStudyStats() async {
    if (widget.sessionToken == null) {
      return;
    }

    // 1. 학습 통계 (카테고리별)
    const String statsApiUrl = 'http://10.0.2.2:8000/api/study/stats';
    try {
      final response = await http.post(
        Uri.parse(statsApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'session_token': widget.sessionToken!,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          _categoryStats = responseBody['category_stats'] ?? [];
          _difficultyStats = responseBody['difficulty_stats'] ?? [];
        });
      }
    } catch (e) {
      print('카테고리 학습 통계 불러오기 중 네트워크 오류: $e');
    }

    // 2. 최근 학습 기록 (총 문제 수, 평균 풀이 시간)
    const String historyApiUrl = 'http://10.0.2.2:8000/api/study/recent-history';
    try {
      final response = await http.post(
        Uri.parse(historyApiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'session_token': widget.sessionToken!,
          'limit': '1', // 최신 1개 기록만 가져와도 통계는 전체를 기반으로 함
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final Map<String, dynamic>? timeStats = responseBody['time_stats'];
        setState(() {
          _totalQuestions = timeStats?['total_questions'];
          _averageTime = (timeStats?['average_time'] as num?)?.toDouble();
          _totalLearningTime = (timeStats?['total_time'] as num?)?.toDouble(); // 총 학습 시간 추가
          // today_correct_rate는 현재 백엔드에서 제공되지 않으므로 임시로 null
          _todayCorrectRate = null;
        });
      }
    } catch (e) {
      print('최근 학습 기록 불러오기 중 네트워크 오류: $e');
    }
  }

  // 추천 문제 가져오는 로직 함수
  Future<void> _fetchRecommendations() async {
    setState(() {
      _isLoading = true; // 로딩 시작
    });

    // TODO: 실제 세션 토큰을 로그인 시 저장하고 불러와 사용하도록 변경
    final String? currentSessionToken = widget.sessionToken; // 로그인 페이지에서 받은 세션 토큰 사용
    // print('전송할 세션 토큰: $currentSessionToken'); // 디버깅을 위해 세션 토큰 출력
    // 임시 토큰 (테스트용, 실제 구현 시 제거)
    // if (currentSessionToken == null) {
    //   _showAlertDialog('오류', '세션 토큰이 없습니다. 다시 로그인 해주세요.');
    //   setState(() { _isLoading = false; });
    //   return;
    // }

    const String baseUrl = 'http://10.0.2.2:8000/api/recommendations/';

    try {
      // 1. 새로운 추천 ID 생성 요청
      final response1 = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'session_token': currentSessionToken!, // 이제 null이 아님을 확인했으므로 강제 언래핑
        }),
      );

      if (response1.statusCode != 200) {
        final Map<String, dynamic> errorBody = jsonDecode(response1.body);
        _showAlertDialog('추천 생성 오류', errorBody['detail'] ?? '추천 ID 생성에 실패했습니다.');
        setState(() { _isLoading = false; });
        return;
      }

      final Map<String, dynamic> responseBody1 = jsonDecode(response1.body);
      final String recId = responseBody1['rec_id'];

      // 2. 생성된 추천 ID로 추천 문제 목록 가져오기
      final response2 = await http.post(
        Uri.parse(baseUrl + 'success'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'rec_id': recId,
        }),
      );

      if (response2.statusCode == 200) {
        final Map<String, dynamic> responseBody2 = jsonDecode(response2.body);
        final List<dynamic> recommendations = responseBody2['recommendation'];

        if (recommendations.isNotEmpty) {
          // ProblemPage로 문제 목록 전달
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProblemPage(
                problems: recommendations,
                sessionToken: currentSessionToken,
                displayName: widget.displayName, // 닉네임 전달
                studyLevel: widget.studyLevel, // 학습 레벨 전달
              ),
            ),
          );
        } else {
          _showAlertDialog('알림', '추천 문제를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.');
        }
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response2.body);
        _showAlertDialog('추천 문제 오류', errorBody['detail'] ?? '추천 문제 목록을 불러오지 못했습니다.');
      }
    } catch (e) {
      _showAlertDialog('네트워크 오류', '추천 문제를 불러오는 중 네트워크 오류가 발생했습니다: $e');
    } finally {
      setState(() {
        _isLoading = false; // 로딩 종료
      });
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
      backgroundColor: const Color(0xFFFFF8E2), // 온보딩/로그인 페이지와 동일한 배경색 사용
      body: Column(
        children: <Widget>[
          // 헤더 콘텐츠 (기존 헤더 영역에서 분리)
          SafeArea( // 헤더 콘텐츠에만 SafeArea 적용하여 상태 표시줄 아래 배치
            bottom: false, // 하단 시스템 바 영역은 피하지 않음
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // 원래 수직 패딩 유지
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
                padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 8.0), // 좌우 및 상하 여백 조정 (아래로 내림)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 사용자 정보 섹션
                    Row(
                      children: [
                        const SizedBox(width: 10.0), // 아이콘과 텍스트 사이 간격
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.displayName ?? '사용자'} 님, 반가워요!', // 사용자 닉네임 표시
                              style: const TextStyle(
                                fontSize: 19, // 텍스트 크기 줄임
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2A1E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 4.0), // 사용자 정보와 다음 섹션 간 간격 조정

                    // 누적 학습 현황 카드
                    Card(
                      color: Colors.white, // 카드 배경색
                      elevation: 0.0, // 그림자 효과 제거 (2.0에서 0.0으로 변경)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
                        side: const BorderSide(color: Color(0xFFFDE68A), width: 1.0), // 테두리 추가
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
                            Row( // 전체 박스 내의 주요 Row
                              children: [
                                Expanded( // 왼쪽 영역: 통계 항목들
                                  flex: 2, // 왼쪽 영역이 더 좁게 차지하도록 flex 비율 조정 (3에서 2로 변경)
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 평균 풀이 시간
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 레이블과 값 사이 공간 분할
                                        children: [
                                          const Text(
                                            '평균 풀이 시간',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF8B6E4C),
                                            ),
                                          ),
                                          Text(
                                            _averageTime != null ? '${_averageTime!.toStringAsFixed(1)}s' : '-',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2D2A1E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0), // 각 통계 항목 Row 사이 간격
                                      // 나의 정답률
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '나의 정답률',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF8B6E4C),
                                            ),
                                          ),
                                          Text(
                                            (() {
                                              int total = 0;
                                              int correct = 0;
                                              for (final stat in _categoryStats) {
                                                total += (stat['total'] ?? 0) as int;
                                                correct += (stat['correct'] ?? 0) as int;
                                              }
                                              if (total == 0) return '-';
                                              return '${(correct / total * 100).toStringAsFixed(0)}%';
                                            })(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2D2A1E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      // 총 문제 풀이 수
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '총 문제 풀이 수',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF8B6E4C),
                                            ),
                                          ),
                                          Text(
                                            _totalQuestions != null ? '${_totalQuestions!}개' : '-',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2D2A1E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8.0),
                                      // 총 학습 시간
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '총 학습 시간',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF8B6E4C),
                                            ),
                                          ),
                                          Text(
                                            _totalLearningTime != null ? '${(_totalLearningTime! / 60).toStringAsFixed(0)}분' : '-',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2D2A1E),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded( // 오른쪽 영역: studyLevel 원형 박스
                                  flex: 1, // studyLevel 영역이 더 적은 공간을 차지하도록 flex 비율 조정
                                  child: Align(
                                    alignment: Alignment.centerRight, // 오른쪽 가운데 정렬
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5.0), // 오른쪽에 여백 추가
                                      child: Container(
                                        width: 65, // 원형 크기
                                        height: 65,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: (widget.studyLevel == 'S' || widget.studyLevel == null) ? const Color(0xFFFBCFE8) : (widget.studyLevel == 'A' ? const Color(0xFFA5D6A7) : const Color(0xFF90CAF9)),
                                            width: 4.0,
                                          ),
                                          color: (widget.studyLevel == 'S' || widget.studyLevel == null) ? const Color(0xFFFBCFE8).withOpacity(0.3) : (widget.studyLevel == 'A' ? const Color(0xFFA5D6A7).withOpacity(0.3) : const Color(0xFF90CAF9).withOpacity(0.3)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.studyLevel ?? 'B',
                                            style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                              color: (widget.studyLevel == 'S' || widget.studyLevel == null) ? const Color(0xFFE57373) : (widget.studyLevel == 'A' ? const Color(0xFF388E3C) : const Color(0xFF1976D2)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0), // 누적 학습 현황 카드와 다음 섹션 간 간격 조정

                    // 카테고리별/난이도별 학습현황 섹션 (세로 배치)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          color: Colors.white,
                          elevation: 0.0, // 그림자 효과 제거 (2.0에서 0.0으로 변경)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Color(0xFFFDE68A), width: 1.0), // 테두리 추가
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '카테고리별 학습현황',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2A1E),
                                  ),
                                ),
                                const Divider(height: 22.0), // 구분선
                                if (_categoryStats.isEmpty)
                                  const Text('카테고리 학습 기록 없음', style: TextStyle(color: Colors.grey))
                                else
                                  Column(
                                    children: [
                                      'Category 0', 'Category 1', 'Category 2'
                                    ].map((catKey) {
                                      final stat = _categoryStats.firstWhere(
                                        (s) => s['category'] == catKey,
                                        orElse: () => null,
                                      );
                                      if (stat == null) return const SizedBox.shrink();
                                      String label = '';
                                      if (catKey == 'Category 0') label = '문법';
                                      if (catKey == 'Category 1') label = '어휘';
                                      if (catKey == 'Category 2') label = '띄어쓰기';
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(label, style: const TextStyle(fontSize: 14)),
                                                Text('${((stat['correct'] ?? 0) / (stat['total'] ?? 1) * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            GaugeBar(
                                              percentage: ((stat['correct'] ?? 0) / (stat['total'] ?? 1) * 100),
                                              backgroundColor: const Color(0xFFFDE68A).withOpacity(0.5),
                                              foregroundColor: const Color(0xFF2D2A1E),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                const SizedBox(height: 8.0), // 간격 조정
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0), // 두 카드 사이 세로 간격
                        Card(
                          color: Colors.white, // 디버깅용 배경색 제거
                          elevation: 0.0, // 그림자 효과 제거 (2.0에서 0.0으로 변경)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Color(0xFFFDE68A), width: 1.0), // 테두리 추가
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '난이도별 학습현황',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2A1E),
                                  ),
                                ),
                                const Divider(height: 22.0), // 구분선
                                if (_difficultyStats.isEmpty)
                                  const Center(
                                    child: Text(
                                      '난이도별 학습 기록 없음',
                                      style: TextStyle(color: Colors.grey), // 원래 스타일로 복원
                                    ),
                                  )
                                else
                                  Column(
                                    children: [1, 2, 3, 4, 5].map((levelKey) {
                                      final stat = _difficultyStats.firstWhere(
                                        (s) => s['level'] == levelKey || s['level'] == levelKey.toString(),
                                        orElse: () => null,
                                      );
                                      if (stat == null) return const SizedBox.shrink();
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(levelKey.toString(), style: const TextStyle(fontSize: 14)),
                                                Text('${((stat['correct'] ?? 0) / (stat['total'] ?? 1) * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            const SizedBox(height: 4.0),
                                            GaugeBar(
                                              percentage: ((stat['correct'] ?? 0) / (stat['total'] ?? 1) * 100),
                                              backgroundColor: const Color(0xFFFDE68A).withOpacity(0.5),
                                              foregroundColor: const Color(0xFF2D2A1E),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                const SizedBox(height: 8.0), // 간격 조정
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16.0), // 학습 현황 카드와 버튼 간 간격 조정

                    // 오늘의 문제 풀어보기 버튼
                    ElevatedButton(
                      onPressed: _isLoading ? null : _fetchRecommendations, // 로딩 중에는 버튼 비활성화
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D2A1E), // 이미지 기반 배경색 (어두운 갈색)
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
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white) // 로딩 중일 때 인디케이터 표시
                          : const Text(
                              '오늘의 문제 풀어보기',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),

                    const SizedBox(height: 16.0), // 버튼과 화면 하단 사이 여백

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
            icon: Icon(Icons.check_box), // 오답노트 아이콘
            label: '오답노트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.power_settings_new), // 종료에 어울리는 파워 아이콘
            label: '종료',
          ),
        ],
        currentIndex: 0, // TODO: 현재 선택된 탭 인덱스 관리
        selectedItemColor: const Color(0xFF2D2A1E),
        unselectedItemColor: const Color(0xFF8B6E4E),
        backgroundColor: const Color(0xFFFFF8E2),
        iconSize: 25.0,
        onTap: (index) {
          if (index == 0) {
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
          } else if (index == 1) {
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
          } else if (index == 2) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Stack(
                        children: [
                          // X 닫기 버튼 (오버레이 우측 상단)
                          Positioned(
                            top: -13,
                            right: -5,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 36, color: Colors.black45),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          // 실제 오버레이 콘텐츠
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 8),
                              Image.asset('assets/images/quit.png', height: 80),
                              const SizedBox(height: 16),
                              const Text(
                                '그만 두시나요?',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '진행상황은 저장되지 않습니다.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: SizedBox(
                                  width: 180,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => const OnboardingPage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2D2A1E),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(48.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      elevation: 6.0,
                                    ),
                                    child: const Text('나가기'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
} 