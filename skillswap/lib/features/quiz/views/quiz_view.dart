import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  final String courseTitle;

  const QuizView({super.key, required this.courseTitle});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  int current = 0;
  int score = 0;
  bool submitted = false;

  // Dummy questions for now (later from backend)
  final List<Map<String, dynamic>> questions = [
    {
      "q": "What is Flutter mainly used for?",
      "options": ["Mobile apps", "Cooking", "Banking only", "Gaming only"],
      "answer": 0
    },
    {
      "q": "Which language is used in Flutter?",
      "options": ["Java", "Python", "Dart", "C++"],
      "answer": 2
    },
    {
      "q": "What is a Widget in Flutter?",
      "options": ["A UI component", "A database", "A server", "A file type"],
      "answer": 0
    },
    {
      "q": "What does UI stand for?",
      "options": ["User Interface", "Universal Input", "User Internet", "Unit Icon"],
      "answer": 0
    },
    {
      "q": "What is the purpose of setState()?",
      "options": [
        "Update UI",
        "Delete app",
        "Create database",
        "Upload to Drive"
      ],
      "answer": 0
    },
  ];

  // store selected option per question
  final Map<int, int> selected = {};

  void next() {
    if (current < questions.length - 1) {
      setState(() => current++);
    }
  }

  void prev() {
    if (current > 0) {
      setState(() => current--);
    }
  }

  void submitQuiz() {
    // calculate score
    int s = 0;
    for (int i = 0; i < questions.length; i++) {
      final correct = questions[i]["answer"] as int;
      final chosen = selected[i];
      if (chosen != null && chosen == correct) s++;
    }

    setState(() {
      score = s;
      submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);
    const surface = Color(0xFF1e293b);
    const accent = Color(0xFF14b8a6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Quiz • ${widget.courseTitle}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: submitted
            ? _ResultCard(
          score: score,
          total: questions.length,
          onRetry: () {
            setState(() {
              submitted = false;
              selected.clear();
              current = 0;
              score = 0;
            });
          },
        )
            : Column(
          children: [
            // progress
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (current + 1) / questions.length,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(accent),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${current + 1}/${questions.length}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // question card
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: _QuestionBlock(
                  question: questions[current]["q"] as String,
                  options:
                  (questions[current]["options"] as List).cast<String>(),
                  selectedIndex: selected[current],
                  onSelect: (i) {
                    setState(() {
                      selected[current] = i;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // nav buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.25)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: current == 0 ? null : prev,
                    child: const Text("Previous"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (current == questions.length - 1) {
                        submitQuiz();
                      } else {
                        next();
                      }
                    },
                    child: Text(
                      current == questions.length - 1 ? "Submit" : "Next",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionBlock extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedIndex;
  final Function(int) onSelect;

  const _QuestionBlock({
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF14b8a6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(options.length, (i) {
          final active = selectedIndex == i;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active ? accent : Colors.white12,
                    width: active ? 1.6 : 1,
                  ),
                  color: active ? accent.withOpacity(0.12) : Colors.white.withOpacity(0.04),
                ),
                child: Row(
                  children: [
                    Icon(
                      active ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: active ? accent : Colors.white54,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        options[i],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRetry;

  const _ResultCard({
    required this.score,
    required this.total,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF1e293b);
    const accent = Color(0xFF14b8a6);

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: accent, size: 48),
            const SizedBox(height: 10),
            const Text(
              "Quiz Finished!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your score: $score / $total",
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Retry
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onRetry,
                child: const Text(
                  "Retry Quiz",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Back to Course
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.25)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Back to Course",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}