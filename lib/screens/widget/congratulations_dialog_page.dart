import '../../audio_service.dart';
import '../../exports.dart';
import 'package:http/http.dart' as http;

import '../../global.dart';
import 'cached_image.dart';
import 'custom_elevated_button.dart';

class CongratulationsPopup extends StatefulWidget {
  final String logoImgUrl;
  final String message;
  final String sharedText;

  const CongratulationsPopup({
    super.key,
    required this.logoImgUrl,
    required this.message,
    required this.sharedText,
  });

  @override
  State<CongratulationsPopup> createState() => _CongratulationsPopupState();
}

class _CongratulationsPopupState extends State<CongratulationsPopup> {
  late AudioService _audioService;
  late ConfettiController _confettiController;
  bool _animopacity = false;
  XFile? _downloadedImage;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _audioService = AudioService();
    _audioService.load('assets/images/success.mp3');

    _downloadImage(widget.logoImgUrl); // Download image in advance

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
      _audioService.play();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _animopacity = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = await _writeToFile(response.bodyBytes);
        _downloadedImage = XFile(file.path, mimeType: 'image/jpeg');
      } else {
        print("Failed to download image.");
      }
    } catch (e) {
      print("Error pre-downloading image: $e");
    }
  }

  Future<File> _writeToFile(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/image.jpg');
    await file.writeAsBytes(data);
    return file;
  }

  Future<void> _shareImageAndText(String text) async {
    if (_downloadedImage == null) {
      print("Image not yet downloaded.");
      return;
    }
    try {
      await SharePlus.instance.share(
        ShareParams(text: text, files: [_downloadedImage!]),
      );
    } catch (e) {
      print("Error sharing: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AlertDialog(
          title: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _animopacity ? 1 : 0,
                        duration: const Duration(seconds: 1),
                        child: SizedBox(
                          width: 80,
                          child: MyImageWidget(imageUrl: widget.logoImgUrl),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -30,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _animopacity ? 0 : 1,
                        duration: const Duration(seconds: 1),
                        child: Lottie.asset(
                          'assets/images/congratulations.json',
                          width: 145,
                          repeat: false,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(15),
              const Text(
                'Congratulations!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: mediumheading, color: kPrimaryColor),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(widget.message, textAlign: TextAlign.center),
                const Gap(15),
                CustomButton(
                  text: "Share",
                  onPressed: () {
                    _shareImageAndText(widget.sharedText);
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: ConfettiWidget(
            numberOfParticles: 50,
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
      ],
    );
  }
}
