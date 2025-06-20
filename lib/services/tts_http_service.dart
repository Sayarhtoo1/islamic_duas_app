import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class TtsHttpService {
  // --- Configuration ---
  String _apiKey; 
  final VoidCallback? onApiKeyMissing;
  static const String _modelId = "gemini-2.5-flash-preview-tts";
  String get _apiUrl => "https://generativelanguage.googleapis.com/v1beta/models/$_modelId:streamGenerateContent?key=$_apiKey&alt=sse";
  
  // --- State Notifiers ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);
  final ValueNotifier<String?> loadingAudioId = ValueNotifier(null); // *** အသစ်ထပ်ထည့်ထားသော Notifier ***
  String? _currentlyPlayingPath;

  TtsHttpService({required String apiKey, this.onApiKeyMissing}) : _apiKey = apiKey {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state != PlayerState.playing) {
        isPlaying.value = false;
        _currentlyPlayingPath = null;
      }
    });
  }

  void updateApiKey(String newApiKey) {
    _apiKey = newApiKey;
  }

  Future<void> speak(String text, {String? uniqueId, String voiceName = "Aoede"}) async {
    if (_apiKey.isEmpty) {
      onApiKeyMissing?.call();
      return;
    }
    if (isPlaying.value) {
      await stop();
    }
    
    final fileName = uniqueId ?? text.hashCode.toString();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/tts_cache/$fileName.wav';
    final file = File(filePath);
    
    _currentlyPlayingPath = filePath;

    if (await file.exists()) {
      debugPrint("Playing from cache: $filePath");
      isPlaying.value = true;
      await _audioPlayer.play(DeviceFileSource(filePath));
      return;
    }

    // ***** အဓိက အပြောင်းအလဲ - Generating မစခင် Loading State ကို သတ်မှတ်ပါ *****
    loadingAudioId.value = uniqueId;
    
    try {
      debugPrint("Generating new audio file for: $fileName");
      final String fullPrompt = "Read with tajweed\n\n$text";
      final requestBody = {
        "contents": [ {"role": "user", "parts": [ {"text": fullPrompt} ]} ],
        "generationConfig": {
          "temperature": 1, "responseModalities": ["audio"], 
          "speech_config": { "voice_config": { "prebuilt_voice_config": { "voice_name": voiceName } } }
        }
      };
      
      final response = await http.post(
        Uri.parse(_apiUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode(requestBody)
      );

      if (response.statusCode == 200) {
        final sseEvents = response.body.split('\n\n');
        String fullJsonString = "";
        for (var event in sseEvents) {
          if (event.startsWith('data: ')) {
            fullJsonString += event.substring(6);
          }
        }
        final decodedResponse = jsonDecode(fullJsonString);
        final base64AudioData = decodedResponse['candidates'][0]['content']['parts'][0]['inlineData']['data'];

        if (base64AudioData != null) {
          final rawAudioBytes = base64Decode(base64AudioData);
          final wavBytes = TtsHttpService._addWavHeader(rawAudioBytes);
          await file.parent.create(recursive: true);
          await file.writeAsBytes(wavBytes);
          isPlaying.value = true;
          await _audioPlayer.play(DeviceFileSource(filePath));
        }
      } else {
        debugPrint("API Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("An error occurred during speak: $e");
    } finally {
      // ***** အဓိက အပြောင်းအလဲ - အလုပ်ပြီးလျှင် (သို့) error တက်လျှင် Loading State ကို ဖယ်ရှားပါ *****
      loadingAudioId.value = null;
    }
  }
  
  bool isAudioPlaying(String? uniqueId) {
    if (uniqueId == null) return false;
    return isPlaying.value && _currentlyPlayingPath?.contains('$uniqueId.wav') == true;
  }
  
  Future<void> stop() async {
    await _audioPlayer.stop();
    // Stop ကိုနှိပ်လျှင်လည်း loading indicator ကို ဖယ်ရှားပါ
    if (loadingAudioId.value != null) {
      loadingAudioId.value = null;
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    isPlaying.dispose();
    loadingAudioId.dispose(); // Notifier အသစ်ကိုပါ dispose လုပ်ပါ
  }

  static Uint8List _addWavHeader(Uint8List audioData) {
    // ... (WAV header logic remains the same)
    const int sampleRate = 24000; const int numChannels = 1; const int bitsPerSample = 16;
    final int byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8); final int blockAlign = numChannels * (bitsPerSample ~/ 8);
    final int audioDataLength = audioData.length; final int totalDataLen = audioDataLength + 36;
    final ByteData header = ByteData(44); void writeString(int offset, String value) { for (int i = 0; i < value.length; i++) { header.setUint8(offset + i, value.codeUnitAt(i)); } }
    writeString(0, 'RIFF'); header.setUint32(4, totalDataLen, Endian.little); writeString(8, 'WAVE');
    writeString(12, 'fmt '); header.setUint32(16, 16, Endian.little); header.setUint16(20, 1, Endian.little);
    header.setUint16(22, numChannels, Endian.little); header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little); header.setUint16(32, blockAlign, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little); writeString(36, 'data'); header.setUint32(40, audioDataLength, Endian.little);
    final Uint8List fullAudioData = Uint8List(44 + audioDataLength); fullAudioData.setAll(0, header.buffer.asUint8List()); fullAudioData.setAll(44, audioData);
    return fullAudioData;
  }
}