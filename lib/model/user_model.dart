import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late final String? name;
  late final String? phone;
  final String? email;
  final String? password;
  final String? uid;
  late final String? profileImage;

  UserModel({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.uid,
    this.profileImage,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
      profileImage: data['profileImage'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'uid': uid
    };
  }
}


