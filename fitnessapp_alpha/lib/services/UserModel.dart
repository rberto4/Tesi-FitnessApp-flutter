// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  
  String? username;
  String? email;
  String? uid;

  UserModel({required this.username, required this.email, this.uid});

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
    };
  }
}

class CoachModel extends UserModel {

  List<String>? listaUidClientiSeguiti;

  CoachModel(
      {required this.listaUidClientiSeguiti,
      required super.username,
      required super.email,
      super.uid
      });

  factory CoachModel.fromFirestore(Map<String, dynamic> json) {
    return CoachModel(
      username: json['username'],
      email: json['email'],
      listaUidClientiSeguiti: json['listaUidClientiSeguiti'] is Iterable
          ? List.from(json['listaUidClientiSeguiti'])
          : null,
    );
  }



  Map<String, Object?> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (listaUidClientiSeguiti != null)
        "listaUidClientiSeguiti": listaUidClientiSeguiti,
    };
  }


}
