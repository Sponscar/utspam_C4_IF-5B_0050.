class UserModel {
  final String nama;
  final String email;
  final String phone;
  final String alamat;
  final String username;
  final String password;

  UserModel({
    required this.nama,
    required this.email,
    required this.phone,
    required this.alamat,
    required this.username,
    required this.password,
  });

  // Convert object → Map
  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'phone': phone,
      'alamat': alamat,
      'username': username,
      'password': password,
    };
  }

  // Convert Map → UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nama: map['nama'],
      email: map['email'],
      phone: map['phone'],
      alamat: map['alamat'],
      username: map['username'],
      password: map['password'],
    );
  }
}
