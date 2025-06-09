import 'package:flutter/material.dart';
import 'dart:ui';
import 'result_page.dart'; // 결과 페이지 임포트
import 'package:my_flutter_app/widgets/word_wrap_text.dart'; // WordWrapText 위젯 임포트
import 'dart:math';
import 'package:http/http.dart' as http; // http 패키지 임포트
import 'dart:convert'; // JSON 처리를 위한 임포트
import 'wrong_answer_note_page.dart'; // WrongAnswerNotePage 임포트
import 'main_page.dart'; // MainPage 임포트
import 'settings_page.dart'; // SettingsPage 임포트
import 'onboarding_page.dart'; // 온보딩 페이지 임포트

enum AnswerStatus {
  correct,
  incorrect,
}

class ProblemPage extends StatefulWidget {
  final List<dynamic> problems; // 문제 목록을 받을 필드 추가
  final String? sessionToken; // 세션 토큰 추가
  final String? displayName; // 사용자 닉네임 추가
  final String? studyLevel; // 학습 레벨 타입 String?으로 변경

  const ProblemPage({
    super.key,
    required this.problems,
    this.sessionToken,
    this.displayName, // 생성자에 닉네임 추가
    this.studyLevel, // 생성자에 학습 레벨 추가
  }); // 생성자 수정

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  AnswerStatus? _answerStatus; // 오버레이 상태를 AnswerStatus enum으로 관리
  int _currentProblemIndex = 0; // 현재 문제 인덱스
  int _score = 0; // 사용자 점수
  final List<dynamic> _incorrectProblems = []; // 틀린 문제를 저장할 리스트 추가
  final Random _random = Random(); // Random 객체 추가
  DateTime? _problemStartTime; // 문제 시작 시각

  // 문제를 풀고 정답/오답 상태를 업데이트하는 함수
  void _answerQuestion(String selectedWord, String correctWord) {
    setState(() {
      final currentProblem = widget.problems[_currentProblemIndex];
      final int questionId = currentProblem['question_id'];
      bool isCorrect = (selectedWord == correctWord);

      // 풀이 시간 측정
      double delayTime = 0.0;
      if (_problemStartTime != null) {
        delayTime = DateTime.now().difference(_problemStartTime!).inMilliseconds / 1000.0;
      }

      if (isCorrect) {
        _answerStatus = AnswerStatus.correct;
        _score += 10; // 정답 시 10점 추가
      } else {
        _answerStatus = AnswerStatus.incorrect;
        _incorrectProblems.add(currentProblem); // 틀린 문제 저장
      }
      
      // 백엔드에 풀이 결과 전송
      _submitAnswerToBackend(questionId, isCorrect, delayTime);
    });
  }

  // 백엔드에 풀이 결과 전송 함수
  Future<void> _submitAnswerToBackend(int questionId, bool correct, double delayTime) async {
    const String apiUrl = 'http://10.0.2.2:8000/api/study/submit';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'session_token': widget.sessionToken!,
          'question_id': questionId,
          'correct': correct,
          'delaytime': delayTime, // 실제 풀이 시간 전송
        }),
      );

      if (response.statusCode == 200) {
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
      }
    } catch (e) {
      print('문제 풀이 결과 제출 중 네트워크 오류: $e');
    }
  }

  // 다음 문제로 이동하거나 결과 페이지로 이동하는 함수
  void _goToNextProblem() {
    setState(() {
      _answerStatus = null; // 오버레이 숨기기
      if (_currentProblemIndex < widget.problems.length - 1) {
        _currentProblemIndex++; // 다음 문제로 이동
        _problemStartTime = DateTime.now(); // 다음 문제 시작 시각 기록
      } else {
        // 모든 문제 풀이 완료, 결과 페이지로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              score: _score,
              wrongProblems: _incorrectProblems,
              sessionToken: widget.sessionToken,
              displayName: widget.displayName, // 닉네임 전달
              studyLevel: widget.studyLevel, // 학습 레벨 전달
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 현재 문제 데이터
    final currentProblem = widget.problems[_currentProblemIndex];
    final String wrongSentence = currentProblem['wrong_sentence'];
    final String rightSentence = currentProblem['right_sentence'];
    final String wrongWord = currentProblem['wrong_word'];
    final String rightWord = currentProblem['right_word'];
    final String explanation = currentProblem['explanation'];

    // 선택지 순서를 무작위로 섞기
    List<String> options = [wrongWord, rightWord];
    options.shuffle();

    // wrong_sentence와 right_sentence 중 하나를 랜덤으로 선택하여 문제 텍스트로 사용
    final bool useWrongSentence = _random.nextBool();
    final String problemText = useWrongSentence ? wrongSentence : rightSentence;
    final String highlightedWord = useWrongSentence ? wrongWord : rightWord;

    // 문제 진입 시각 기록 (처음 문제 진입 또는 다음 문제로 이동 시)
    if (_problemStartTime == null) {
      _problemStartTime = DateTime.now();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E2), // 배경색
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
                          Positioned(
                            top: -13,
                            right: -5,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 36, color: Colors.black45),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
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
                          child: Text(
                            _problemNumberToKorean(_currentProblemIndex + 1), // 현재 문제 번호를 한국어로 표시
                            style: const TextStyle(
                              fontSize: 22, // 글자 크기 증가
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2A1E), // 갈색 텍스트
                            ),
                          ),
                        ),
                        const SizedBox(height: 48.0), // 문제 번호와 텍스트 사이 간격

                        // 문제 텍스트
                        WordWrapText(
                          textAlign: TextAlign.center,
                          fullText: problemText, // 선택된 문장을 전달
                          wrongWord: highlightedWord,   // 선택된 문장에 해당하는 단어를 하이라이트
                          baseStyle: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2A1E),
                            height: 1.5,
                          ),
                          highlightStyle: const TextStyle(
                            color: Color(0xFFE57373),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFE57373),
                            decorationThickness: 2.0,
                          ),
                        ),
                        const SizedBox(height: 48.0), // 문제 텍스트와 버튼 사이 간격

                        // 선택 버튼 1 (Wrong Word)
                        SizedBox(
                          width: 260.0,
                          child: ElevatedButton(
                            onPressed: _answerStatus == null
                                ? () => _answerQuestion(options[0], rightWord) // 선택지 클릭 시 _answerQuestion 호출
                                : null, // 답변 후 비활성화
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 흰색 배경
                              foregroundColor: Colors.black, // 글자색 검은색으로 변경
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // 패딩 조정
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Color(0xFFFDE68A), width: 1.0), // 이미지 기반 테두리 색상 (노란색 계열) 및 두께
                                borderRadius: BorderRadius.circular(48.0), // 이미지 기반 둥근 모서리
                              ),
                              elevation: 0, // 그림자 효과 제거
                            ),
                            child: Text(
                              options[0], // 무작위로 섞인 첫 번째 선택지 사용
                              style: const TextStyle(
                                fontSize: 17, // 텍스트 크기 증가
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0), // 버튼 사이 간격

                        // 선택 버튼 2 (Right Word)
                        SizedBox(
                          width: 260.0,
                          child: ElevatedButton(
                            onPressed: _answerStatus == null
                                ? () => _answerQuestion(options[1], rightWord) // 선택지 클릭 시 _answerQuestion 호출
                                : null, // 답변 후 비활성화
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // 흰색 배경
                              foregroundColor: Colors.black, // 글자색 검은색으로 변경
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0), // 패딩 조정
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(color: Color(0xFFFDE68A), width: 1.0), // 이미지 기반 테두리 색상 (노란색 계열) 및 두께
                                borderRadius: BorderRadius.circular(48.0), // 이미지 기반 둥근 모서리
                              ),
                              elevation: 0, // 그림자 효과 제거
                            ),
                            child: Text(
                              options[1], // 무작위로 섞인 두 번째 선택지 사용
                              style: const TextStyle(
                                fontSize: 17, // 텍스트 크기 증가
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
    // 현재 문제 데이터와 해설을 오버레이에 표시
    final currentProblem = widget.problems[_currentProblemIndex];
    final String rightSentence = currentProblem['right_sentence'];
    final String explanation = currentProblem['explanation'];

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
          alignment: const Alignment(0.0, 0.2), // 세로 방향으로 0.2만큼 이동 (아래로)
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
                      style: const TextStyle(
                        fontSize: 28, // 글자 크기를 이전 상태로 되돌림
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE57373), // 이미지 참고 (연한 빨강)
                      ),
                    ),
                    const SizedBox(height: 8.0), // 정답 텍스트와 문제 텍스트 사이 간격을 이전 상태로 되돌림

                    // 문제 텍스트 및 해설 (이미지 참고)
                    WordWrapText(
                      textAlign: TextAlign.center,
                      fullText: rightSentence, // 정답 문장
                      baseStyle: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16.0), // 정답 문장과 해설 사이 간격
                    WordWrapText(
                      textAlign: TextAlign.center,
                      fullText: explanation, // 해설 텍스트
                      baseStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20.0), // 해설과 버튼 사이 간격을 이전 상태로 되돌림

                    // 다음 문제로 버튼
                    ElevatedButton(
                      onPressed: _goToNextProblem, // 다음 문제로 이동 또는 결과 페이지로 이동
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC67C4E), // 0xFFC67C4E 색상으로 통일
                        foregroundColor: Colors.white, // 글자색 흰색
                        padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0), // 패딩
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // 둥근 모서리
                        ),
                      ),
                      child: Text(
                        _currentProblemIndex < widget.problems.length - 1 ? '다음 문제로' : '결과 보기', // 마지막 문제에 따라 텍스트 변경
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), // 볼드체 및 폰트 크기 조정
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

  String _problemNumberToKorean(int number) {
    switch (number) {
      case 1:
        return '하나';
      case 2:
        return '둘';
      case 3:
        return '셋';
      case 4:
        return '넷';
      case 5:
        return '다섯';
      case 6:
        return '여섯';
      case 7:
        return '일곱';
      case 8:
        return '여덟';
      case 9:
        return '아홉';
      case 10:
        return '열';
      default:
        return '문제 $number';
    }
  }
} 