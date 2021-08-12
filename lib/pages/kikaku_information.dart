import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shonichi/models/asset.dart';

import '../controllers/character.dart';
import '../models/character.dart';
import '../widgets/drawer.dart';
import '../widgets/loading.dart';

class KikakuInformationPage extends GetView<CharacterController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: controller.kikakus.length,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Information about Kikakus'.tr),
              bottom: TabBar(
                // 显示多个Tab，按企划分组
                tabs: controller.kikakus
                    .map((kikaku) => Text(
                          kikaku.name,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ))
                    .toList(),
              ),
            ),
            drawer: MyDrawer(),
            body: TabBarView(
                children: controller.kikakus
                    .map((kikaku) => Card(
                        child: FutureBuilder(
                            // 先获取单个企划的角色列表
                            future: controller
                                .retrieveForKikaku(context, kikaku.name,
                                    orderBy: CharacterOrdering.Grade)
                                // 然后为所有角色获取图片
                                .then((characters) => controller.fetchImages(
                                    kikaku.nameEng,
                                    characters,
                                    SNAssetType.CharacterFullLengthPhoto)),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        GridTile(
                                          child: Column(children: [
                                            ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxHeight: 100),
                                                child: (snapshot.data.values
                                                            .elementAt(index) !=
                                                        null)
                                                    //! 无用的判断
                                                    ? Image.asset(snapshot
                                                        .data.values
                                                        .elementAt(index)!)
                                                    : Container()),
                                            Text(snapshot.data.keys
                                                .elementAt(index)
                                                .name)
                                          ]),
                                        ));
                              } else {
                                return Container();
                              }
                            })))
                    .toList()),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end, children: [])));
  }
}
