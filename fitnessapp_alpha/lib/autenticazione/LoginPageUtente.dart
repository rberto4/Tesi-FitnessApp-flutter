import 'package:flutter/material.dart';

class loginUtente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "LoginUtente",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  TextField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
