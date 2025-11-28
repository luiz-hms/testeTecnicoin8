import 'package:ecommercefrontend/app/core/helpers/mixins/validations.dart';
import 'package:ecommercefrontend/app/core/routes/named_routes.dart';
import 'package:ecommercefrontend/app/core/depence_injection/service_locator.dart';
import 'package:ecommercefrontend/app/presentation/cubits/auth/register/register_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/auth/register/register_state.dart';
import 'package:ecommercefrontend/app/presentation/widgets/custom_fields/custom_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../widgets/register_info/register_info.dart';
import '../../../widgets/auth/auth_header.dart';
import '../../../widgets/auth/auth_button.dart';

class ResgisterPage extends StatefulWidget {
  const ResgisterPage({super.key});

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> with Validations {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _storeNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(authRepository: getIt()),
      child: Scaffold(
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
                        "Cadastre-se em nossa plataforma e configure sua loja",
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
                        title: "Crie sua conta",
                        subtitle: "E comece a suas vendas!",
                      ),
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage!)),
                            );
                          }

                          // Mostrar dialog de sucesso com a URL da loja
                          if (state.isRegistered && state.storeUrl != null) {
                            // Usar nip.io para resolução automática de DNS (Zero Config!)
                            // Ex: http://devnology.127.0.0.1.nip.io:8000
                            final storeUrl =
                                'http://${state.storeUrl}.127.0.0.1.nip.io:8000';

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => AlertDialog(
                                title: const Text(
                                  '🎉 Loja Criada com Sucesso!',
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Sua loja foi criada! Acesse o link abaixo:',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.blue.shade200,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: SelectableText(
                                              storeUrl,
                                              style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 14,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.copy,
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              Clipboard.setData(
                                                ClipboardData(text: storeUrl),
                                              );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text('URL copiada!'),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '💡 Esta URL funciona automaticamente sem configuração!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      context.goNamed(NamedRoute.homePage);
                                    },
                                    child: const Text('Ir para Home'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      // Redirecionar para a URL da loja
                                      // Nota: go_router lida com rotas internas.
                                      // Para mudar de domínio (host), o ideal seria url_launcher.
                                      // Como fallback, usamos query param que funciona internamente.
                                      context.go('/?store=${state.storeUrl}');
                                    },
                                    child: const Text('Acessar Agora'),
                                  ),
                                ],
                              ),
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
                                  controller: _nameController,
                                  decoration: FieldsDecoration('nome'),
                                  validator: (value) => isNotEmpty(value),
                                ),
                                TextFormField(
                                  controller: _storeNameController,
                                  decoration: FieldsDecoration('nome da loja'),
                                  validator: (value) => isNotEmpty(value),
                                ),
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
                                            .read<RegisterCubit>()
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
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  decoration: FieldsDecoration(
                                    'confirmar senha',
                                    null,
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<RegisterCubit>()
                                            .toggleConfirmPasswordVisibility();
                                      },
                                      icon: Icon(
                                        state.isConfirmPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                  obscureText: !state.isConfirmPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'esse campo é obrigatório';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'as senhas não coincidem';
                                    }
                                    return null;
                                  },
                                ),
                                AuthButton(
                                  text: 'salvar',
                                  isLoading: state.isLoading,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<RegisterCubit>().register(
                                        name: _nameController.text,
                                        shopName: _storeNameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                    }
                                  },
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
