class UserProfile {
  String name;
  String email;
  int age;
  String mobileNumber;

  UserProfile({
    required this.name,
    required this.email,
    required this.age,
    required this.mobileNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'mobileNumber': mobileNumber,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String,
      email: map['email'] as String,
      age: map['age'] as int,
      mobileNumber: map['mobileNumber'] as String,
    );
  }
}
