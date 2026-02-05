// FILE: lib/features/home/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/app_routes.dart';
import '../../../core/services/token_storage.dart';
import '../../courses/views/course_details_view.dart';
import '../../learning/views/my_learning_view.dart';
import '../../upload/view/upload_course_view.dart';
import '../../sessions/views/sessions_list_view.dart';
import '../../profile/views/profile_view.dart';

//  NEW: import SkillApi (the file you created)
import '../../courses/data/skill_api.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;

  // keep one username in state
  late String userName;
  late String userId;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    userName = await TokenStorage.readUserName() ?? "User";
    userId = await TokenStorage.readUserId() ?? "";

    _screens = [
      _HomeFeed(myUserId: userId),
      const MyLearningView(),
      const SessionsListView(),
      const ProfileView(),
    ];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0f172a);

    return Scaffold(
      backgroundColor: bg,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          "SkillSwap",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: _AppDrawer(
        onSelectTab: (i) {
          setState(() => currentIndex = i);
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF14b8a6),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UploadCourseView()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: _BottomBar(
        index: currentIndex,
        userName: userName,
        userId: userId,
        onChange: (i) {
          setState(() => currentIndex = i);
        },
      ),
    );
  }
}

// ==========================================================
// ===================== DRAWER ==============================
// ==========================================================

class _AppDrawer extends StatelessWidget {
  final void Function(int) onSelectTab;

  const _AppDrawer({required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1e293b);

    return Drawer(
      backgroundColor: bg,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0f172a)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.school, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  "Welcome 👋",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          _DrawerItem(Icons.home, "Home", onTap: () {
            Navigator.pop(context);
            onSelectTab(0);
          }),
          _DrawerItem(Icons.school, "My Learning", onTap: () {
            Navigator.pop(context);
            onSelectTab(1);
          }),
          _DrawerItem(Icons.list_alt, "Sessions", onTap: () {
            Navigator.pop(context);
            onSelectTab(2);
          }),
          _DrawerItem(Icons.person, "Profile", onTap: () {
            Navigator.pop(context);
            onSelectTab(3);
          }),
          const Divider(color: Colors.white12),
          _DrawerItem(Icons.logout, "Logout", onTap: () async {
            Navigator.pop(context);
            await TokenStorage.logout();
            Get.offAllNamed(AppRoutes.welcome);
          }),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem(this.icon, this.title, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

// ==========================================================
// ===================== HOME FEED ===========================
// ==========================================================

class _HomeFeed extends StatefulWidget {
  final String myUserId; //  add this
  const _HomeFeed({required this.myUserId});

  @override
  State<_HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<_HomeFeed> {
  final TextEditingController search = TextEditingController();
  String selectedCategory = "All";

  final categories = [
    "All",
    "Programming",
    "Design",
    "Marketing",
    "Languages",
    "Business",
    "Data",
  ];

  //  ADD THIS FUNCTION HERE (under selectedCategory)
  String detectCategory(Map<String, dynamic> c) {
    final text =
    "${c["title"] ?? ""} ${c["description"] ?? ""}".toLowerCase();

    if (text.contains("flutter") ||
        text.contains("dart") ||
        text.contains("react") ||
        text.contains("node") ||
        text.contains("java") ||
        text.contains("php") ||
        text.contains("html") ||
        text.contains("css")) {
      return "Programming";
    }

    if (text.contains("design") || text.contains("ui") || text.contains("ux")) {
      return "Design";
    }

    if (text.contains("marketing")) {
      return "Marketing";
    }

    if (text.contains("english") || text.contains("language")) {
      return "Languages";
    }

    if (text.contains("business")) {
      return "Business";
    }

    if (text.contains("data") || text.contains("excel") || text.contains("ml")) {
      return "Data";
    }

    return "General";
  }

  late final Future<List<dynamic>> _skillsFuture;

  @override
  void initState() {
    super.initState();
    _skillsFuture = SkillApi.getAll(); // GET /api/skills
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = widget.myUserId; 

    return Column(
      children: [
        // SEARCH BAR
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: search,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Search courses...",
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // FILTER CHIPS
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final active = cat == selectedCategory;

              return GestureDetector(
                onTap: () => setState(() => selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF14b8a6) : Colors.white12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(color: active ? Colors.black : Colors.white),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // COURSE LIST (backend)
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _skillsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Error loading courses:\n${snapshot.error}",
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final all = snapshot.data ?? [];

              final q = search.text.toLowerCase();
              final filtered = all.where((item) {
                final map = item as Map<String, dynamic>;

                final title = (map["title"] ?? "").toString().toLowerCase();
                final cat = detectCategory(map);

                final matchSearch = q.isEmpty || title.contains(q);
                final matchCategory =
                    selectedCategory == "All" || cat == selectedCategory;

                return matchSearch && matchCategory;
              }).toList();

              if (filtered.isEmpty) {
                return const Center(
                  child: Text("No courses found.", style: TextStyle(color: Colors.white70)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final c = filtered[i] as Map<String, dynamic>;

                  final title = (c["title"] ?? "Untitled").toString();
                  final description = (c["description"] ?? "").toString();

                  String tutorName = "Tutor";
                  String tutorId = "";

                  final t = c["tutor"];
                  if (t is Map<String, dynamic>) {
                    tutorName = (t["name"] ?? "Tutor").toString();
                    tutorId = (t["_id"] ?? "").toString();
                  } else if (t != null) {
                    tutorId = t.toString();
                  }

                  String driveLink = (c["driveLink"] ?? "").toString();
                  if (driveLink.isEmpty && c["videoLinks"] is List) {
                    final list = c["videoLinks"] as List;
                    if (list.isNotEmpty) driveLink = (list.first ?? "").toString();
                  }

                  final skillId = (c["_id"] ?? "").toString();

                  return _CourseCard(
                    title: title,
                    tutor: tutorName,
                    onOpen: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailsView(
                            skillId: skillId,
                            tutorId: tutorId,
                            myUserId: userId, //  now correct
                            title: title,
                            tutor: tutorName,
                            category: selectedCategory == "All" ? "General" : selectedCategory,
                            level: "Beginner",
                            files: "Documents",
                            quiz: "Quiz",
                            description: description.isEmpty ? "No description provided." : description,
                            driveLink: driveLink.isEmpty ? "https://drive.google.com/" : driveLink,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// ===================== COURSE CARD =========================
// ==========================================================

class _CourseCard extends StatelessWidget {
  final String title;
  final String tutor;
  final VoidCallback onOpen;

  const _CourseCard({
    required this.title,
    required this.tutor,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1e293b),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.description,
          color: Color(0xFF14b8a6),
          size: 36,
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text("By $tutor", style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38),
        onTap: onOpen,
      ),
    );
  }
}

// ==========================================================
// ===================== BOTTOM BAR ===========================
// ==========================================================

class _BottomBar extends StatelessWidget {
  final int index;
  final Function(int) onChange;

  final String userName;
  final String userId;

  const _BottomBar({
    required this.index,
    required this.onChange,
    required this.userName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1e293b);

    return BottomAppBar(
      color: bg,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(Icons.home, "Home", 0, index, onChange, userName, userId),
            _NavItem(Icons.school, "Learn", 1, index, onChange, userName, userId),
            const SizedBox(width: 40),
            _NavItem(Icons.list_alt, "Sessions", 2, index, onChange, userName, userId),
            _NavItem(Icons.person, "Profile", 3, index, onChange, userName, userId),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int i;
  final int current;
  final Function(int) onChange;

  final String userName;
  final String userId;

  const _NavItem(
      this.icon,
      this.label,
      this.i,
      this.current,
      this.onChange,
      this.userName,
      this.userId,
      );

  @override
  Widget build(BuildContext context) {
    final active = i == current;

    return GestureDetector(
      onTap: () async {
        onChange(i);

        if (i == 1) {
          final res = await Get.toNamed(AppRoutes.learning, arguments: {"fromHome": true});
          if (res == "goHome") onChange(0);
        }

        if (i == 2) {
          final res = await Get.toNamed(AppRoutes.sessionsList, arguments: {"fromHome": true});
          if (res == "goHome") onChange(0);
        } else if (i == 3) {
          final res = await Get.toNamed(
            AppRoutes.profile,
            arguments: {
              "fromHome": true,
              "name": userName,
              "userId": userId,
            },
          );
          if (res == "goHome") onChange(0);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? const Color(0xFF14b8a6) : Colors.white54),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: active ? const Color(0xFF14b8a6) : Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}