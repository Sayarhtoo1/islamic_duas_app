import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_duas_app/providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';

// StatefulWidget အဖြစ်ပြောင်းလဲလိုက်ပါသည်၊ ምክንያቱም TextEditingController ကိုသုံးရန်လိုအပ်သောကြောင့်ဖြစ်သည်
class ApiKeyGuidanceScreen extends StatefulWidget {
  const ApiKeyGuidanceScreen({super.key});

  @override
  State<ApiKeyGuidanceScreen> createState() => _ApiKeyGuidanceScreenState();
}

class _ApiKeyGuidanceScreenState extends State<ApiKeyGuidanceScreen> {
  // TextField ကို ထိန်းချုပ်ရန် Controller
  final _apiKeyController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  // Key ကို သိမ်းဆည်းရန် function
  void _saveApiKeyAndReturn() {
    if (_apiKeyController.text.trim().isNotEmpty) {
      // Provider ကိုသုံးပြီး API key ကိုသိမ်းဆည်းပါ
      // context.read<T>() is a shorter way to get a provider without listening
      context.read<SettingsProvider>().setGeminiApiKey(_apiKeyController.text.trim());
      
      // အောင်မြင်ကြောင်း user ကိုအသိပေးပါ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API Key ကို အောင်မြင်စွာ သိမ်းဆည်းပြီးပါပြီ။'),
          backgroundColor: Colors.green,
        ),
      );
      
      // ယခင် screen သို့ပြန်သွားပါ
      Navigator.of(context).pop();
    } else {
      // Key မထည့်ဘဲနှိပ်လျှင် error ပြပါ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ကျေးဇူးပြု၍ ရရှိလာသော API Key ကို ထည့်သွင်းပါ။'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Key ထည့်သွင်းရန်'),
      ),
      // SingleChildScrollView ကိုသုံးခြင်းဖြင့် keyboard တက်လာလျှင် UI မပြည့်ကျပ်တော့ပါ
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'အသံထွက်ဖတ်ရန် Gemini API Key လိုအပ်ပါသည်',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // --- အသစ်ထပ်ထည့်ထားသော အပိုင်း ---
            // Key ထည့်သွင်းရန် TextField
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'ရရှိလာသော API Key ကို ဤနေရာတွင်ထည့်ပါ',
                hintText: 'Paste your API Key here...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key_outlined),
              ),
            ),
            const SizedBox(height: 12),
            
            // Key ကို သိမ်းဆည်းရန် Button
            ElevatedButton(
              onPressed: _saveApiKeyAndReturn,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('API Key ကို သိမ်းဆည်းမည်'),
            ),
            // ---------------------------------
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const Text(
              'API Key မရှိသေးလျှင် ရယူရန် အဆင့်များ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // လမ်းညွှန်ချက်များကို ပိုမိုရှင်းလင်းအောင် ပြန်လည်រៀបចំထားသည်
            _InstructionStep(
              step: '၁။',
              text: 'VPN တစ်ခုခုဖွင့်ထားရန် အကြံပြုပါသည်။',
              icon: Icons.shield_outlined,
            ),
            _InstructionStep(
              step: '၂။',
              text: 'အောက်ပါ "Google AI Studio သို့ သွားရန်" ခလုတ်ကိုနှိပ်ပါ။',
              icon: Icons.touch_app_outlined,
            ),
            _InstructionStep(
              step: '၃။',
              text: 'Google အကောင့်ဖြင့်ဝင်ပြီး "Create API key" ကိုနှိပ်ပါ။',
              icon: Icons.add_box_outlined,
            ),
            _InstructionStep(
              step: '၄။',
              text: 'ပေါ်လာသော Key ကို copy ကူးပြီး အပေါ်ကအကွက်တွင် ပြန်ထည့်ပါ။',
              icon: Icons.content_paste_go,
            ),
            const SizedBox(height: 24),

            // URL ဖွင့်ရန် Button
            OutlinedButton.icon(
              onPressed: () async {
                final url = Uri.parse('https://aistudio.google.com/app/apikey');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text('Google AI Studio သို့ သွားရန်'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// လမ်းညွှန်ချက်အဆင့်များကို ပြသရန်အတွက် သီးသန့် Widget
class _InstructionStep extends StatelessWidget {
  final String step;
  final String text;
  final IconData icon;

  const _InstructionStep({
    required this.step,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$step $text',
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
