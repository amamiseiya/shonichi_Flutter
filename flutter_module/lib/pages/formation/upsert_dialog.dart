part of 'formation.dart';

class _FormationUpsertDialog extends GetView<FormationController> {
  // 在dialog最终pop时才给对象赋值，不确定这样的方式是否合适

  late SNFormation _f;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  _FormationUpsertDialog(SNFormation? formation) {
    _f = formation ?? SNFormation.initialValue();
    _nameController.text = _f.name;
    _descriptionController.text = _f.description;
  }

  Widget build(BuildContext context) => SimpleDialog(
    title: Builder(builder: (context) {
      if (_f.id == 'initial') {
        return Text('Create Formation'.tr);
      } else {
        return Text('Update Formation'.tr);
      }
    }),
    children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(children: [
            Form(
                child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration:
                    InputDecoration(labelText: 'Input formation name'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Input formation description'),
                    onEditingComplete: () {},
                  ),
                ])),
            SimpleDialogOption(
              onPressed: () {
                controller.delete(_f); // ! formation could be null
                Get.back();
              },
              child: Text('Delete'.tr),
            ),
            SimpleDialogOption(
              onPressed: () {
                _f.name = _nameController.text;
                _f.description = _descriptionController.text;
                Get.back(result: _f);
              },
              child: Text('Submit'.tr),
            ),
          ]))
    ],
  );
}