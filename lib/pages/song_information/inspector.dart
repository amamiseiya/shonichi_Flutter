part of 'song_information.dart';


class LyricInspector extends StatefulWidget {
  @override
  LyricInspectorState createState() => LyricInspectorState();
}

class LyricInspectorState extends State<LyricInspector> {
  SongController songController = Get.find();
  LyricController lyricController = Get.find();

  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    // songController.retrieveSongVideo();
    initializePlayer();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    videoPlayerController =
        VideoPlayerController.network(songController.videoURI.value!);
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: false,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Obx(() {
            if (songController.editingSong != null) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('当前企划：'),
                    Text(songController.editingSong.value!.subordinateKikaku),
                  ]);
            } else {
              return Container();
            }
          }),
          (chewieController == null ||
              !chewieController.videoPlayerController.value.isInitialized)
              ? Container()
              : Column(children: [
            SizedBox(
                height: 300, child: Chewie(controller: chewieController)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  videoPlayerController.value.isPlaying
                      ? videoPlayerController.pause()
                      : videoPlayerController.play();
                });
              },
              child: Icon(
                videoPlayerController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          ]),
        ],
      ),
    );
  }
}

class _EmptyPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text('Empty Page');
  }
}

class ImportDialog extends StatelessWidget {
  final TextEditingController _lyricTextController = TextEditingController();

  @override
  Widget build(BuildContext context) => SimpleDialog(
    title: Text('批量添加lrc歌词'),
    children: <Widget>[
      Column(children: [
        Form(
            child: Column(children: [
              // TextFormField(
              //   decoration: InputDecoration(labelText: '输入歌曲编号'),
              //   onEditingComplete: (value) {
              //     songId = int.parse(value);
              //   },
              // ),
              TextFormField(
                controller: _lyricTextController,
                decoration: InputDecoration(labelText: '歌词'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onEditingComplete: () {},
              ),
            ])),
        SimpleDialogOption(
          onPressed: () => Get.back(result: _lyricTextController.text),
          child: Text('Submit'.tr),
        ),
      ])
    ],
  );
}