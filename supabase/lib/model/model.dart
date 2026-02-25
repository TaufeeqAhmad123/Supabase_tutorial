class Profile {
  final String id;
  final String email;
  final String name;

  Profile({
    required this.id,
    required this.email,
    required this.name,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}