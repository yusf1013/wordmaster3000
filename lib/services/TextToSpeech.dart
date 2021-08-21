import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech extends FlutterTts {
  TextToSpeech() : super() {
    setVolume(1);
    setSpeechRate(0.5);
    setPitch(1);
  }
}
