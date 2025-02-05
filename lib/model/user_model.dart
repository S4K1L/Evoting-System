import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late final String? name;
  late final String? phone;
  final String? nid;
  final String? password;
  final String? uid;
  late final String? profileImage;
  final bool? fingerPrint;

  UserModel({
    this.name,
    this.phone,
    this.nid,
    this.password,
    this.uid,
    this.profileImage,
    this.fingerPrint,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel(
      name: data['name'] ?? '',
      nid: data['nid'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
      profileImage: data['profileImage'] ?? '',
      fingerPrint: data['fingerPrint'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'nid': nid,
      'password': password,
      'profileImage': profileImage,
      'uid': uid,
      'fingerPrint': fingerPrint,
    };
  }
}


