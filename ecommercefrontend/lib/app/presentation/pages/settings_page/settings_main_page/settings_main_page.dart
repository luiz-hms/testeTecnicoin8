import 'package:ecommercefrontend/app/core/depence_injection/service_locator.dart';
import 'package:ecommercefrontend/app/presentation/cubits/user_profile/user_profile_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/user_profile/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsMainPage extends StatelessWidget {
  const SettingsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserProfileCubit>()..loadProfile(),
      child: const _SettingsMainPageContent(),
    );
  }
}

class _SettingsMainPageContent extends StatefulWidget {
  const _SettingsMainPageContent();

  @override
  State<_SettingsMainPageContent> createState() =>
      _SettingsMainPageContentState();
}

class _SettingsMainPageContentState extends State<_SettingsMainPageContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showPasswordFields = false;

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'Perfil atualizado!'),
              backgroundColor: Colors.green,
            ),
          );
          // Clear password fields after success
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          setState(() {
            _showPasswordFields = false;
          });
        } else if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro ao atualizar perfil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Configurações')),
            body: const Center(
              child: Text('Erro ao carregar dados do usuário'),
            ),
          );
        }

        // Initialize name field with user data
        if (_nameController.text.isEmpty && state.user != null) {
          _nameController.text = state.user!.name;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Configurações de Perfil'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info Section
                  _buildSectionTitle('Informações Pessoais'),
                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _nameController,
                    label: 'Nome',
                    hint: 'Digite seu nome',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nome não pode ser vazio';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email (read-only)
                  _buildTextField(
                    controller: TextEditingController(text: state.user!.email),
                    label: 'Email',
                    icon: Icons.email,
                    enabled: false,
                  ),

                  const SizedBox(height: 32),

                  // Password Section
                  _buildSectionTitle('Segurança'),
                  const SizedBox(height: 16),

                  if (!_showPasswordFields)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showPasswordFields = true;
                        });
                      },
                      icon: const Icon(Icons.lock_outline),
                      label: const Text('Alterar Senha'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    )
                  else ...[
                    _buildTextField(
                      controller: _newPasswordController,
                      label: 'Nova Senha',
                      hint: 'Mínimo 6 caracteres',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (_showPasswordFields) {
                          if (value == null || value.isEmpty) {
                            return 'Digite a nova senha';
                          }
                          if (value.length < 6) {
                            return 'Senha deve ter no mínimo 6 caracteres';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar Nova Senha',
                      hint: 'Digite a senha novamente',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (_showPasswordFields) {
                          if (value != _newPasswordController.text) {
                            return 'Senhas não conferem';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showPasswordFields = false;
                          _newPasswordController.clear();
                          _confirmPasswordController.clear();
                        });
                      },
                      child: const Text('Cancelar alteração de senha'),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: state.isUpdating
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<UserProfileCubit>().updateProfile(
                                name: _nameController.text.trim(),
                                password: _showPasswordFields
                                    ? _newPasswordController.text
                                    : null,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isUpdating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Salvar Alterações',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    bool obscureText = false,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[200],
      ),
    );
  }
}
