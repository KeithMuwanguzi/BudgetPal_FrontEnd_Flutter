class CustomUser {
  final int? id;
  final String username;
  final String email;
  final String phoneNumber;
  final String address;

  CustomUser({
    this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
    };
  }
}
