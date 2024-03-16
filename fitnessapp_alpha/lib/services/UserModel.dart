
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? test;
  UserModel({required this.test,});

  
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
     test: data?["test"], 
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      if (test != null) "test": test,
    };
  }

}

