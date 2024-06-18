class User {
  /// Used for romVo database
  String id;

  /// Used for bank data
  String customerId;
  String username;
  String email;
  String phoneNumber;
  // You can add more properties as needed, such as profile picture, bio, etc.

  User({
    required this.id,
    required this.customerId,
    required this.username,
    required this.email,
    required this.phoneNumber,
  });

  // Factory constructor to create a User object from a map (e.g., from Firebase)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      customerId: map['user_id'],
      username: map['username'],
      email: map['email'],
      phoneNumber: (map['phone'] ?? '').toString(),
    );
  }

  // Method to convert User object to a map (e.g., for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': customerId,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
