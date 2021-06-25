part of 'song_list.dart';

class SongUpsertDialog extends StatelessWidget {
  late SNSong _s;
  SongController songController = Get.find();
  CharacterController characterController = Get.find();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _coverURIController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _lyricOffsetController = TextEditingController();

  SongUpsertDialog(SNSong? song) {
    _s = song ?? SNSong.initialValue();
    _nameController.text = _s.name;
    _coverURIController.text = _s.coverURI;
    _durationController.text = _s.duration.inMilliseconds.toString();
    _lyricOffsetController.text = _s.lyricOffset.toString();
  }

  Widget build(BuildContext context) => SimpleDialog(
        title: Builder(builder: (context) {
          if (_s.id == 'initial') {
            return Text('Create Song'.tr);
          } else {
            return Text('Update Song'.tr);
          }
        }),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Form(
                        child: Column(children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Song name'.tr),
                        onEditingComplete: () {},
                      ),
                      DropdownButton(
                        value: _s.subordinateKikaku,
                        icon: Icon(Icons.arrow_downward),
                        isExpanded: true,
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).accentColor,
                        ),
                        onChanged: (String? value) {
                          (context as Element).markNeedsBuild(); // 妙啊，实在是妙
                          _s.subordinateKikaku = value!;
                        },
                        items: [
                              DropdownMenuItem<String>(
                                value: '',
                                child: Text('(undefined)'.tr),
                              )
                            ] +
                            characterController.kikakus
                                .map<DropdownMenuItem<String>>(
                                    (SNKikaku kikaku) =>
                                        DropdownMenuItem<String>(
                                          value: kikaku.name,
                                          child: Text(
                                            kikaku.name,
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                          ),
                                        ))
                                .toList(),
                      ),
                      TextFormField(
                        controller: _coverURIController,
                        decoration: InputDecoration(labelText: 'Cover URI'.tr),
                        onEditingComplete: () {},
                      ),
                      TextFormField(
                        controller: _durationController,
                        decoration:
                            InputDecoration(labelText: 'Song duration'.tr),
                        onEditingComplete: () {},
                      ),
                      TextFormField(
                        controller: _lyricOffsetController,
                        decoration:
                            InputDecoration(labelText: 'Lyric offset'.tr),
                        onEditingComplete: () {},
                      ),
                    ])),
                    SimpleDialogOption(
                      onPressed: () {
                        songController.delete(_s); // ! song could be null
                        Get.back();
                      },
                      child: Text('Delete'.tr),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        _s.name = _nameController.text;
                        _s.coverURI = _coverURIController.text;
                        _s.duration = Duration(
                            milliseconds: int.parse(_durationController.text));
                        _s.lyricOffset = int.parse(_lyricOffsetController.text);
                        Get.back(result: _s);
                      },
                      child: Text('Submit'.tr),
                    ),
                  ]))
        ],
      );
}
