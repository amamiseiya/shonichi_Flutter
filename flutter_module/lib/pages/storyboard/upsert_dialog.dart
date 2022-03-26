part of 'storyboard.dart';


class _StoryboardUpsertDialog extends GetView<StoryboardController> {
  // 在dialog最终pop时才给对象赋值，不确定这样的方式是否合适
  late SNStoryboard _s;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  _StoryboardUpsertDialog(SNStoryboard? storyboard) {
    _s = storyboard ?? SNStoryboard.initialValue();
    _nameController.text = _s.name;
    _descriptionController.text = _s.description;
  }

  Widget build(BuildContext context) => SimpleDialog(
    title: Builder(builder: (context) {
      if (_s.id == 'initial') {
        return Text('Create Storyboard'.tr);
      } else {
        return Text('Update Storyboard'.tr);
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
                    InputDecoration(labelText: 'Input storyboard name'),
                    onEditingComplete: () {},
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Input storyboard description'),
                    onEditingComplete: () {},
                  ),
                ])),
            SimpleDialogOption(
              onPressed: () {
                controller.delete(_s); // ! storyboard could be null
                Get.back();
              },
              child: Text('Delete'.tr),
            ),
            SimpleDialogOption(
              onPressed: () {
                _s.name = _nameController.text;
                _s.description = _descriptionController.text;
                Get.back(result: _s);
              },
              child: Text('Submit'.tr),
            ),
          ]))
    ],
  );
}