class Profile {
  final String id;
  final String email;
  final String full_name;
  final String avatar_url;
  final String provider;
  final DateTime created_at;
  final DateTime updated_at;

  Profile({
    required this.id,
    required this.email,
    required this.full_name,
    required this.avatar_url,
    required this.provider,
    required this.created_at,
    required this.updated_at,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      full_name: json['full_name'],
      avatar_url: json['avatar_url'],
      provider: json['provider'],
      created_at: DateTime.parse(json['created_at']),
      updated_at: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': full_name,
      'avatar_url': avatar_url,
      'provider': provider,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
    };
  }
}
