# 🎯 Como Acessar a Página de Configuração de Temas

## Opção 1: Via Drawer (Recomendado)

Adicione um botão no drawer da aplicação que navegue até a página de tema:

```dart
// Em custom_drawer.dart, adicione:

import 'package:go_router/go_router.dart';
import 'package:ecommercefrontend/app/presentation/pages/settings_page/theme_settings_page/theme_settings_page.dart';

// No drawer, adicione este ListTile:
ListTile(
  leading: const Icon(Icons.palette),
  title: const Text('Tema'),
  onTap: () {
    Navigator.pop(context); // Fecha o drawer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ThemeSettingsPage(),
      ),
    );
  },
),
```

## Opção 2: Via Go_Router (Clean Architecture)

Se usar go_router, adicione a rota em `app_router.dart`:

```dart
// routes.dart
const themeSettingsRoute = '/theme-settings';

// app_router.dart
GoRoute(
  path: '/theme-settings',
  name: 'themeSettings',
  builder: (context, state) => const ThemeSettingsPage(),
),

// No drawer, use:
context.goNamed('themeSettings');
```

## Opção 3: Via FloatingActionButton

Para teste rápido, adicione um FAB em home_screen.dart:

```dart
floatingActionButton: Stack(
  children: [
    // FAB existente de filtros
    FloatingActionButton(
      backgroundColor: accentColor,
      onPressed: () {
        showDialog(/* ... */);
      },
      child: const Icon(Icons.filter_alt),
    ),
    // Novo FAB para temas
    Positioned(
      bottom: 80,
      right: 0,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.purple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ThemeSettingsPage(),
            ),
          );
        },
        child: const Icon(Icons.palette),
      ),
    ),
  ],
),
```

## Opção 4: Via Settings Page Existente

Se tiver uma página de settings, importe e exiba a página de tema:

```dart
// settings_main_page.dart
import 'package:ecommercefrontend/app/presentation/pages/settings_page/theme_settings_page/theme_settings_page.dart';

class SettingsMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Tema da Aplicação'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeSettingsPage(),
                ),
              );
            },
          ),
          // ... outros itens de configuração
        ],
      ),
    );
  }
}
```

## Opção 5: TabBar com Configurações

Para organização mais elegante:

```dart
class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Geral'),
            Tab(text: 'Tema'),
            Tab(text: 'Perfil'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Aba de configurações gerais
          const Center(child: Text('Configurações Gerais')),
          
          // Aba de tema
          const ThemeSettingsPage(),
          
          // Aba de perfil
          const Center(child: Text('Perfil')),
        ],
      ),
    );
  }
}
```

## Testando a Página

### 1. **Acessar via Debug**
No Visual Studio Code, abra o terminal e execute:

```bash
flutter run
```

Depois navegue conforme implementado acima.

### 2. **Testar Funcionalidades**

- ✅ Selecionar nova cor primária
- ✅ Selecionar nova cor de acento
- ✅ Atualizar logo (colar URL)
- ✅ Atualizar banners
- ✅ Ver preview das alterações
- ✅ Resetar para tema padrão
- ✅ Verificar persistência (fechar e reabrir app)

### 3. **URLs Úteis Para Testar**

**Logos:**
```
https://upload.wikimedia.org/wikipedia/commons/4/44/Google-flutter-logo.svg
https://flutter.dev/assets/homepage/carousel/slide_1-layer_1.png
https://via.placeholder.com/200x100?text=Logo
```

**Banners:**
```
https://picsum.photos/seed/banner1/1200/500
https://picsum.photos/seed/banner2/1200/500
https://picsum.photos/1200/500?random=1
https://picsum.photos/1200/500?random=2
```

---

## 🎨 Cores Predefinidas Para Testar

```dart
// Azuis
0xFF1976D2  // Azul claro
0xFF0D47A1  // Azul escuro
0xFF0288D1  // Azul céu

// Vermelhos
0xFFD32F2F  // Vermelho escuro
0xFFFF5252  // Vermelho claro
0xFFE53935  // Vermelho médio

// Verdes
0xFF388E3C  // Verde escuro
0xFF4CAF50  // Verde claro
0xFF66BB6A  // Verde médio

// Roxos
0xFF7B1FA2  // Roxo escuro
0xFFAB47BC  // Roxo claro
0xFF9C27B0  // Roxo médio

// Laranjas
0xFFE65100  // Laranja escuro
0xFFFF6D00  // Laranja claro
0xFFFFA726  // Laranja médio

// Rosas
0xFFC2185B  // Rosa escuro
0xFFE91E63  // Rosa claro
0xFFEC407A  // Rosa médio
```

---

## 📱 Mockup da Página

```
┌─────────────────────────────┐
│  ← Configurações de Tema    │
├─────────────────────────────┤
│                             │
│  CORES DO TEMA              │
│  ┌──────────────────────┐   │
│  │ Cor Primária  [████]│   │
│  │ Escolher Cor        │   │
│  └──────────────────────┘   │
│  ┌──────────────────────┐   │
│  │ Cor de Acento [████]│   │
│  │ Escolher Cor        │   │
│  └──────────────────────┘   │
│                             │
│  LOGO DA APLICAÇÃO          │
│  [URL Input Field...]       │
│  [Logo Preview]             │
│  [Atualizar Logo]           │
│                             │
│  BANNERS DA HOME            │
│  Banner 1: [URL...]  [🗑]   │
│  Banner 2: [URL...]  [🗑]   │
│  Banner 3: [URL...]  [🗑]   │
│  [+ Adicionar]              │
│  [Salvar Banners]           │
│                             │
│  AÇÕES                      │
│  [Resetar para Padrão]      │
│                             │
└─────────────────────────────┘
```

---

## 🚀 Próximas Integrações

1. **Autenticação** - Salvar tema por usuário no backend
2. **Cloud Sync** - Sincronizar temas entre dispositivos
3. **Temas Predefinidos** - Galeria de temas prontos
4. **Export/Import** - Compartilhar temas entre usuários
5. **Agendamento** - Mudar tema em horários específicos

---

**Pronto para usar! 🎉**

