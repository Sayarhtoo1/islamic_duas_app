import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_duas_app/providers/settings_provider.dart';
import 'package:islamic_duas_app/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController(
      text: Provider.of<SettingsProvider>(context, listen: false).geminiApiKey,
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Myanmar Title Color',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return DropdownButton<Color>(
                  value: settings.myanmarTitleColor,
                  onChanged: (Color? newValue) {
                    if (newValue != null) {
                      settings.setMyanmarTitleColor(newValue);
                    }
                  },
                  items: AppTheme.availableTextColors.map((colorOption) {
                    return DropdownMenuItem<Color>(
                      value: colorOption.color,
                      child: Text(colorOption.name, style: TextStyle(color: colorOption.color)),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Arabic Text Color',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return DropdownButton<Color>(
                  value: settings.arabicTextColor,
                  onChanged: (Color? newValue) {
                    if (newValue != null) {
                      settings.setArabicTextColor(newValue);
                    }
                  },
                  items: AppTheme.availableTextColors.map((colorOption) {
                    return DropdownMenuItem<Color>(
                      value: colorOption.color,
                      child: Text(colorOption.name, style: TextStyle(color: colorOption.color)),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Source Text Color',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return DropdownButton<Color>(
                  value: settings.sourceTextColor,
                  onChanged: (Color? newValue) {
                    if (newValue != null) {
                      settings.setSourceTextColor(newValue);
                    }
                  },
                  items: AppTheme.availableTextColors.map((colorOption) {
                    return DropdownMenuItem<Color>(
                      value: colorOption.color,
                      child: Text(colorOption.name, style: TextStyle(color: colorOption.color)),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Text Size',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return Slider(
                  value: settings.textSize,
                  min: 12,
                  max: 24,
                  divisions: 4,
                  label: settings.textSize.round().toString(),
                  onChanged: (double value) {
                    settings.setTextSize(value);
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'App Theme',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return DropdownButton<ThemeModeOption>(
                  value: settings.themeMode,
                  onChanged: (ThemeModeOption? newValue) {
                    if (newValue != null) {
                      settings.setThemeMode(newValue);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeModeOption.system,
                      child: Text('System Default'),
                    ),
                    DropdownMenuItem(
                      value: ThemeModeOption.light,
                      child: Text('Light Theme'),
                    ),
                    DropdownMenuItem(
                      value: ThemeModeOption.dark,
                      child: Text('Dark Theme'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Gemini API Key',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return TextField(
                  controller: _apiKeyController,
                  decoration: const InputDecoration(
                    hintText: 'သင့် Gemini API Key ကို ထည့်သွင်းပါ',
                  ),
                );
              },
            ),
            const SizedBox(height: 10), // Add some spacing
            ElevatedButton(
              onPressed: () {
                final settings = Provider.of<SettingsProvider>(context, listen: false);
                settings.setGeminiApiKey(_apiKeyController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('API Key saved!')),
                );
              },
              child: const Text('Save API Key'),
            ),
          ],
        ),
      ),
    );
  }
}
