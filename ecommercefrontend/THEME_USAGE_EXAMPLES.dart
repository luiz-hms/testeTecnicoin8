/// EXEMPLOS DE USO DO SISTEMA DE TEMA
///
/// Este arquivo contém exemplos práticos de como usar o sistema de tema
/// dinâmico em diferentes cenários da aplicação.

// ============================================================================
// EXEMPLO 1: Acessar o Tema Atual na UI
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/theme_cubit.dart';

class MeuComponente extends StatelessWidget {
  const MeuComponente({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        if (state is ThemeLoaded) {
          final theme = state.theme;
          
          return Container(
            color: theme.primaryColor,
            child: Text(
              'Logo: ${theme.logoUrl}',
              style: TextStyle(color: theme.accentColor),
            ),
          );
        }
        
        // Estado de carregamento
        if (state is ThemeLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Estado de erro
        if (state is ThemeError) {
          return Center(child: Text('Erro: ${state.message}'));
        }
        
        return const SizedBox.shrink();
      },
    );
  }
}
*/

// ============================================================================
// EXEMPLO 2: Atualizar Cores do Tema
// ============================================================================

/*
class CorPickerDialog extends StatefulWidget {
  const CorPickerDialog({Key? key}) : super(key: key);

  @override
  State<CorPickerDialog> createState() => _CorPickerDialogState();
}

class _CorPickerDialogState extends State<CorPickerDialog> {
  @override
  Widget build(BuildContext context) {
    final cores = [
      const Color(0xFF1976D2),  // Azul
      const Color(0xFFFF6D00),  // Laranja
      const Color(0xFF4CAF50),  // Verde
      const Color(0xFFE91E63),  // Rosa
    ];

    return AlertDialog(
      title: const Text('Escolha a Cor Primária'),
      content: Wrap(
        spacing: 8,
        children: cores.map((color) {
          return GestureDetector(
            onTap: () {
              // Atualiza a cor primária
              context.read<ThemeCubit>().updatePrimaryColor(color.value);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cor atualizada!')),
              );
            },
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
*/

// ============================================================================
// EXEMPLO 3: Atualizar Logo da Aplicação
// ============================================================================

/*
class LogoUploadWidget extends StatefulWidget {
  const LogoUploadWidget({Key? key}) : super(key: key);

  @override
  State<LogoUploadWidget> createState() => _LogoUploadWidgetState();
}

class _LogoUploadWidgetState extends State<LogoUploadWidget> {
  late TextEditingController _logoUrlController;

  @override
  void initState() {
    super.initState();
    _logoUrlController = TextEditingController();
  }

  @override
  void dispose() {
    _logoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _logoUrlController,
          decoration: InputDecoration(
            labelText: 'URL do Logo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (_logoUrlController.text.isNotEmpty) {
                  context
                      .read<ThemeCubit>()
                      .updateLogo(_logoUrlController.text);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logo atualizado!')),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Preview do logo
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            if (state is ThemeLoaded) {
              return Image.network(
                state.theme.logoUrl,
                height: 100,
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.image_not_supported);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
*/

// ============================================================================
// EXEMPLO 4: Gerenciar Banners da Home
// ============================================================================

/*
class BannerManagerWidget extends StatefulWidget {
  const BannerManagerWidget({Key? key}) : super(key: key);

  @override
  State<BannerManagerWidget> createState() => _BannerManagerWidgetState();
}

class _BannerManagerWidgetState extends State<BannerManagerWidget> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final state = context.read<ThemeCubit>().state;
    if (state is ThemeLoaded) {
      _controllers = state.theme.bannerUrls
          .map((url) => TextEditingController(text: url))
          .toList();
    } else {
      _controllers = [];
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveBanners() {
    final urls = _controllers
        .map((c) => c.text)
        .where((url) => url.isNotEmpty)
        .toList();

    if (urls.isNotEmpty) {
      context.read<ThemeCubit>().updateBanners(urls);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banners atualizados!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._controllers.asMap().entries.map((entry) {
          final index = entry.key;
          final controller = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Banner ${index + 1}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() => _controllers.removeAt(index));
                  },
                ),
              ),
            ),
          );
        }).toList(),
        ElevatedButton(
          onPressed: _saveBanners,
          child: const Text('Salvar Banners'),
        ),
      ],
    );
  }
}
*/

// ============================================================================
// EXEMPLO 5: Resetar para Tema Padrão
// ============================================================================

/*
void _showResetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Resetar Tema'),
      content: const Text(
        'Deseja resetar o tema para as configurações padrão?',
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
              const SnackBar(
                content: Text('Tema resetado!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('Resetar', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
*/

// ============================================================================
// EXEMPLO 6: Usar Tema em Widget Customizado
// ============================================================================

/*
class ProductCard extends StatelessWidget {
  final String productName;
  final double price;
  final VoidCallback onAddToCart;

  const ProductCard({
    required this.productName,
    required this.price,
    required this.onAddToCart,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final accentColor = (state is ThemeLoaded)
            ? state.theme.accentColor
            : Colors.blue;

        return Card(
          child: Column(
            children: [
              Text(productName),
              Text('R\$ $price'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                ),
                onPressed: onAddToCart,
                child: const Text('Adicionar ao Carrinho'),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/

// ============================================================================
// EXEMPLO 7: Acessar Tema via GetIt (Sem BlocBuilder)
// ============================================================================

/*
import 'package:ecommercefrontend/app/core/depence_injection/service_locator.dart';

// Em qualquer lugar da aplicação
void exemploDeAcesso() {
  final themeCubit = getIt<ThemeCubit>();
  
  // Acessar o estado atual (sincronamente)
  if (themeCubit.state is ThemeLoaded) {
    final theme = (themeCubit.state as ThemeLoaded).theme;
    print('Cor primária: ${theme.primaryColor}');
  }
  
  // Atualizar tema (assincronamente)
  themeCubit.updatePrimaryColor(0xFF1976D2);
}
*/

// ============================================================================
// EXEMPLO 8: Criar Um Novo Tema
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:ecommercefrontend/app/domain/entities/theme/app_theme.dart';

final meuNovoTema = AppTheme(
  id: 'meu_tema_custom',
  name: 'Meu Tema Customizado',
  primaryColor: const Color(0xFF6C63FF),  // Roxo
  accentColor: const Color(0xFFFF006E),   // Rosa Hot
  logoUrl: 'https://exemplo.com/meu-logo.png',
  bannerUrls: [
    'https://exemplo.com/banner1.jpg',
    'https://exemplo.com/banner2.jpg',
    'https://exemplo.com/banner3.jpg',
  ],
  createdAt: DateTime.now(),
);

// Salvar o tema
// context.read<ThemeCubit>().updateTheme(meuNovoTema);
*/

// ============================================================================
// EXEMPLO 9: Ouvir Mudanças de Tema (Listener)
// ============================================================================

/*
class MeuWidgetComListener extends StatelessWidget {
  const MeuWidgetComListener({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeCubit, ThemeState>(
      listener: (context, state) {
        if (state is ThemeLoaded) {
          // Fazer algo quando o tema é carregado/atualizado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tema atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        
        if (state is ThemeError) {
          // Tratar erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: const Placeholder(),
    );
  }
}
*/

// ============================================================================
// EXEMPLO 10: Combinar BlocBuilder e BlocListener
// ============================================================================

/*
class MeuWidgetCompleto extends StatelessWidget {
  const MeuWidgetCompleto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ThemeCubit, ThemeState>(
      listener: (context, state) {
        if (state is ThemeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          if (state is ThemeLoaded) {
            return Container(
              color: state.theme.primaryColor,
              child: Center(
                child: Text(
                  'Tema: ${state.theme.name}',
                  style: TextStyle(color: state.theme.accentColor),
                ),
              ),
            );
          }
          
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
*/

void main() {
  print('Este arquivo contém exemplos de uso do sistema de tema.');
  print('Descomente os exemplos e adapte conforme necessário.');
}
