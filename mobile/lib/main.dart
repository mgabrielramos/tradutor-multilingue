import "package:flutter/material.dart";
import "package:provider/provider.dart";

void main() {
  runApp(const TradutorApp());
}

class TradutorApp extends StatelessWidget {
  const TradutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TranslationController(),
      child: MaterialApp(
        title: "Tradutor Múltiplo",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TranslationController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Tradutor Múltiplo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Texto para traduzir",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              onChanged: controller.setText,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: controller.sourceLang,
              decoration: const InputDecoration(
                labelText: "Idioma de origem",
                border: OutlineInputBorder(),
              ),
              items: controller.availableLangs
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: controller.setSourceLang,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: controller.availableLangs
                  .where((lang) => lang != controller.sourceLang)
                  .map((lang) => FilterChip(
                        label: Text(lang),
                        selected: controller.targetLangs.contains(lang),
                        onSelected: (_) => controller.toggleTargetLang(lang),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed:
                  controller.isLoading ? null : () => controller.translate(),
              child: controller.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Traduzir"),
            ),
            const SizedBox(height: 16),
            if (controller.error != null)
              Text(
                controller.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            if (controller.usage != null)
              Text(
                "Uso: ${controller.usage!.count}/${controller.usage!.limit ?? "∞"}",
              ),
            const Divider(),
            Expanded(
              child: ListView(
                children: controller.translations
                    .map((item) => ListTile(
                          title: Text(item.lang),
                          subtitle: Text(item.text),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TranslationController extends ChangeNotifier {
  final availableLangs = const ["pt", "en", "es", "fr", "de", "it"];
  final List<TranslationItem> translations = [];
  final Set<String> targetLangs = {"en", "es"};
  bool isLoading = false;
  String? error;
  String text = "";
  String sourceLang = "pt";
  Usage? usage;

  void setText(String value) {
    text = value;
  }

  void setSourceLang(String? value) {
    if (value == null) return;
    sourceLang = value;
    targetLangs.remove(value);
    notifyListeners();
  }

  void toggleTargetLang(String lang) {
    if (targetLangs.contains(lang)) {
      targetLangs.remove(lang);
    } else {
      targetLangs.add(lang);
    }
    notifyListeners();
  }

  Future<void> translate() async {
    if (text.trim().isEmpty || targetLangs.isEmpty) {
      error = "Informe o texto e selecione idiomas de destino.";
      notifyListeners();
      return;
    }
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // TODO: integrar com backend real (POST /v1/translate)
      translations
        ..clear()
        ..addAll(
          targetLangs.map(
            (lang) => TranslationItem(lang: lang, text: "[Demo $lang] $text"),
          ),
        );
      usage = Usage(count: 1, limit: 20);
    } catch (_) {
      error = "Falha ao traduzir. Tente novamente.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class TranslationItem {
  TranslationItem({required this.lang, required this.text});
  final String lang;
  final String text;
}

class Usage {
  Usage({required this.count, required this.limit});
  final int count;
  final int? limit;
}
