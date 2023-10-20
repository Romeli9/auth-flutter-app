class Users {
  final String email;
  final String username;

  Users({
    required this.email,
    required this.username,
  });
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
    };
  }
}
