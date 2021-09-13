import 'package:chewie_example/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';

import 'package:video_player/video_player.dart';

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
    this.title = 'Chewie Demo',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4');
    _videoPlayerController2 = VideoPlayerController.network(
        'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4');
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];

    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(children: [
          TextSpan(
            text: 'Hello',
            style: TextStyle(color: Colors.red, fontSize: 22),
          ),
          TextSpan(
            text: ' from ',
            style: TextStyle(color: Colors.green, fontSize: 20),
          ),
          TextSpan(
            text: 'subtitles',
            style: TextStyle(color: Colors.blue, fontSize: 18),
          )
        ]),
      ),
      Subtitle(
          index: 0,
          start: const Duration(seconds: 10),
          end: const Duration(seconds: 20),
          text: 'Whats up? :)'
          // text: const TextSpan(
          //   text: 'Whats up? :)',
          //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
          // ),
          ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,

      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),
      hotspots: hotspots,

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: AppTheme.light.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController!,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
            ),
            TextButton(
              onPressed: () {
                _chewieController?.enterFullScreen();
              },
              child: const Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerController1.pause();
                        _videoPlayerController1.seekTo(const Duration());
                        _createChewieController();
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Landscape Video"),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerController2.pause();
                        _videoPlayerController2.seekTo(const Duration());
                        _chewieController = _chewieController!.copyWith(
                          videoPlayerController: _videoPlayerController2,
                          autoPlay: true,
                          looping: true,
                          /* subtitle: Subtitles([
                            Subtitle(
                              index: 0,
                              start: Duration.zero,
                              end: const Duration(seconds: 10),
                              text: 'Hello from subtitles',
                            ),
                            Subtitle(
                              index: 0,
                              start: const Duration(seconds: 10),
                              end: const Duration(seconds: 20),
                              text: 'Whats up? :)',
                            ),
                          ]),
                          subtitleBuilder: (context, subtitle) => Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              subtitle,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ), */
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Portrait Video"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.android;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Android controls"),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.iOS;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("iOS controls"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.windows;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Desktop controls"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final List<double> hotspots = [
    34525,
    26794,
    23891,
    22115,
    20298,
    18507,
    18019,
    17467,
    18550,
    18802,
    21654,
    22842,
    20177,
    17341,
    15991,
    14373,
    14219,
    13938,
    14016,
    13900,
    15457,
    15574,
    14916,
    16896,
    19658,
    21815,
    26014,
    24361,
    22122,
    20882,
    19135,
    19240,
    20259,
    20464,
    20412,
    20587,
    24168,
    20243,
    15009,
    16463,
    19894,
    19025,
    17909,
    15402,
    12933,
    13066,
    13383,
    13172,
    13304,
    14551,
    15258,
    14851,
    15971,
    20538,
    26602,
    24331,
    23617,
    25245,
    23929,
    17443,
    18311,
    17230,
    17819,
    23786,
    23456,
    24224,
    28858,
    23626,
    22410,
    22587,
    20356,
    17893,
    17252,
    17081,
    16346,
    15591,
    15199,
    15066,
    14086,
    14254,
    16381,
    22589,
    26964,
    27834,
    29903,
    34933,
    15256,
    9796,
    8144,
    6969,
    6691,
    6625,
    6290,
    5610,
    5269,
    5272,
    5193,
    5286,
    5842,
    5923,
    6116,
    7427,
    8027,
    7379,
    7233,
    7076,
    6685,
    6818,
    5782,
    5415,
    4704,
    4771,
    5238,
    5477,
    5634,
    6274,
    6824,
    6492,
    5760,
    6430,
    6762,
    7867,
    9749,
    9290,
    6125,
    6109,
    6381,
    6167,
    6213,
    6032,
    5353,
    5360,
    4910,
    4559,
    4690,
    4779,
    4696,
    5184,
    5112,
    4870,
    4846,
    4689,
    4763,
    4850,
    4959,
    5121,
    5226,
    4777,
    4538,
    5633,
    8639,
    11770,
    15167,
    14722,
    11644,
    9847,
    8665,
    7530,
    7379,
    7151,
    6353,
    6070,
    6050,
    6003,
    6521,
    5619,
    5744,
    6673,
    7156,
    7283,
    6817,
    7315,
    8531,
    12179,
    18163,
    12887,
    6999,
    4692,
    5206,
    4093,
    3881,
    3970,
    4293,
    4541,
    4631,
    5107,
    5672,
    6401,
    7275,
    7526,
    6837,
    6344,
    6839,
    6887,
    6087,
    4397,
    4206,
    4274,
    4513,
    4595,
    4758,
    5345,
    6163,
    7093,
    8347,
    8323,
  ];
}
