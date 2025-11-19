import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ecommercefrontend/app/core/routes/named_routes.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Página não encontrada',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(NamedRoute.homePage);
                },
                child: const Text('Voltar para a Home'),
              ),
              const SizedBox(height: 20),
              Expanded(child: Lottie.asset('assets/lottiefiles/empty.json')),
            ],
          ),
        ),
      ),
    );
  }
}
