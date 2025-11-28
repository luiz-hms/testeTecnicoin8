import 'package:ecommercefrontend/app/core/depence_injection/service_locator.dart';
import 'package:ecommercefrontend/app/core/helpers/mixins/validations.dart';
import 'package:ecommercefrontend/app/core/routes/named_routes.dart';
import 'package:ecommercefrontend/app/presentation/cubits/auth/login/login_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/auth/login/login_state.dart';
import 'package:ecommercefrontend/app/presentation/widgets/custom_fields/custom_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/auth/login_banner.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/auth/auth_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validations {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                spacing: 50,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [LoginBanner()],
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
                      AuthHeader(
                        title: "bem vindo de volta",
                        subtitle: "Entre com a sua conta",
                      ),
                      BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage!)),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  decoration: FieldsDecoration('email'),
                                  validator: (value) => isNotEmpty(value),
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: FieldsDecoration(
                                    'senha',
                                    null,
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<LoginCubit>()
                                            .togglePasswordVisibility();
                                      },
                                      icon: Icon(
                                        state.isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                  obscureText: !state.isPasswordVisible,
                                  validator: (value) => isNotEmpty(value),
                                ),
                                AuthButton(
                                  text: 'entrar',
                                  isLoading: state.isLoading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<LoginCubit>().login(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                      context.replaceNamed(NamedRoute.homePage);
                                    }
                                  },
                                ),

                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "esqueci minha senha",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () =>
                                      context.goNamed(NamedRoute.registerPage),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Ainda não tem uma conta? ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: " Cadastre-se",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
