# Sistema de Tema Dinâmico - Documentação

## 📋 Visão Geral

Este documento descreve a implementação de um sistema completo de gerenciamento de tema dinâmico para a aplicação E-commerce. O sistema permite alterar cores (primária e acento), logo e banners da aplicação em tempo real, mantendo as mudanças persistidas.

## 🏗️ Arquitetura

O sistema segue os princípios de **Clean Architecture** e **SOLID**, dividido em camadas:

### 1. **Domain Layer** (Lógica de Negócio)
```
lib/app/domain/
├── entities/theme/
│   └── app_theme.dart          # Entidade AppTheme com dados imutáveis
├── repositories/
│   └── theme_repository.dart   # Interface abstrata do repositório
└── usecases/theme/
    ├── get_current_theme_usecase.dart
    ├── save_theme_usecase.dart
    ├── get_available_themes_usecase.dart
    └── reset_to_default_theme_usecase.dart
```

**Responsabilidades:**
- Definir contratos e entidades independentes de detalhes de implementação
- Encapsular a lógica de negócio específica do domínio

### 2. **Data Layer** (Fonte de Dados)
```
lib/app/data/
├── datasources/theme/
│   └── theme_local_data_source.dart   # Interface e implementação local
├── models/theme/
│   └── theme_model.dart               # Modelo com serialização
└── repositories/
    └── theme_repository_impl.dart     # Implementação concreta do repositório
```

**Responsabilidades:**
- Abstrair a persistência de dados (SharedPreferences)
- Converter entre modelos de dados
- Implementar a interface do repositório

### 3. **Presentation Layer** (UI e Estado)
```
lib/app/presentation/
├── cubits/theme/
│   ├── theme_cubit.dart       # Gerenciador de estado (BLoC)
│   └── theme_state.dart       # Estados possíveis
└── pages/
    ├── home_screen/
    │   └── home_screen.dart   # Integração com tema
    ├── settings_page/
    │   └── theme_settings_page/
    │       └── theme_settings_page.dart  # Página de configuração
    └── widgets/
        ├── appbar/custom_appbar/
        │   └── custom_appbar.dart        # AppBar dinâmica
        └── custom_carrousel/
            └── custom_carrousel.dart     # Carousel com banners dinâmicos
```

**Responsabilidades:**
- Gerenciar estado da aplicação com BLoC/Cubit
- Reagir a mudanças de estado com BlocBuilder
- Fornecer UI para configuração de temas

## 🔄 Fluxo de Dados

```
┌─────────────────────┐
│   Presentation      │
│   (UI/BlocBuilder)  │
└──────────┬──────────┘
           │
    ┌──────▼──────┐
    │  ThemeCubit │  (Gerencia estado)
    └──────┬──────┘
           │
    ┌──────▼──────────┐
    │  Use Cases      │  (Lógica de negócio)
    └──────┬──────────┘
           │
    ┌──────▼────────────────┐
    │ ThemeRepository (impl) │
    └──────┬────────────────┘
           │
    ┌──────▼─────────┐
    │  Data Source    │
    │  (Shared Prefs) │
    └─────────────────┘
```

## 💉 Injeção de Dependências (GetIt)

As dependências são registradas no `service_locator.dart`:

```dart
// Data Sources
getIt.registerSingleton<ThemeLocalDataSource>(
  ThemeLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
);

// Repositories
getIt.registerSingleton<ThemeRepository>(
  ThemeRepositoryImpl(localDataSource: getIt<ThemeLocalDataSource>()),
);

// Use Cases
getIt.registerSingleton<GetCurrentThemeUsecase>(
  GetCurrentThemeUsecase(getIt<ThemeRepository>()),
);

// Cubits
getIt.registerSingleton<ThemeCubit>(
  ThemeCubit(
    getCurrentThemeUsecase: getIt<GetCurrentThemeUsecase>(),
    // ... outros use cases
  ),
);
```

## 🎨 Como Usar

### 1. **Acessar o Tema Atual**

```dart
BlocBuilder<ThemeCubit, ThemeState>(
  builder: (context, state) {
    if (state is ThemeLoaded) {
      final primaryColor = state.theme.primaryColor;
      final accentColor = state.theme.accentColor;
      // Usar as cores...
    }
  },
)
```

### 2. **Atualizar Cores**

```dart
// Atualizar cor primária
context.read<ThemeCubit>().updatePrimaryColor(0xFF1976D2);

// Atualizar cor de acento
context.read<ThemeCubit>().updateAccentColor(0xFFFF6D00);

// Atualizar tema completo
context.read<ThemeCubit>().updateTheme(newTheme);
```

### 3. **Atualizar Logo**

```dart
context.read<ThemeCubit>().updateLogo('https://exemplo.com/logo.png');
```

### 4. **Atualizar Banners**

```dart
context.read<ThemeCubit>().updateBanners([
  'https://exemplo.com/banner1.jpg',
  'https://exemplo.com/banner2.jpg',
]);
```

### 5. **Resetar para Tema Padrão**

```dart
context.read<ThemeCubit>().resetToDefaultTheme();
```

## 📱 Componentes Integrados

### CustomMainAppBar
- Logo dinâmico baseado no tema
- Cores primária e de acento aplicadas aos ícones
- Atualização em tempo real

### HomeCarousel
- Banners dinâmicos do tema
- Indicador de slides com cor primária

### HomeScreen
- Cores dinâmicas no FAB (usa cor de acento)
- Card de produtos com cores do tema

### ThemeSettingsPage
- Seleção de cores com preview
- Upload de logo com preview
- Gerenciamento de banners
- Ação para resetar tema padrão

## 🔒 Princípios Aplicados

### SOLID
- **S**ingle Responsibility: Cada classe tem uma responsabilidade
- **O**pen/Closed: Aberto para extensão, fechado para modificação
- **L**iskov Substitution: Implementações podem substituir interfaces
- **I**nterface Segregation: Interfaces específicas e focadas
- **D**ependency Inversion: Depende de abstrações, não de implementações

### Clean Architecture
- Separação clara de responsabilidades
- Independência de frameworks (Flutter é um detalhe)
- Testabilidade facilitada
- Mudanças localizadas

## 📊 Estados do Cubit

```dart
ThemeInitial      → Estado inicial
ThemeLoading      → Carregando tema
ThemeLoaded       → Tema carregado com sucesso
ThemeError        → Erro ao processar
```

## 💾 Persistência

Os dados são salvos no **SharedPreferences** com as chaves:
- `current_theme`: Tema atualmente selecionado
- `available_themes`: Lista de temas disponíveis

## 🧪 Como Testar

```dart
// Unit test
test('Deve atualizar cor primária', () async {
  final cubit = ThemeCubit(
    getCurrentThemeUsecase: mockGetCurrentThemeUsecase,
    // ...
  );
  
  await cubit.updatePrimaryColor(0xFF1976D2);
  
  expect(
    cubit.state,
    isA<ThemeLoaded>().having(
      (state) => state.theme.primaryColor,
      'primaryColor',
      const Color(0xFF1976D2),
    ),
  );
});
```

## 📈 Próximos Passos Sugeridos

1. **Temas Predefinidos**: Criar múltiplos temas salvos
2. **Sincronização na Nuvem**: Sincronizar tema com backend
3. **Modo Escuro**: Adicionar suporte a tema escuro/claro
4. **Animações**: Transições suaves ao mudar tema
5. **Validação**: Validar URLs de imagens antes de salvar

## 📝 Arquivos Principais

| Arquivo | Descrição |
|---------|-----------|
| `app_theme.dart` | Entidade do tema |
| `theme_repository.dart` | Interface do repositório |
| `theme_local_data_source.dart` | Persistência local |
| `theme_cubit.dart` | Gerenciador de estado |
| `service_locator.dart` | Configuração de injeção |
| `theme_settings_page.dart` | UI de configuração |
| `my_app.dart` | Integração global |

## 🤝 Contribuindo

Ao adicionar novos campos de tema:
1. Atualize `AppTheme` em `app_theme.dart`
2. Atualize `ThemeModel` em `theme_model.dart`
3. Adicione serialização em `toJson()` e `fromJson()`
4. Adicione método no `ThemeCubit`
5. Adicione UI na `ThemeSettingsPage`

---

**Desenvolvido seguindo as melhores práticas de Clean Architecture e SOLID Principles** ✨
