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
}

enum UserModelInterval { uuid, email, name, gender, noio, quequan, age }
