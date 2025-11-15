import 'package:ecommercefrontend/app/core/routes/named_routes.dart';
import 'package:ecommercefrontend/app/presentation/widgets/custom_fields/custom_fields.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../widgets/register_info/register_info.dart';

class ResgisterPage extends StatefulWidget {
  const ResgisterPage({super.key});

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 30,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RegisterInfo(
                  title: "Cadastre-se na nossa plataforma",
                  subtitle:
                      "Cadasrte-se em nossa platataaforma e configure sua loja",
                  icon: Icons.app_registration,
                ),
                RegisterInfo(
                  title: "Configure sua loja",
                  subtitle: "Com poucos cliques você já tem sua loja pronta!",
                  icon: Icons.abc,
                ),
                RegisterInfo(
                  title: "Pronto! agora é só vender",
                  subtitle:
                      "Após configurar sua loja, é só começar a vender seus produtos",
                  icon: Icons.auto_graph_sharp,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 100),
              width: double.maxFinite,
              // height: double.maxFinite,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  spacing: 50,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Crie sua conta \n",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "E comece a suas vendas!",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(decoration: FieldsDecoration('nome')),
                          TextFormField(
                            decoration: FieldsDecoration('nome da loja'),
                          ),
                          TextFormField(decoration: FieldsDecoration('email')),
                          TextFormField(
                            decoration: FieldsDecoration(
                              'senha',
                              null,
                              IconButton(
                                onPressed: () {
                                  print("object");
                                },
                                icon: Icon(Icons.visibility),
                              ),
                            ),
                            obscureText: true,
                          ),
                          TextFormField(
                            decoration: FieldsDecoration(
                              'confirmar senha',
                              null,
                              IconButton(
                                onPressed: () {
                                  print("object");
                                },
                                icon: Icon(Icons.visibility),
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(18),
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.greenAccent,
                                ),
                                shape:
                                    WidgetStateProperty.all<
                                      RoundedRectangleBorder
                                    >(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        side: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                              ),
                              onPressed: () {
                                context.replaceNamed(NamedRoute.homePage);
                              },
                              child: Text(
                                'salvar'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
