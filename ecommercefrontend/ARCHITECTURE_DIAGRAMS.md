# 🎨 Diagrama Visual - Fluxo de Imagens

## 📐 Arquitetura Completa

```
┌─────────────────────────────────────────────────────────────────┐
│                        APLICAÇÃO FLUTTER                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────┐         ┌──────────────┐                      │
│  │  main.dart   │         │ MyApp        │                      │
│  │              │────────▶│              │                      │
│  │ Initialize:  │         │ BlocProvider │                      │
│  │ • WLD init   │         │  ThemeCubit  │                      │
│  │ • Service    │         │              │                      │
│  │   Locator    │         └──────────────┘                      │
│  └──────────────┘                  │                            │
│                                    │                            │
│                    ┌───────────────┴────────────────┐           │
│                    ▼                                ▼           │
│           ┌──────────────────┐        ┌──────────────────┐      │
│           │  CustomAppBar    │        │  HomeCarousel    │      │
│           │                  │        │                  │      │
│           │ FutureBuilder    │        │ FutureBuilder    │      │
│           │ ↓                │        │ ↓                │      │
│           │ WLD.getLogo()    │        │ WLD.getBanners() │      │
│           │ ↓                │        │ ↓                │      │
│           │ Image.memory()   │        │ CarouselSlider   │      │
│           │ Logo             │        │ Banners          │      │
│           └──────────────────┘        └──────────────────┘      │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │      Settings Label Page (Configuração)                 │   │
│  │                                                          │   │
│  │  Upload Logo     Upload Banners    Picker Cores        │   │
│  │      ▼                ▼                  ▼              │   │
│  │    Show Preview   Show Preview        Show Color       │   │
│  │      │                │                   │            │   │
│  │      └────────────────┴───────────────────┘            │   │
│  │                       │                                │   │
│  │                       ▼                                │   │
│  │          [Botão Salvar Configurações]                │   │
│  │          WhiteLabelData.save*()                       │   │
│  │                       │                                │   │
│  │                       ▼                                │   │
│  │          SharedPreferences (Base64)                   │   │
│  │                                                          │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
                           │
                           ▼
                  ┌────────────────────┐
                  │ SharedPreferences  │
                  │                    │
                  │ • primary_color    │
                  │ • secondary_color  │
                  │ • logo_base64      │
                  │ • banners_base64   │
                  └────────────────────┘
```

---

## 🔄 Sequência de Operações - Salvando

```
SETTINGS PAGE
│
├─[1] Usuário seleciona arquivo (FilePickr/Dropzone)
│    │
│    └─→ Uint8List logoBytes = arquivo em memória
│
├─[2] Usuário clica "Salvar Configurações"
│    │
│    └─→ _saveSettings() chamado
│
├─[3] WhiteLabelData.saveLogo(logoBytes)
│    │
│    ├─→ base64Encode(logoBytes) = String Base64
│    │
│    └─→ _prefs.setString('whitelabel_logo_base64', base64)
│        │
│        └─→ SharedPreferences armazena
│
├─[4] WhiteLabelData.saveBanners(bannerImages)
│    │
│    ├─→ Foreach banner: base64Encode(bytes)
│    │
│    ├─→ jsonEncode(['base64_1', 'base64_2', ...])
│    │
│    └─→ _prefs.setString('whitelabel_banners_base64', json)
│
├─[5] ScaffoldMessenger mostra SnackBar verde
│
└─[6] Dados persistidos! ✅
```

---

## 🔄 Sequência de Operações - Carregando (AppBar)

```
CUSTOM APP BAR
│
├─[1] App inicia
│    │
│    └─→ main.dart: await WhiteLabelData.initialize()
│        │
│        └─→ _prefs = await SharedPreferences.getInstance()
│
├─[2] MyApp renderiza com BlocProvider<ThemeCubit>
│
├─[3] CustomAppBar widget renderiza
│    │
│    └─→ BlocBuilder<ThemeCubit>
│
├─[4] FutureBuilder(future: WhiteLabelData.getLogo())
│    │
│    ├─→ Async: WhiteLabelData.getLogo()
│    │   │
│    │   ├─→ String? logoBase64 = _prefs.getString('whitelabel_logo_base64')
│    │   │
│    │   └─→ if (logoBase64 != null)
│    │       │
│    │       └─→ return base64Decode(logoBase64) → Uint8List
│    │
│    └─→ snapshot.data = Uint8List (ou null)
│
├─[5] if (customLogo != null)
│    │
│    ├─→ Image.memory(customLogo, width: 70) ✅ LOGO CUSTOMIZADO
│    │
│    else
│    │
│    └─→ Image.network(logoUrl) ✅ LOGO PADRÃO (fallback)
│
└─[6] Logo exibido na AppBar! 🎨
```

---

## 🔄 Sequência de Operações - Carregando (Carousel)

```
HOME CAROUSEL
│
├─[1] App inicia
│    │
│    └─→ WhiteLabelData inicializado ✅
│
├─[2] HomeCarousel widget renderiza
│
├─[3] FutureBuilder(future: WhiteLabelData.getBanners())
│    │
│    ├─→ Async: WhiteLabelData.getBanners()
│    │   │
│    │   ├─→ String? bannersJson = _prefs.getString('whitelabel_banners_base64')
│    │   │
│    │   └─→ if (bannersJson != null)
│    │       │
│    │       ├─→ jsonDecode(bannersJson) → List<dynamic>
│    │       │
│    │       └─→ forEach: base64Decode(base64) → Uint8List
│    │
│    └─→ snapshot.data = List<Uint8List>
│
├─[4] CarouselSlider.builder()
│    │
│    ├─→ itemCount = hasCustomBanners ? len : 4
│    │
│    └─→ itemBuilder: (index)
│        │
│        └─→ if (hasCustomBanners)
│            │
│            ├─→ Image.memory(customBanners[index]) ✅ BANNERS CUSTOMIZADOS
│            │
│            else
│            │
│            └─→ Image.network(defaultBannerUrl) ✅ BANNERS PADRÃO (fallback)
│
├─[5] SmoothPageIndicator
│    │
│    └─→ Dots acompanham carousel
│
└─[6] Banners exibidos e navegáveis! 🎨
```

---

## 📊 Estrutura de Dados

### Logo (Armazenado)

```
SharedPreferences.getString('whitelabel_logo_base64')
↓
"iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ"
"AAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU"
"5ErkJggg=="
↓
base64Decode()
↓
Uint8List: [137, 80, 78, 71, 13, 10, 26, 10, ...]
↓
Image.memory()
↓
🖼️ Logo exibido
```

### Banners (Armazenado)

```
SharedPreferences.getString('whitelabel_banners_base64')
↓
'["iVBORw0KGg...", "iVBORw0KGg...", "iVBORw0KGg..."]'
↓
jsonDecode()
↓
['iVBORw0KGg...', 'iVBORw0KGg...', 'iVBORw0KGg...']
↓
forEach: base64Decode()
↓
[Uint8List, Uint8List, Uint8List]
↓
CarouselSlider.builder() → Image.memory() para cada
↓
🖼️ Banners exibidos no carousel
```

---

## 🎯 Prioridade de Exibição

### Exemplo 1: Logo Customizado Existe

```
App inicia
    ↓
SharedPreferences tem logo_base64
    ↓
WhiteLabelData.getLogo() retorna Uint8List
    ↓
snapshot.data != null
    ↓
Image.memory() renderiza
    ↓
✅ Logo customizado exibido na AppBar
```

### Exemplo 2: Logo Customizado NÃO Existe

```
App inicia
    ↓
SharedPreferences NÃO tem logo_base64
    ↓
WhiteLabelData.getLogo() retorna null
    ↓
snapshot.data == null
    ↓
Image.network() renderiza (URL padrão)
    ↓
✅ Logo padrão exibido na AppBar (fallback)
```

### Exemplo 3: Banners Customizados Existem

```
HomeCarousel renderiza
    ↓
WhiteLabelData.getBanners() retorna List<Uint8List>
    ↓
hasCustomBanners == true
    ↓
CarouselSlider mostra imagens customizadas
    ↓
Image.memory() para cada banner
    ↓
✅ Banners customizados no carousel
```

### Exemplo 4: Banners Customizados NÃO Existem

```
HomeCarousel renderiza
    ↓
WhiteLabelData.getBanners() retorna []
    ↓
hasCustomBanners == false
    ↓
CarouselSlider mostra banners padrão
    ↓
Image.network() para cada URL padrão
    ↓
✅ Banners padrão no carousel (fallback)
```

---

## 🔐 Segurança de Dados

```
┌────────────────────────────────────────────┐
│         WhiteLabelData (Em Memória)        │
│                                            │
│  _prefs: SharedPreferences (privado)      │
│  • Não acessível de fora                  │
│  • Métodos públicos controlam acesso      │
└────────────────────────────────────────────┘
               │
               ▼
┌────────────────────────────────────────────┐
│       SharedPreferences (No Disco)         │
│                                            │
│  • Armazenado no app data directory       │
│  • Isolado por app                        │
│  • Base64 é encoding (não criptografia)   │
└────────────────────────────────────────────┘
```

---

## ⚡ Performance

### Carregamento

```
App Start: WhiteLabelData.initialize()
  └─→ Sync: Carrega SharedPreferences em memória (~1ms)

CustomAppBar renderiza:
  └─→ FutureBuilder chama getLogo()
      └─→ Async: Lê de cache em memória (~0.1ms)
          └─→ Decode Base64 (~5-50ms dependendo tamanho)
              └─→ Renderiza com Image.memory()

Resultado: AppBar exibido em <100ms total
```

### Persistência

```
_saveSettings() chamado
  └─→ WhiteLabelData.saveLogo()
      └─→ base64Encode() (~50ms para 1MB)
          └─→ SharedPreferences.setString()
              └─→ Escrita em disco (~100-500ms)

Resultado: Salvamento completo em <1s
```

---

## 🧪 Testes Recomendados

### Teste 1: Logo Upload & Display

```
[START] ─→ Settings Page
         ─→ Upload Logo
         ─→ Click Save
         ─→ SnackBar ✅
         ─→ Go Home
         ─→ Logo on AppBar ✅
         ─→ Restart App
         ─→ Logo Still There ✅
         ─→ [PASS]
```

### Teste 2: Multiple Banners

```
[START] ─→ Settings Page
         ─→ Upload 3 Banners
         ─→ Show Previews ✅
         ─→ Click Save
         ─→ Go Home
         ─→ See Custom Banners ✅
         ─→ Click Dots (Nav) ✅
         ─→ Restart App
         ─→ Banners Still There ✅
         ─→ [PASS]
```

### Teste 3: Fallback

```
[START] ─→ Clear App Data
         ─→ Start App
         ─→ AppBar has Default Logo ✅
         ─→ Home has Default Banners ✅
         ─→ [PASS]
```

---

## 📱 Resposta a Diferentes Cenários

| Cenário | Logo | Banners |
|---------|------|---------|
| **Primeira execução** | Padrão (URL) | Padrão (URLs) |
| **Após upload** | Customizado | Customizado |
| **App fecha/abre** | Persistido ✅ | Persistido ✅ |
| **Clear data** | Padrão (URL) | Padrão (URLs) |
| **Sem internet** | Customizado ✅ | Customizado ✅ |
| **Com internet** | Customizado (prioridade) | Customizado (prioridade) |

---

**Última atualização**: Novembro 2025
**Status**: ✅ Pronto para Produção

