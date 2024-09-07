import 'dart:convert';

const String notUserPhoto =
    'https://firebasestorage.googleapis.com/v0/b/eva-project-91804.appspot.com/o/user_photos%2Fnot_user.jpg?alt=media&token=c00c3440-595c-4b5a-857f-dea381fad831';

class MyUser {
  final String fullName;
  final String email;
  final String role;
  final String photoUrl;
  final String password;
  MyUser({
    required this.fullName,
    required this.email,
    required this.role,
    this.photoUrl = notUserPhoto,
    required this.password,
  });

  MyUser copyWith({
    String? fullName,
    String? email,
    String? role,
    String? photoUrl,
    String? password,
  }) {
    return MyUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      photoUrl: map['photoUrl'] ?? notUserPhoto,
      password: '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MyUser.fromJson(String source) => MyUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(fullName: $fullName, email: $email, role: $role, photoUrl: $photoUrl, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyUser &&
        other.fullName == fullName &&
        other.email == email &&
        other.role == role &&
        other.photoUrl == photoUrl &&
        other.password == password;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        email.hashCode ^
        role.hashCode ^
        photoUrl.hashCode ^
        password.hashCode;
  }
}
