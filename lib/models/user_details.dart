// Модель UserDetails
class UserDetails {
  final String email;
  final String name;

  UserDetails({required this.email, required this.name});

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      email: map['email'] ?? 'Без почты',
      name: map['name'] ?? 'Без имени',
    );
  }
}
