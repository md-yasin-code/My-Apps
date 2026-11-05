import 'package:flutter_tts/flutter_tts.dart';

/// Device-native German speech. No audio files or network connection are used.
class SpeechService {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  final FlutterTts _tts = FlutterTts();
  bool _configured = false;
  bool _speaking = false;

  bool get isSpeaking => _speaking;

  Future<void> speakGerman(String text) async {
    final phrase = text.trim();
    if (phrase.isEmpty) return;
    if (!_configured) {
      await _tts.setLanguage('de-DE');
      await _tts.setSpeechRate(0.43);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      _configured = true;
    }
    _speaking = true;
    try {
      await _tts.stop();
      await _tts.speak(phrase);
    } finally {
      _speaking = false;
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    _speaking = false;
  }
}
