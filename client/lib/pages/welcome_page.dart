import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  final videoURL = "https://www.youtube.com/watch?v=kvJvHAECOvY";
  final temporaryURL =
      "https://www.youtube.com/watch?v=HZJ8CFuK3aw&t=7s&ab_channel=St.ElizabethHealthcare";

  late YoutubePlayerController _controller;

  @override
  initState() {
    super.initState();

    var videoID = YoutubePlayer.convertUrlToId(videoURL);
    var temporaryVideoId = YoutubePlayer.convertUrlToId(temporaryURL);

    // Choose the video ID to use with the controller
    String? finalVideoId = videoID ?? temporaryVideoId;

    if (finalVideoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: finalVideoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                return const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Welcome to AHS.\nPlease watch the welcome video',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () => debugPrint('Ready'),
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: Colors.amber,
                    handleColor: Colors.amberAccent,
                  ),
                ),
                const PlaybackSpeedButton(),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Speedy Recovery 👋',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
