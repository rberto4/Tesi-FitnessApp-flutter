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
  List<ClienteModel>? listaClientiSeguiti;

  CoachModel(
      {required this.listaClientiSeguiti,
      required super.username,
      required super.email,
      super.uid});

  factory CoachModel.fromFirestore(Map<String, dynamic> json) {
    var listaClientiSeguiti = json['listaClientiSeguiti'] as List;
    List<ClienteModel> listaClientiSeguitiLocal =
        listaClientiSeguiti.map((i) => ClienteModel.fromFirestore(i)).toList();

    return CoachModel(
        username: json['username'],
        email: json['email'],
        listaClientiSeguiti: listaClientiSeguitiLocal);
  }

  Map<String, Object?> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (listaClientiSeguiti != null)
        "listaClientiSeguiti": listaClientiSeguiti,
    };
  }
}

class ClienteModel extends UserModel {
  ClienteModel({required super.username, required super.email, super.uid});

  factory ClienteModel.fromFirestore(Map<String, dynamic> json) {
    return ClienteModel(
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
