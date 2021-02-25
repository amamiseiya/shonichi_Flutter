import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    .map((kikaku) => FutureBuilder(
                        future: controller.retrieveForKikaku(kikaku.name,
                            orderBy: CharacterOrdering.Grade),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Card(
                                child: GridView.count(
                                    crossAxisCount: 3,
                                    children: snapshot.data
                                        .map<Widget>(
                                            (SNCharacter character) => GridTile(
                                                  child: Text(character.name),
                                                ))
                                        .toList()));
                          } else {
                            return Container();
                          }
                        }))
                    .toList()),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end, children: [])));
  }
}
