import 'package:flutter/material.dart';

class RegisterInfo extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const RegisterInfo({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ListTile(
        leading: Container(
          height: 200,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.greenAccent[100],
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Icon(icon, size: 40, color: Colors.black),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
