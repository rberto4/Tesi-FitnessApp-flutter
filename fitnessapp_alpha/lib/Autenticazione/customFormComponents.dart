import 'package:flutter/material.dart';

class myEditText extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isHidden;

  const myEditText(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.isHidden});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }
}

class myEnterButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const myEnterButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.lightBlue, borderRadius: BorderRadius.circular(8.0)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
