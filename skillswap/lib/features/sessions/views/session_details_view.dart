import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';

class SessionDetailsView extends StatefulWidget {
  const SessionDetailsView({super.key});

  @override
  State<SessionDetailsView> createState() => _SessionDetailsViewState();
}

class _SessionDetailsViewState extends State<SessionDetailsView> {
  late final Map args;

  late String sessionId;
  late String skill;
  late String tutor;
  late String student;
  late String date;
  late String message;

  late String prettyStatus; // Pending / Approved / Rejected / Completed ...
  late String rawStatus;    // pending / accepted / rejected / completed ...
  late int tabIndex;        // 0 = My Requests, 1 = Teaching

  bool working = false;

  @override
  void initState() {
    super.initState();
    args = (Get.arguments ?? {}) as Map;

    sessionId = (args["sessionId"] ?? "").toString();
    skill = (args["skill"] ?? "Skill").toString();
    tutor = (args["tutor"] ?? "Tutor").toString();
    student = (args["student"] ?? "Student").toString();
    date = (args["date"] ?? "").toString();
    message = (args["message"] ?? "—").toString();

    prettyStatus = (args["status"] ?? "Pending").toString();
    rawStatus = (args["rawStatus"] ?? "pending").toString();
    tabIndex = (args["tabIndex"] ?? 0) as int;
  }

  bool get isTutorView => tabIndex == 1;
  bool get isPending => rawStatus == "pending";
  bool get isAccepted => rawStatus == "accepted";

  Future<void> _respond(String newStatus) async {
    if (sessionId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Missing sessionId ")),
      );
      return;
    }

    setState(() => working = true);

    final ok = await ApiService.respondToSession(
      sessionId: sessionId,
      status: newStatus, // "accepted" or "rejected"
    );

    if (!mounted) return;
    setState(() => working = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to $newStatus ")),
      );
      return;
    }

    setState(() {
      rawStatus = newStatus;
      prettyStatus = _prettyStatus(newStatus);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Session ${_prettyStatus(newStatus)} ")),
    );

    Get.back(result: true); // refresh list
  }

  //  NEW: Mark completed (backend)
  Future<void> _complete() async {
    if (sessionId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Missing sessionId ❌")),
      );
      return;
    }

    setState(() => working = true);

    final ok = await ApiService.completeSession(sessionId: sessionId);

    if (!mounted) return;
    setState(() => working = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to complete session ")),
      );
      return;
    }

    setState(() {
      rawStatus = "completed";
      prettyStatus = _prettyStatus("completed");
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Marked as completed ")),
    );

    Get.back(result: true); // refresh list
  }

  String _prettyStatus(String raw) {
    switch (raw) {
      case "pending":
        return "Pending";
      case "accepted":
        return "Approved";
      case "rejected":
        return "Rejected";
      case "completed":
        return "Completed";
      case "cancelled":
        return "Cancelled";
      default:
        return raw;
    }
  }

  Color _statusColor(String pretty) {
    const accent = Color(0xFF14b8a6);
    if (pretty == "Pending") return Colors.amber;
    if (pretty == "Approved") return accent;
    if (pretty == "Completed") return Colors.lightGreenAccent;
    if (pretty == "Rejected") return Colors.redAccent;
    if (pretty == "Cancelled") return Colors.orangeAccent;
    return Colors.white54;
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);
    const surface = Color(0xFF1e293b);
    const accent = Color(0xFF14b8a6);

    final statusColor = _statusColor(prettyStatus);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Session Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
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
                    skill,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isTutorView ? "Student: $student" : "Tutor: $tutor",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text("Date: $date", style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: statusColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      prettyStatus,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

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
                  const Text(
                    "Student Message",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Buttons (only changed to add completed)
            if (isTutorView && isPending) ...[
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
                      onPressed: working ? null : () => _respond("rejected"),
                      child: Text(
                        working ? "..." : "Reject",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                      onPressed: working ? null : () => _respond("accepted"),
                      child: Text(
                        working ? "..." : "Accept",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (isTutorView && isAccepted) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: working ? null : _complete,
                  child: Text(
                    working ? "..." : "Mark Completed",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.25)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Back",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}