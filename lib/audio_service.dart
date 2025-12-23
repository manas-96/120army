import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  String? _fullPath;

  /// Loads the asset path and saves it
  Future<void> load(String fullPath) async {
    if (fullPath.startsWith('assets/')) {
      fullPath = fullPath.replaceFirst('assets/', '');
    }
    _fullPath = fullPath;
  }

  /// Always play from the beginning
  Future<void> play() async {
    if (_fullPath == null) return;
    await _player.play(AssetSource(_fullPath!));
  }

  void dispose() {
    _player.dispose();
  }
}
