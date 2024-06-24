// ignore_for_file: file_names
class User {
  String? username;
  String? email;
  String? uid;
  User({required this.username, required this.email, required this.uid});
}

class Coach extends User {
  List<Cliente>? listaClientiSeguiti;

  Coach(
      {required this.listaClientiSeguiti,
      required super.username,
      required super.email,
      required super.uid});

  factory Coach.fromFirestore(Map<String, dynamic> json) {
    var listaClientiSeguiti = json['listaClientiSeguiti'] as List;
    List<Cliente> listaClientiSeguitiLocal =
        listaClientiSeguiti.map((i) => Cliente.fromFirestore(i)).toList();

    return Coach(
        username: json['username'],
        email: json['email'],
        uid: json['uid'],
        listaClientiSeguiti: listaClientiSeguitiLocal);
  }

  Map<String, Object?> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (uid != null) "uid": uid,
      if (listaClientiSeguiti != null)
        "listaClientiSeguiti": listaClientiSeguiti?.map((e) => e.toFirestore()),
    };
  }
}

class Cliente extends User {
  Cliente({required super.username, required super.email, required super.uid});

  factory Cliente.fromFirestore(Map<String, dynamic> json) {
    return Cliente(
        username: json['username'], email: json['email'], uid: json['uid']);
  }

  Map<String, Object?> toFirestore() {
    return {
      if (username != null) "username": username,
      if (email != null) "email": email,
      if (uid != null) "uid": uid,
    };
  }
}
