class ApiEndpoints {
  static const String skills = "/skills";
  static const String mySkills = "/skills/my";
  static String skillById(String id) => "/skills/$id";
  // Auth endpoints depend on your backend (example):
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String me = "/auth/me"; // if you have it
}
