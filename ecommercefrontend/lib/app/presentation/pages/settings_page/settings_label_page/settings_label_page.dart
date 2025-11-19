import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ecommercefrontend/app/presentation/widgets/appbar/custom_appbar/custom_appbar.dart';
import 'package:ecommercefrontend/app/presentation/widgets/appbar/drawer/custom_drawer.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/white_label_data.dart';

class WhiteLabelSettingsPage extends StatefulWidget {
  const WhiteLabelSettingsPage({super.key});

  @override
  State<WhiteLabelSettingsPage> createState() => _WhiteLabelSettingsPageState();
}

class _WhiteLabelSettingsPageState extends State<WhiteLabelSettingsPage> {
  DropzoneViewController? logoController;
  DropzoneViewController? bannerController;

  Uint8List? logoBytes;
  List<Uint8List> bannerImages = [];

  Color primaryColor = const Color(0xFF1976D2);
  Color secondaryColor = const Color(0xFFFF6D00);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Carrega as configurações do SharedPreferences
  Future<void> _loadSettings() async {
    // Usa a classe WhiteLabelData para carregar dados
    final logo = await WhiteLabelData.getLogo();
    final banners = await WhiteLabelData.getBanners();
    final primaryColorValue = WhiteLabelData.getPrimaryColor();
    final secondaryColorValue = WhiteLabelData.getSecondaryColor();

    setState(() {
      logoBytes = logo;
      bannerImages = banners;
      primaryColor = Color(primaryColorValue);
      secondaryColor = Color(secondaryColorValue);
    });
  }

  // Salva as configurações no SharedPreferences
  Future<void> _saveSettings() async {
    try {
      // Usa a classe WhiteLabelData para salvar dados
      await WhiteLabelData.savePrimaryColor(primaryColor.value);
      await WhiteLabelData.saveSecondaryColor(secondaryColor.value);
      await WhiteLabelData.saveLogo(logoBytes);
      await WhiteLabelData.saveBanners(bannerImages);

      // Mostra mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurações salvas com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Mostra mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // -------------------------------------------------------------
  // CLICK PICKERS — Agora aceita qualquer formato
  // -------------------------------------------------------------
  Future<void> pickLogoByClick() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => logoBytes = result.files.first.bytes);
    }
  }

  Future<void> pickBannerByClick() async {
    if (bannerImages.length >= 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Máximo de 3 banners")));
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() => bannerImages.add(result.files.first.bytes!));
    }
  }

  // -------------------------------------------------------------
  // DROPZONE HANDLERS
  // -------------------------------------------------------------
  Future<void> uploadLogo(dynamic event) async {
    if (logoController == null) return;
    final bytes = await logoController!.getFileData(event);
    setState(() => logoBytes = bytes);
  }

  Future<void> uploadBanner(dynamic event) async {
    if (bannerController == null) return;

    if (bannerImages.length >= 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Máximo de 3 banners")));
      return;
    }

    final bytes = await bannerController!.getFileData(event);
    setState(() => bannerImages.add(bytes));
  }

  // -------------------------------------------------------------
  // COLOR PICKERS
  // -------------------------------------------------------------
  void pickPrimaryColor() {
    showDialog(
      context: context,
      builder: (_) {
        Color temp = primaryColor;
        return AlertDialog(
          title: const Text("Cor Primária"),
          content: ColorPicker(
            pickerColor: primaryColor,
            onColorChanged: (c) => temp = c,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => primaryColor = temp);
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void pickSecondaryColor() {
    showDialog(
      context: context,
      builder: (_) {
        Color temp = secondaryColor;
        return AlertDialog(
          title: const Text("Cor Secundária"),
          content: ColorPicker(
            pickerColor: secondaryColor,
            onColorChanged: (c) => temp = c,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => secondaryColor = temp);
                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  // -------------------------------------------------------------
  // BUILD PAGE
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomMainAppBar(),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _leftColumn()),
                  const SizedBox(width: 40),
                  Expanded(child: _rightColumn()),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Botão Salvar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Salvar Configurações',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // LEFT COLUMN — LOGO + CORES
  // -------------------------------------------------------------
  Widget _leftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Logo da Loja"),

        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: DropzoneView(
                onCreated: (ctrl) => logoController = ctrl,
                onDrop: uploadLogo,
              ),
            ),

            // BOTÃO INVISÍVEL PARA CAPTURAR CLIQUE ⚠
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: pickLogoByClick,
                child: Center(
                  child: logoBytes == null
                      ? const Text("Arraste ou clique para enviar logo")
                      : Image.memory(logoBytes!),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        if (logoBytes != null)
          TextButton.icon(
            onPressed: () => setState(() => logoBytes = null),
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text("Remover Logo"),
          ),

        const SizedBox(height: 40),

        _sectionTitle("Cores do Tema"),
        const SizedBox(height: 12),

        _colorBox("Cor Primária", primaryColor, pickPrimaryColor),
        const SizedBox(height: 16),

        _colorBox("Cor Secundária", secondaryColor, pickSecondaryColor),
      ],
    );
  }

  // -------------------------------------------------------------
  // RIGHT COLUMN — BANNERS
  // -------------------------------------------------------------
  Widget _rightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("Banners da Homepage (máx. 3)"),

        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: DropzoneView(
                onCreated: (ctrl) => bannerController = ctrl,
                onDrop: uploadBanner,
              ),
            ),

            // BOTÃO INVISÍVEL PARA CLIQUE
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: pickBannerByClick,
                child: const Center(
                  child: Text("Arraste até 3 imagens ou clique para escolher"),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (int i = 0; i < bannerImages.length; i++)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.memory(
                      bannerImages[i],
                      width: 180,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: InkWell(
                      onTap: () => setState(() => bannerImages.removeAt(i)),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------
  // HELPERS
  // -------------------------------------------------------------
  Widget _colorBox(String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        t,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
