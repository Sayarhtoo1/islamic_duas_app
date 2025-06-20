import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_duas_app/models/dua.dart';
import 'package:islamic_duas_app/models/supplication.dart';
import 'package:islamic_duas_app/providers/favorite_dua_provider.dart';
import 'package:islamic_duas_app/providers/settings_provider.dart';
import 'package:islamic_duas_app/services/audio_service.dart';
import 'package:islamic_duas_app/services/tts_http_service.dart';
import 'package:islamic_duas_app/screens/api_key_guidance_screen.dart';

class DuaDetailScreen extends StatefulWidget {
  final Dua dua;
  const DuaDetailScreen({super.key, required this.dua});

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  late AudioService _audioService;
  late TtsHttpService _ttsService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _ttsService = TtsHttpService(
      apiKey: Provider.of<SettingsProvider>(context, listen: false).geminiApiKey,
      onApiKeyMissing: _showApiKeyMissingDialog,
    );
    Provider.of<SettingsProvider>(context, listen: false).addListener(_updateTtsServiceApiKey);
  }

  void _updateTtsServiceApiKey() {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _ttsService.updateApiKey(settings.geminiApiKey);
  }

  @override
  void dispose() {
    _audioService.dispose();
    _ttsService.dispose();
    Provider.of<SettingsProvider>(context, listen: false).removeListener(_updateTtsServiceApiKey);
    super.dispose();
  }

  Future<void> _playLocalAudio(String audioPath) async {
    if (_ttsService.isPlaying.value) {
      await _ttsService.stop();
    }
    await _audioService.play(audioPath);
  }

  void _showApiKeyMissingDialog() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ApiKeyGuidanceScreen()));
  }

  Future<void> _handleSpeakButtonPressed(String text, String uniqueId) async {
    await _audioService.stop();
    await _ttsService.speak(text, uniqueId: uniqueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dua.titleMyanmar, style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          Consumer<FavoriteDuaProvider>(
            builder: (context, provider, child) => IconButton(
              icon: Icon(provider.isFavorite(widget.dua) ? Icons.favorite : Icons.favorite_border),
              onPressed: () => provider.toggleFavorite(widget.dua),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.dua.narrationMyanmar, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.center),
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.dua.supplications.length,
              itemBuilder: (context, index) {
                Supplication supplication = widget.dua.supplications[index];
                String audioPath = 'assets/audio/${widget.dua.id}_$index.mp3';
                String ttsUniqueId = 'dua_${widget.dua.id}_supplication_$index';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(supplication.arabicText, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center, textDirection: TextDirection.rtl),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<String?>(
                              valueListenable: _audioService.currentPlayingAudioNotifier,
                              builder: (context, currentPlayingAudio, child) {
                                final bool isThisLocalPlaying = currentPlayingAudio == audioPath;
                                return IconButton(
                                  icon: Icon(isThisLocalPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 40),
                                  onPressed: () => isThisLocalPlaying ? _audioService.stop() : _playLocalAudio(audioPath),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            // ***** အဓိက UI ပြင်ဆင်ချက် - Loading Indicator Logic *****
                            ValueListenableBuilder<String?>(
                              valueListenable: _ttsService.loadingAudioId,
                              builder: (context, loadingId, child) {
                                final bool isThisOneLoading = (loadingId == ttsUniqueId);

                                // If this button's audio is generating, show a spinner.
                                if (isThisOneLoading) {
                                  return Container(
                                    width: 48,
                                    height: 48,
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Theme.of(context).primaryColor),
                                  );
                                }

                                // Otherwise, show the play/pause button based on playing state.
                                return ValueListenableBuilder<bool>(
                                  valueListenable: _ttsService.isPlaying,
                                  builder: (context, isPlayingValue, child) {
                                    final bool isThisTtsPlaying = _ttsService.isAudioPlaying(ttsUniqueId);
                                    return IconButton(
                                      icon: Icon(isThisTtsPlaying ? Icons.pause_circle_filled : Icons.volume_up_rounded, size: 40),
                                      onPressed: () => isThisTtsPlaying ? _ttsService.stop() : _handleSpeakButtonPressed(supplication.arabicText, ttsUniqueId),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text(supplication.virtueMyanmar, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                        // ... other widgets
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20.0),
            Text('Source: ${widget.dua.source}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic), textAlign: TextAlign.center),
            // ... other widgets
          ],
        ),
      ),
    );
  }
}