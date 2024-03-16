import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class schedaModel {
  String? test;
  schedaModel({required this.test,});

  
  factory schedaModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return schedaModel(
     test: data?["test"]
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      if (test != null) "test": test,
    };
  }

}

/*
class mappa {
  String? testo1;
  String? testo2;
  mappa({required this.testo1, required this.testo2});
  factory mappa.fromJson(Map<dynamic, dynamic> json) => mappa(
        testo1: json['testo1'] as String,
        testo2: json['testo2'] as String,
      );

  Map<String, dynamic> toJson() => {
        "testo1": testo1,
        "testo2": testo2,
      };
}
*/