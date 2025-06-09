import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui'; // BackdropFilter를 위해 임포트
import 'main_page.dart'; // MainPage 임포트 추가
import 'settings_page.dart'; // SettingsPage 임포트 추가
import 'onboarding_page.dart'; // 온보딩 페이지 임포트

// Enum for tail position
enum BubbleTailPosition { bottomLeft, bottomRight }

// CustomPainter for speech bubble shape
class SpeechBubblePainter extends CustomPainter {
  final Color bubbleColor;
  final double cornerRadius;
  final double tailHeight;
  final double tailWidth;
  final double tailOffset; // Offset from the left edge for the tail base

  SpeechBubblePainter({
    required this.bubbleColor,
    this.cornerRadius = 12.0,
    this.tailHeight = 10.0,
    this.tailWidth = 20.0,
    this.tailOffset = 30.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = bubbleColor..style = PaintingStyle.fill;
    final Path path = Path();

    final double width = size.width;
    final double height = size.height - tailHeight; // Main body height

    // Define the main rounded rectangle part
    path.moveTo(cornerRadius, 0);
    path.lineTo(width - cornerRadius, 0);
    path.arcToPoint(Offset(width, cornerRadius), radius: Radius.circular(cornerRadius));
    path.lineTo(width, height - cornerRadius);
    path.arcToPoint(Offset(width - cornerRadius, height), radius: Radius.circular(cornerRadius));

    // Add the tail (bottom-left)
    path.lineTo(tailOffset + tailWidth, height); // Right base of the tail
    path.lineTo(tailOffset + tailWidth / 2, height + tailHeight); // Tip of the tail
    path.lineTo(tailOffset, height); // Left base of the tail

    path.lineTo(cornerRadius, height);
    path.arcToPoint(Offset(0, height - cornerRadius), radius: Radius.circular(cornerRadius));
    path.lineTo(0, cornerRadius);
    path.arcToPoint(Offset(cornerRadius, 0), radius: Radius.circular(cornerRadius));

    path.close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is SpeechBubblePainter) {
      return oldDelegate.bubbleColor != bubbleColor ||
             oldDelegate.cornerRadius != cornerRadius ||
             oldDelegate.tailHeight != tailHeight ||
             oldDelegate.tailWidth != tailWidth ||
             oldDelegate.tailOffset != tailOffset;
    }
    return false;
  }
}

class WrongAnswerNotePage extends StatefulWidget {
  final String? sessionToken;
  final String? displayName;
  final String? studyLevel;

  const WrongAnswerNotePage({
    super.key,
    this.sessionToken,
    this.displayName,
    this.studyLevel,
  });

  @override
  _WrongAnswerNotePageState createState() => _WrongAnswerNotePageState();
}

class _WrongAnswerNotePageState extends State<WrongAnswerNotePage> {
  List<dynamic> _wrongProblems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Function to build text spans for highlighting
  List<TextSpan> _buildTextSpans(String fullText, String highlightWord, Color highlightColor) {
    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    while ((indexOfHighlight = fullText.indexOf(highlightWord, start)) != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(text: fullText.substring(start, indexOfHighlight)));
      }
      spans.add(
        TextSpan(
          text: highlightWord,
          style: TextStyle(
            color: highlightColor,
            decoration: TextDecoration.none,
          ),
        ),
      );
      start = indexOfHighlight + highlightWord.length;
    }

    if (start < fullText.length) {
      spans.add(TextSpan(text: fullText.substring(start)));
    }
    return spans;
  }

  @override
  void initState() {
    super.initState();
    _fetchWrongProblems();
  }

  Future<void> _fetchWrongProblems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    if (widget.sessionToken == null) {
      setState(() {
        _errorMessage = '세션 토큰이 없습니다. 다시 로그인 해주세요.';
        _isLoading = false;
      });
      return;
    }

    const String apiUrl = 'http://10.0.2.2:8000/api/study/recent-wrong';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'session_token': widget.sessionToken!,
          'limit': '100', // 더 많은 틀린 문제를 가져오기 위해 limit을 충분히 크게 설정
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        setState(() {
          _wrongProblems = responseBody['recent_wrong_answers'];
          _isLoading = false;
        });
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorBody['detail'] ?? '틀린 문제를 불러오지 못했습니다.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '네트워크 오류가 발생했습니다: $e';
        _isLoading = false;
      });
    }
  }

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
            icon: Icon(Icons.power_settings_new), // 종료에 어울리는 파워 아이콘
            label: '종료',
          ),
        ],
        currentIndex: 1, // 오답노트 탭을 선택된 상태로 설정
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
            // 현재 페이지이므로 아무것도 하지 않음
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
      body: Column(
        children: <Widget>[
          // 헤더 콘텐츠 (기존 헤더 영역에서 분리)
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

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
                    : _wrongProblems.isEmpty
                        ? const Center(child: Text('아직 틀린 문제가 없습니다.', style: TextStyle(fontSize: 18, color: Colors.grey)))
                        : SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '최근에 틀린 문장',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2A1E),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                ..._wrongProblems.asMap().entries.map<Widget>((entry) {
                                  final int index = entry.key;
                                  final Map<String, dynamic> problem = entry.value;
                                  final String wrongSentence = problem['wrong_sentence'];
                                  final String rightSentence = problem['right_sentence'];
                                  final String wrongWord = problem['wrong_word'];
                                  final String explanation = problem['explanation'];

                                  final int wrongWordStart = wrongSentence.indexOf(wrongWord);
                                  final int wrongWordEnd = wrongWordStart + wrongWord.length;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0), // 각 카드 사이 간격 조정
                                    child: CustomPaint(
                                      painter: SpeechBubblePainter(bubbleColor: Colors.white), // 말풍선 색상 흰색으로 설정
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0 + 10.0), // 하단 꼬리 높이만큼 패딩 추가
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 문제 번호와 틀린 문장을 한 줄에 표시 (Row 제거)
                                            RichText(
                                              text: TextSpan(
                                                style: DefaultTextStyle.of(context).style.copyWith(
                                                  fontSize: 16, // 문제 본문 폰트 크기
                                                  color: const Color(0xFF2D2A1E), // 기본 색상 (어두운 갈색)
                                                  height: 1.5,
                                                  decoration: TextDecoration.none,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: '${index + 1}. ',
                                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // 문제 번호 굵게 및 크기 조정
                                                  ),
                                                  ..._buildTextSpans(wrongSentence, wrongWord, Colors.red),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8.0), // 틀린 문장과 바른 문장 사이 간격 조정
                                            // 바른 문장 (정답: 접두사 추가, RichText 제거)
                                            Text(
                                              '정답: $rightSentence',
                                              style: const TextStyle(
                                                fontSize: 15, // 해설과 같은 폰트 크기
                                                color: Colors.blue, // 파란색
                                                fontWeight: FontWeight.normal, // 굵지 않게
                                                height: 1.5,
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            // 해설 (해설: 접두사 추가)
                                            Text(
                                              '해설: $explanation',
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
          ),
        ],
      ),
    );
  }
} 