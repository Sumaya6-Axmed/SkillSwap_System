import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../../app/app_routes.dart';

class SessionRequestView extends StatefulWidget {
  const SessionRequestView({super.key});

  @override
  State<SessionRequestView> createState() => _SessionRequestViewState();
}

class _SessionRequestViewState extends State<SessionRequestView> {
  final topicCtrl = TextEditingController();
  final msgCtrl = TextEditingController();

  DateTime? preferredDate;
  TimeOfDay? preferredTime;

  bool submitting = false;

  @override
  void dispose() {
    topicCtrl.dispose();
    msgCtrl.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => preferredDate = picked);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => preferredTime = picked);
  }

  DateTime? get scheduledAt {
    // backend: scheduledAt optional
    if (preferredDate == null || preferredTime == null) return null;

    return DateTime(
      preferredDate!.year,
      preferredDate!.month,
      preferredDate!.day,
      preferredTime!.hour,
      preferredTime!.minute,
    );
  }

  String get dateText {
    if (preferredDate == null) return "Preferred date (optional)";
    return "${preferredDate!.year}-${preferredDate!.month.toString().padLeft(2, '0')}-${preferredDate!.day.toString().padLeft(2, '0')}";
  }

  String get timeText {
    if (preferredTime == null) return "Preferred time (optional)";
    final h = preferredTime!.hourOfPeriod == 0 ? 12 : preferredTime!.hourOfPeriod;
    final m = preferredTime!.minute.toString().padLeft(2, '0');
    final ampm = preferredTime!.period == DayPeriod.am ? "AM" : "PM";
    return "$h:$m $ampm";
  }

  Future<void> submit() async {
    final args = (Get.arguments ?? {}) as Map;

    final courseTitle = (args["title"] ?? "Course").toString();
    final tutorName = (args["tutor"] ?? "Tutor").toString();
    final skillId = (args["skillId"] ?? "").toString().trim(); // trim

    //  HARD GUARD: prevent 400 skillId is required
    if (skillId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Missing skillId . Go back and open the course again."),
        ),
      );
      return;
    }

    final topic = topicCtrl.text.trim();
    final msg = msgCtrl.text.trim();

    // backend supports one field: message
    final combinedMessage = [
      if (topic.isNotEmpty) "Topic: $topic",
      if (msg.isNotEmpty) msg,
      if (topic.isEmpty && msg.isEmpty)
        "Request from learner for: $courseTitle (Tutor: $tutorName)",
    ].join("\n");

    setState(() => submitting = true);

    final ok = await ApiService.requestSession(
      skillId: skillId, //  MUST match backend: req.body.skillId
      scheduledAt: scheduledAt, //  nullable allowed (backend optional)
      message: combinedMessage,
    );

    if (!mounted) return;
    setState(() => submitting = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session request sent ")),
      );
      Get.offAllNamed(AppRoutes.sessionsList);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to request session ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);
    const surface = Color(0xFF1e293b);

    final args = (Get.arguments ?? {}) as Map;
    final courseTitle = (args["title"] ?? "Course").toString();
    final tutorName = (args["tutor"] ?? "Tutor").toString();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text("Request Tutoring"),
        backgroundColor: bg,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tutor: $tutorName",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // form card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _input(
                    controller: topicCtrl,
                    label: "Topic",
                    hint: "What do you need help with?",
                    icon: Icons.bookmark_add,
                  ),
                  const SizedBox(height: 12),
                  _input(
                    controller: msgCtrl,
                    label: "Message",
                    hint: "Explain your request...",
                    icon: Icons.message,
                    maxLines: 5,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // optional schedule
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Preferred schedule (optional)",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateText),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(timeText),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // submit
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: submitting ? null : submit,
                child: Text(submitting ? "Submitting..." : "Submit Request"),
              ),
            ),
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