// ===============================
// sessions_list_view.dart
// ✅ Connected to backend (GET /sessions/mine, PATCH respond)
// ✅ Same design (your UI kept)
// ===============================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/app_routes.dart';
import '../../../core/services/api_service.dart';

class SessionsListView extends StatefulWidget {
  const SessionsListView({super.key});

  @override
  State<SessionsListView> createState() => _SessionsListViewState();
}

class _SessionsListViewState extends State<SessionsListView> {
  int tabIndex = 0; // 0 = My Requests, 1 = Teaching

  bool loading = true;
  String? error;

  List<Map<String, dynamic>> myRequests = [];
  List<Map<String, dynamic>> teachingRequests = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final myId = await ApiService.getMyUserId();
      if (myId == null) {
        setState(() {
          error = "Token missing. Please login again.";
          loading = false;
        });
        return;
      }

      final raw = await ApiService.getMySessions(); // List<dynamic>
      final sessions =
      raw.map((e) => (e as Map<String, dynamic>)).toList();

      final learnerList = <Map<String, dynamic>>[];
      final tutorList = <Map<String, dynamic>>[];

      for (final s in sessions) {
        final tutor = s["tutor"];
        final learner = s["learner"];

        final tutorId = (tutor is Map) ? tutor["_id"]?.toString() : null;
        final learnerId = (learner is Map) ? learner["_id"]?.toString() : null;

        if (learnerId == myId) learnerList.add(s);
        if (tutorId == myId) tutorList.add(s);
      }

      setState(() {
        myRequests = learnerList;
        teachingRequests = tutorList;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String _skillTitle(Map<String, dynamic> s) {
    final skill = s["skill"];
    if (skill is Map<String, dynamic>) {
      return (skill["title"] ?? "Skill").toString();
    }
    return "Skill";
  }

  String _name(dynamic user, String fallback) {
    if (user is Map<String, dynamic>) return (user["name"] ?? fallback).toString();
    return fallback;
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

  String _dateText(Map<String, dynamic> s) {
    final raw = (s["scheduledAt"] ?? s["createdAt"])?.toString() ?? "";
    if (raw.contains("T")) return raw.split("T").first;
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);
    const card = Color(0xFF1e293b);

    final sessions = tabIndex == 0 ? myRequests : teachingRequests;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(result: "goHome"),
        ),
        title: const Text(
          "Sessions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: "Refresh",
            onPressed: _loadSessions,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _TabChip(
                    label: "My Requests",
                    active: tabIndex == 0,
                    onTap: () => setState(() => tabIndex = 0),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TabChip(
                    label: "Teaching",
                    active: tabIndex == 1,
                    onTap: () => setState(() => tabIndex = 1),
                  ),
                ),
              ],
            ),
          ),

          if (loading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFF14b8a6)),
              ),
            )
          else if (error != null)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else if (sessions.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    tabIndex == 0 ? "No requests yet." : "No teaching requests yet.",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: sessions.length,
                  itemBuilder: (_, i) {
                    final s = sessions[i];

                    final rawStatus = (s["status"] ?? "pending").toString();
                    final prettyStatus = _prettyStatus(rawStatus);
                    final statusColor = _statusColor(prettyStatus);

                    final skill = _skillTitle(s);
                    final tutorName = _name(s["tutor"], "Tutor");
                    final learnerName = _name(s["learner"], "Student");
                    final date = _dateText(s);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        leading: Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(Icons.handshake, color: statusColor),
                        ),
                        title: Text(
                          skill,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            tabIndex == 0
                                ? "Tutor: $tutorName • $date\nStatus: $prettyStatus"
                                : "Student: $learnerName • $date\nStatus: $prettyStatus",
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.3,
                            ),
                          ),
                        ),

                        trailing: tabIndex == 0
                            ? const Icon(Icons.chevron_right, color: Colors.white54)
                            : _TeachingActions(
                          onAccept: () async {
                            final id = s["_id"]?.toString();
                            if (id == null) return;

                            final ok = await ApiService.respondToSession(
                              sessionId: id,
                              status: "accepted",
                            );

                            if (ok) {
                              Get.snackbar(
                                "Accepted ✅",
                                "Request moved to Approved.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              _loadSessions();
                            } else {
                              Get.snackbar(
                                "Error",
                                "Failed to accept.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          onReject: () async {
                            final id = s["_id"]?.toString();
                            if (id == null) return;

                            final ok = await ApiService.respondToSession(
                              sessionId: id,
                              status: "rejected",
                            );

                            if (ok) {
                              Get.snackbar(
                                "Rejected ❌",
                                "Request rejected.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              _loadSessions();
                            } else {
                              Get.snackbar(
                                "Error",
                                "Failed to reject.",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                        ),

                        onTap: () async {
                          final updated = await Get.toNamed(
                            AppRoutes.sessionDetails,
                            arguments: {
                              "sessionId": s["_id"]?.toString(), // ✅ required for backend update
                              "skill": skill,
                              "tutor": tutorName,
                              "student": learnerName,
                              "status": prettyStatus,
                              "rawStatus": rawStatus, // ✅ "pending/accepted/rejected..."
                              "date": date,
                              "message": (s["message"] ?? "—").toString(),
                              "tabIndex": tabIndex, // ✅ tells details if tutor view or student view
                            },
                          );

                          if (updated == true) {
                            _loadSessions(); // ✅ refresh list after accept/reject
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF14b8a6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? accent : Colors.white12,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: active ? accent : Colors.white12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.black : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _TeachingActions extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _TeachingActions({
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: "Accept",
          onPressed: onAccept,
          icon: const Icon(Icons.check_circle, color: Color(0xFF14b8a6)),
        ),
        IconButton(
          tooltip: "Reject",
          onPressed: onReject,
          icon: const Icon(Icons.cancel, color: Colors.redAccent),
        ),
      ],
    );
  }
}