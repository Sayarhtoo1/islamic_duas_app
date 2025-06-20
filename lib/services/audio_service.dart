import 'package:flutter/foundation.dart'; // Import for ValueNotifier
import 'package:audioplayers/audioplayers.dart';
// Import for Uint8List

class AudioService {
  late AudioPlayer _audioPlayer;
  final ValueNotifier<String?> _currentPlayingAudioNotifier = ValueNotifier(null);

  AudioService() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerComplete.listen((event) {
      _currentPlayingAudioNotifier.value = null;
    });
  }

  ValueNotifier<String?> get currentPlayingAudioNotifier => _currentPlayingAudioNotifier;
  String? get currentPlayingAudio => _currentPlayingAudioNotifier.value;

  Future<void> play(String audioPath) async {
    if (_currentPlayingAudioNotifier.value == audioPath) {
      await _audioPlayer.pause();
      _currentPlayingAudioNotifier.value = null;
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(audioPath));
      _currentPlayingAudioNotifier.value = audioPath;
    }
  }

  Future<void> playBytes(Uint8List audioBytes) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(BytesSource(audioBytes));
    _currentPlayingAudioNotifier.value = "gemini_tts_audio"; // A placeholder to indicate playing from bytes
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentPlayingAudioNotifier.value = null;
  }

  void dispose() {
    _audioPlayer.dispose();
    _currentPlayingAudioNotifier.dispose();
  }
}
