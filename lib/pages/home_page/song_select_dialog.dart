part of 'home_page.dart';

class SongSelectDialog extends GetView<SongController> {
  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: Text('Select song'.tr),
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 3 * 2,
              height: MediaQuery.of(context).size.height / 3 * 2,
              child: GetX<SongController>(
                  initState: (_) => controller.retrieveAll(),
                  builder: (_) {
                    if (controller.songs.value == null) {
                      return LoadingAnimationLinear();
                    }
                    if (controller.songs.value!.isEmpty) {
                      return _EmptySongPage();
                    }
                    return ListView.builder(
                      itemCount: controller.songs.value!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(controller.songs.value![index].name),
                          subtitle: Text(
                              controller.songs.value![index].subordinateKikaku,
                              overflow: TextOverflow.fade,
                              softWrap: false),
                          onTap: () =>
                              Get.back(result: controller.songs.value![index].id),
                        );
                      },
                    );
                  }))
        ],
      );
}

class _EmptySongPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Text('Empty Page');
  }
}
