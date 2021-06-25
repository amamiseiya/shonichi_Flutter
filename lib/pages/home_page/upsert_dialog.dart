part of 'home_page.dart';

class ProjectUpsertDialog extends StatelessWidget {
  late SNProject _p;

  final TextEditingController _dancerNameController = TextEditingController();
  final TextEditingController _storyboardIdController = TextEditingController();
  final TextEditingController _formationIdController = TextEditingController();

  ProjectUpsertDialog(SNProject? project) {
    _p = project ?? SNProject.initialValue();
    _dancerNameController.text = _p.dancerName;
    _storyboardIdController.text = _p.storyboardId ?? '';
    _formationIdController.text = _p.formationId ?? '';
  }

  void submit() {
    _p.dancerName = _dancerNameController.text;
    _p.storyboardId = _storyboardIdController.text;
    _p.formationId = _formationIdController.text;
    Get.back(result: _p);
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Builder(builder: (context) {
          if (_p.id == 'initial') {
            return Text('Create Project'.tr);
          } else {
            return Text('Update Project'.tr);
          }
        }),
        contentPadding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
        children: <Widget>[
          Column(children: [
            Form(
                child: Column(children: [
              ElevatedButton(
                onPressed: () => showDatePicker(
                  context: Get.context!,
                  initialDate: _p.createdTime,
                  firstDate: DateTime.now().subtract(Duration(days: 3650)),
                  lastDate: DateTime.now().add(Duration(days: 3650)),
                ).then((value) {
                  if (value != null) {
                    _p.createdTime = value;
                  }
                }),
                child: Text('Created time'.tr),
              ),
              TextFormField(
                controller: _dancerNameController,
                decoration: InputDecoration(labelText: 'Dancer name'.tr),
                onEditingComplete: () {},
              ),
              ElevatedButton(
                onPressed: () => Get.dialog(SongSelectDialog())
                    .then((value) => _p.songId = value),
                child: Text('Song ID'.tr),
              ),
              TextFormField(
                controller: _storyboardIdController,
                decoration: InputDecoration(labelText: 'Storyboard ID'.tr),
                onEditingComplete: () {},
              ),
              TextFormField(
                controller: _formationIdController,
                decoration: InputDecoration(labelText: 'Formation ID'.tr),
                onEditingComplete: () {},
              ),
            ])),
            Divider(
              color: Colors.white,
            ),
            GetBuilder<IntroController>(
                builder: (controller) => SimpleDialogOption(
                      key: controller.intro.keys[2],
                      onPressed: submit,
                      child: Text('Submit'.tr),
                    )),
          ])
        ],
      );
}
