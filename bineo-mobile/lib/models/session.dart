import 'package:bineo/models/user.dart';

class Session {
  User user;
  String token;
  // You can add more properties as needed, such as profile picture, bio, etc.

  Session({
    required this.user,
    this.token = '',
  });

  // Factory constructor to create a User object from a map (e.g., from Firebase)
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      user: User.fromMap(map['user']),
      token: map['token'],
    );
  }

  // Method to convert User object to a map (e.g., for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'token': token,
    };
  }
}
