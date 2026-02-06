import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillswap_app/controllers/skill_controller.dart';

class SkillFormScreen extends StatefulWidget {
  const SkillFormScreen({super.key});

  @override
  State<SkillFormScreen> createState() => _SkillFormScreenState();
}

class _SkillFormScreenState extends State<SkillFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _loading = false;
  Map<String, dynamic>? editingSkill;

  // Prevent snackbar spam
  bool _warnedName = false;
  bool _warnedCat = false;
  bool _warnedDesc = false;

  @override
  void initState() {
    super.initState();

    // If passed from MySkills edit → update mode
    editingSkill = Get.arguments;

    if (editingSkill != null) {
      _nameController.text = (editingSkill!["name"] ?? "").toString();
      _categoryController.text = (editingSkill!["category"] ?? "").toString();
      _descriptionController.text = (editingSkill!["description"] ?? "")
          .toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ✅ allow letters + spaces only
  bool _hasInvalidChars(String v) {
    return !RegExp(r'^[a-zA-Z\s]*$').hasMatch(v);
  }

  void _showTextOnlyOnce(String field) {
    Get.closeAllSnackbars();
    Get.snackbar(
      "Text only",
      "$field: you can write texts only (letters and spaces).",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  // ✅ validation (submit time)
  String? validateTextOnly(String? value, String fieldName) {
    final text = (value ?? "").trim();

    if (text.isEmpty) return "$fieldName is required";

    // letters + spaces only
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(text)) {
      return "$fieldName must contain letters only";
    }

    if (text.length < 2) return "$fieldName is too short";

    return null;
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<SkillController>();
    setState(() => _loading = true);

    try {
      if (editingSkill == null) {
        // CREATE
        await controller.createSkill(
          name: _nameController.text.trim(),
          category: _categoryController.text.trim(),
          description: _descriptionController.text.trim(),
        );
        Get.back();
        Get.snackbar(
          "Success",
          "Skill added successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // UPDATE
        await controller.updateSkill(
          id: editingSkill!["_id"],
          name: _nameController.text.trim(),
          category: _categoryController.text.trim(),
          description: _descriptionController.text.trim(),
        );
        Get.back();
        Get.snackbar(
          "Updated",
          "Skill updated successfully",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = editingSkill != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(title: Text(isEdit ? "Update Skill" : "Add Skill")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(blurRadius: 10, color: Color(0x11000000)),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // =========================
                // SKILL NAME (friendly warn)
                // =========================
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  onChanged: (v) {
                    if (_hasInvalidChars(v) && !_warnedName) {
                      _warnedName = true;
                      _showTextOnlyOnce("Skill name");
                    }
                    if (!_hasInvalidChars(v)) _warnedName = false;
                  },
                  validator: (v) => validateTextOnly(v, "Skill name"),
                  decoration: const InputDecoration(
                    labelText: "Skill name",
                    prefixIcon: Icon(Icons.title),
                  ),
                ),

                const SizedBox(height: 14),

                // =========================
                // CATEGORY (friendly warn)
                // =========================
                TextFormField(
                  controller: _categoryController,
                  keyboardType: TextInputType.name,
                  onChanged: (v) {
                    if (_hasInvalidChars(v) && !_warnedCat) {
                      _warnedCat = true;
                      _showTextOnlyOnce("Category");
                    }
                    if (!_hasInvalidChars(v)) _warnedCat = false;
                  },
                  validator: (v) => validateTextOnly(v, "Category"),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                ),

                const SizedBox(height: 14),

                // =========================
                // DESCRIPTION (optional warn)
                // =========================
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  maxLines: 4,
                  onChanged: (v) {
                    if (_hasInvalidChars(v) && !_warnedDesc) {
                      _warnedDesc = true;
                      _showTextOnlyOnce("Description");
                    }
                    if (!_hasInvalidChars(v)) _warnedDesc = false;
                  },
                  decoration: const InputDecoration(
                    labelText: "Description (optional)",
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : submit,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isEdit ? "Update Skill" : "Add Skill"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
