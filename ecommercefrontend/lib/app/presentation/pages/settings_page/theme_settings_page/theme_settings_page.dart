import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/theme_cubit.dart';
import '../../../widgets/settings/section_title.dart';
import '../../../widgets/settings/color_picker_section.dart';
import '../../../widgets/settings/banner_field.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  late TextEditingController _logoUrlController;
  late TextEditingController _primaryColorController;
  late TextEditingController _accentColorController;
  late List<TextEditingController> _bannerControllers;

  @override
  void initState() {
    super.initState();
    _logoUrlController = TextEditingController();
    _primaryColorController = TextEditingController();
    _accentColorController = TextEditingController();
    _bannerControllers = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<ThemeCubit>().state;
    if (state is ThemeLoaded) {
      _logoUrlController.text = state.theme.logoUrl;
      _primaryColorController.text = state.theme.primaryColor.value.toString();
      _accentColorController.text = state.theme.accentColor.value.toString();

      // Limpa controllers anteriores
      for (var controller in _bannerControllers) {
        controller.dispose();
      }
      _bannerControllers.clear();

      // Cria novo controllers para banners
      for (var bannerUrl in state.theme.bannerUrls) {
        final controller = TextEditingController(text: bannerUrl);
        _bannerControllers.add(controller);
      }
    }
  }

  @override
  void dispose() {
    _logoUrlController.dispose();
    _primaryColorController.dispose();
    _accentColorController.dispose();
    for (var controller in _bannerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if (state is ThemeLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ThemeError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ThemeCubit>().loadCurrentTheme(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! ThemeLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = state.theme;
        final primaryColor = theme.primaryColor;
        final accentColor = theme.accentColor;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Configurações de Tema'),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de Cores
                // Seção de Cores
                const SectionTitle(title: 'Cores do Tema'),
                const SizedBox(height: 16),

                // Cor Primária
                // Cor Primária
                ColorPickerSection(
                  label: 'Cor Primária',
                  currentColor: primaryColor,
                  onColorChanged: (color) {
                    context.read<ThemeCubit>().updatePrimaryColor(color.value);
                  },
                ),
                const SizedBox(height: 24),

                // Cor de Acento
                // Cor de Acento
                ColorPickerSection(
                  label: 'Cor de Acento',
                  currentColor: accentColor,
                  onColorChanged: (color) {
                    context.read<ThemeCubit>().updateAccentColor(color.value);
                  },
                ),
                const SizedBox(height: 32),

                // Seção de Logo
                // Seção de Logo
                const SectionTitle(title: 'Logo da Aplicação'),
                const SizedBox(height: 16),

                TextField(
                  controller: _logoUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL do Logo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'https://example.com/logo.png',
                  ),
                  onChanged: (_) {},
                ),
                const SizedBox(height: 12),

                // Preview do Logo
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    _logoUrlController.text,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    context.read<ThemeCubit>().updateLogo(
                      _logoUrlController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logo atualizado!')),
                    );
                  },
                  child: const Text('Atualizar Logo'),
                ),
                const SizedBox(height: 32),

                // Seção de Banners
                // Seção de Banners
                const SectionTitle(title: 'Banners da Home'),
                const SizedBox(height: 16),

                ..._bannerControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: BannerField(
                      index: index,
                      controller: controller,
                      onDelete: () {
                        setState(() {
                          _bannerControllers.removeAt(index);
                        });
                        _updateBanners();
                      },
                    ),
                  );
                }).toList(),

                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _bannerControllers.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Banner'),
                ),
                const SizedBox(height: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _updateBanners,
                  child: const Text(
                    'Salvar Banners',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),

                // Seção de Ações
                // Seção de Ações
                const SectionTitle(title: 'Ações'),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _showResetDialog(context);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Resetar para Tema Padrão',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateBanners() {
    final bannerUrls = _bannerControllers
        .map((controller) => controller.text)
        .where((url) => url.isNotEmpty)
        .toList();

    if (bannerUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um banner!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ThemeCubit>().updateBanners(bannerUrls);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Banners atualizados com sucesso!')),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resetar Tema'),
          content: const Text(
            'Tem certeza que deseja resetar o tema para as configurações padrão?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<ThemeCubit>().resetToDefaultTheme();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema resetado para padrão!')),
                );
              },
              child: const Text('Resetar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
