import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginBanner extends StatelessWidget {
  const LoginBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 50,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        RichText(
          text: const TextSpan(
            text: "Bem vindo ao \n",
            style: TextStyle(fontSize: 50, color: Colors.black),
            children: [
              TextSpan(
                text: "DevNology",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: const TextSpan(
            text: "Configure sua loja \n",
            style: TextStyle(fontSize: 24, color: Colors.black),
            children: [
              TextSpan(
                text: "e comece a vender!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
        ),
        Lottie.asset('assets/lottiefiles/Shopping.json'),
      ],
    );
  }
}
