import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid,
      userName,
      userEmail,
      //userGender,
      userPhoneNumber,
      userImage,
      userAddress;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    this.userEmail,
    this.uid,
    this.userAddress,
    this.userImage,
    this.userName,
    this.userPhoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      userName: json['name'],
      userEmail: json['email'],
      userAddress: json['address'],
      userImage: json['image'],
      userPhoneNumber: json['number'],
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // sending data to our server
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.userName;
    data['email'] = this.userEmail;
    data['address'] = this.userAddress;
    data['number'] = this.userPhoneNumber;
    data['image'] = this.userImage;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;

    return data;
  }
}
