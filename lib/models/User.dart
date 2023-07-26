class UserModel {
  UserModel(this.uuid, this.email, this.name, this.gender, this.noio,
      this.quequan, this.age);
  final String uuid;
  final String email;
  final String name;
  final String gender;
  final String noio;
  final String quequan;
  final int age;

  // Encode the UserModel instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'email': email,
      'name': name,
      'gender': gender,
      'noio': noio,
      'quequan': quequan,
      'age': age,
    };
  }

  // Decode JSON map to create a UserModel instance.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['uuid'],
      json['email'],
      json['name'],
      json['gender'],
      json['noio'],
      json['quequan'],
      json['age'],
    );
  }
}
