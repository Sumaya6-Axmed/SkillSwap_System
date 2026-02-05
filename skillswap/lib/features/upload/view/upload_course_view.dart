import 'package:flutter/material.dart';

// CHANGE THIS IMPORT PATH to your real ApiService location
// Example (if your ApiService is in lib/core/services/api_service.dart):
// import '../../../core/services/api_service.dart';
import '../../../core/services/api_service.dart';

class UploadCourseView extends StatefulWidget {
  const UploadCourseView({super.key});

  @override
  State<UploadCourseView> createState() => _UploadCourseViewState();
}

class _UploadCourseViewState extends State<UploadCourseView> {
  final _title = TextEditingController();
  final _category = TextEditingController();
  final _description = TextEditingController();
  final _driveLink = TextEditingController();

  bool hasQuiz = false;

  bool _loading = false;

  @override
  void dispose() {
    _title.dispose();
    _category.dispose();
    _description.dispose();
    _driveLink.dispose();
    super.dispose();
  }

  Future<void> _publish() async {
    final title = _title.text.trim();
    final description = _description.text.trim();
    final driveLink = _driveLink.text.trim();

    //  Your backend requires: title, description, driveLink
    if (title.isEmpty || description.isEmpty || driveLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill Title, Description, and Drive link."),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final ok = await ApiService.createSkill(
        title: title,
        description: description,
        driveLink: driveLink,
      );

      if (!mounted) return;

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Course published: $title")),
        );

        // Go back to Home (so you can refresh your list)
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to publish. Try again.")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);
    const card = Color(0xFF1e293b);
    const accent = Color(0xFF14b8a6);

    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text("Upload Course"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create a new course",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Add course details, then provide your Google Drive link (slides/PDF/recordings).",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _input(
                    controller: _title,
                    label: "Course Title",
                    hint: "e.g. Flutter Basics",
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 12),
                  _input(
                    controller: _category,
                    label: "Category",
                    hint: "e.g. Programming",
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 12),
                  _input(
                    controller: _description,
                    label: "Description",
                    hint: "What will students learn?",
                    icon: Icons.description,
                    maxLines: 4,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Course materials",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _input(
                    controller: _driveLink,
                    label: "Google Drive link",
                    hint: "Paste a Drive folder link here",
                    icon: Icons.link,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.picture_as_pdf, color: Colors.white70),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "PDF / Slides will be inside Drive link",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.quiz, color: Colors.white70),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "Include a quiz for this course?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Switch(
                    value: hasQuiz,
                    activeColor: accent,
                    onChanged: (v) => setState(() => hasQuiz = v),
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _loading ? null : _publish,
                child: Text(
                  _loading ? "Publishing..." : "Publish Course",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}