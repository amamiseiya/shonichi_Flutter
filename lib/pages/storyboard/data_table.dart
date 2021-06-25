part of 'storyboard.dart';

//分镜表类

class ShotDataTable extends StatefulWidget {
  static const double basicWidth = 80.0;
  static const Map<String, double> titles = {
    'Scene Number': 2,
    'Shot Number': 0.5,
    'Start Time': 1,
    'End Time': 1,
    'Lyric': 3,
    'Shot Type': 2,
    'Shot Move': 2,
    'Shot Angle': 2,
    'Shot Content': 4,
    'Image': 1,
    'Comment': 2,
    'Characters': 4,
    'Checkbox': 0.5
  };
  static const double totalWidth = 2000;

  @override
  State<ShotDataTable> createState() => _ShotDataTableState();
}

class _ShotDataTableState extends State<ShotDataTable> {
  final ShotController shotController = Get.find();
  final StoryboardController storyboardController = Get.find();
  late final ScrollController _scrollController;

  bool _sortAscending = true;
  late int _sortColumnIndex = 0;

  void _sort(int index, bool ascending) {
    if (ascending) {
      shotController.shots.value!.sort((a, b) {
        if (a.startTime == null || b.startTime == null) {
          return 0;
        } else {
          return a.startTime!.compareTo(b.startTime!);
        }
      });
    } else {
      shotController.shots.value!
          .sort((a, b) => b.startTime!.compareTo(a.startTime!));
    }
    _sortColumnIndex = index;
    _sortAscending = ascending;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    shotController.editingShotIndex.listen((int? index) {
      if (index != null) {
        _scrollController.animateTo(index * 50,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 24 - 56 - 56,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(children: [
              SizedBox(
                  width: ShotDataTable.totalWidth,
                  child: Material(
                      color: Colors.grey.shade50,
                      elevation: 5.0,
                      child: Row(
                        children: <Widget>[
                              _StandardBox(
                                  cellName: 'Checkbox',
                                  child: Checkbox(
                                      value: false, onChanged: (_) => null))
                            ] +
                            List<Widget>.generate(
                                ShotDataTable.titles.length - 1,
                                (i) => _StandardBox(
                                    cellName:
                                        ShotDataTable.titles.keys.elementAt(i),
                                    child: Text(ShotDataTable.titles.keys
                                        .elementAt(i)))),
                      ))),
              Expanded(
                  child: SizedBox(
                      width: ShotDataTable.totalWidth,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        itemExtent: 50,
                        itemCount: shotController.shots.value!.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _ShotItem(
                                index,
                                shotController.shots.value![index],
                                storyboardController
                                    .editingStoryboard.value!.projectSubject),
                      )))
            ])));
  }
} // ShotsDataTableState Class

class _ShotItem extends GetView<ShotController> {
  final SongController songController = Get.find();
  final int index;
  final SNShot shot;
  final ProjectSubject projectSubject;

  _ShotItem(this.index, this.shot, this.projectSubject);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Material(
          color: (index == controller.editingShotIndex.value)
              ? Colors.blue.shade50
              : Colors.grey.shade50,
          elevation: 5.0,
          child: Row(children: [
            _StandardBox(
                cellName: 'Checkbox',
                child: Checkbox(
                    value: controller.selectedShots.contains(shot),
                    onChanged: (isSelected) {
                      if (isSelected!) {
                        controller.selectedShots.add(shot);
                        // (context as Element).markNeedsBuild();
                      } else {
                        controller.selectedShots.remove(shot);
                        // (context as Element).markNeedsBuild();
                      }
                    })),
            _StandardBox(
                cellName: 'Scene Number',
                child: Builder(builder: (context) {
                  switch (projectSubject) {
                    case ProjectSubject.Odottemita:
                      return DropdownButton(
                        value: shot.sceneNumber,
                        icon: Icon(Icons.arrow_downward, size: 14),
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (int? newValue) {
                          shot.sceneNumber = newValue!;
                          controller.updateShot(shot);
                        },
                        items: List.generate(
                            shotScenes.length,
                            (i) => DropdownMenuItem<int>(
                                  value: shotScenes.keys.elementAt(i),
                                  child: Text(shotScenes.values.elementAt(i)),
                                )).toList(),
                      );
                    case ProjectSubject.Film:
                      return Text('${shot.sceneNumber}');
                  }
                })),
            _StandardBox(
                cellName: 'Shot Number', child: Text('${shot.shotNumber}')),
            _StandardBox(
                cellName: 'Start Time',
                child: Text(simpleDurationRegExp
                        .stringMatch(shot.startTime.toString()) ??
                    SNShot.initialValue('initial').endTime.toString())),
            _StandardBox(
                cellName: 'End Time',
                child: Text(
                    simpleDurationRegExp.stringMatch(shot.endTime.toString()) ??
                        SNShot.initialValue('initial').endTime.toString())),
            _StandardBox(
                cellName: 'Lyric',
                child:
                    Text(shot.lyric ?? SNShot.initialValue('initial').lyric!)),
            _StandardBox(
                cellName: 'Shot Type',
                child: DropdownButton(
                  value: shot.shotType,
                  icon: Icon(Icons.arrow_downward),
                  underline: Container(
                      height: 2, color: Theme.of(context).accentColor),
                  onChanged: (String? newValue) {
                    shot.shotType = newValue!;
                    controller.updateShot(shot);
                  },
                  items: List.generate(
                      shotTypes.length,
                      (i) => DropdownMenuItem<String>(
                            value: shotTypes.keys.elementAt(i),
                            child: Text(
                              shotTypes.values.elementAt(i),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                          )).toList(),
                )),
            _StandardBox(cellName: 'Shot Move', child: Text(shot.shotMove)),
            _StandardBox(cellName: 'Shot Angle', child: Text(shot.shotAngle)),
            _StandardBox(
                cellName: 'Shot Content',
                child: SNTextField(shot.text, (String newText) {
                  shot.text = newText;
                  controller.updateShot(shot);
                })),
            _StandardBox(
                cellName: 'Image', child: Image.network(shot.imageURI)),
            _StandardBox(
                cellName: 'Comment',
                child: SNTextField(shot.comment, (String newText) {
                  shot.comment = newText;
                  controller.updateShot(shot);
                })),
            _StandardBox(
                cellName: 'Characters',
                child: CharacterSelector(
                    editingData: shot,
                    updateData: () => controller.updateShot(shot)))
          ]));
    });
  }
}

class _StandardBox extends StatelessWidget {
  late final Widget child;
  late final String cellName;

  _StandardBox({required this.cellName, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: ShotDataTable.basicWidth * ShotDataTable.titles[cellName]!,
        height: 50.0,
        child: child);
  }
}

class SNTextField extends StatelessWidget {
  late final String editingText;
  final Function(String) updateText;

  SNTextField(this.editingText, this.updateText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: TextEditingController()..text = editingText,
        maxLines: 1,
        expands: false,
        decoration: InputDecoration(),
        // onChanged: (value) {
        //   editingText = value;
        // },
        onSubmitted: (newText) => updateText(newText),
        // showEditIcon: true,
        onTap: null);
  }
}
