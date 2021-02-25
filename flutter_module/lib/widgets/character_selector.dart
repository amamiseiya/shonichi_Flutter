import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/character.dart';
import '../models/song.dart';
import '../models/shot.dart';
import '../models/character.dart';

class CharacterSelector extends StatefulWidget {
  final SNShot editingShot;
  final Function updateShot;

  CharacterSelector({required this.editingShot, required this.updateShot});

  // ! 向createState()里传参是不对的，又是一个小细节
  @override
  CharacterSelectorState createState() => CharacterSelectorState();
}

class CharacterSelectorState extends State<CharacterSelector>
    with TickerProviderStateMixin {
  final CharacterController characterController = Get.find();

  late Animation<double> animation;
  late AnimationController _animationController;
  bool chipVisible = true;
  bool selectorVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animationController.addListener(() {
      setState() {}
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SizedOverflowBox(
        size: Size(200, 90),
        child: Row(children: [
          Stack(children: [
            //!
            Visibility(
                visible: chipVisible,
                child: Container(
                    width: 90,
                    height: 90,
                    child: Center(
                        child: GestureDetector(
                      onTapDown: (details) {
                        print('onTapDown');
                        setState(() {
                          chipVisible = false;
                          selectorVisible = true;
                        });
                      },
                      // onTapCancel: () {
                      //   print('onTapCancel');
                      //   setState(() {
                      //     chipVisible = true;
                      //     selectorVisible = false;
                      //   });
                      // },
                      child: Chip(
                        label: Icon(Icons.add),
                      ),
                    )))),
            Visibility(
                visible: selectorVisible,
                child: Container(
                    width: 90,
                    height: 90,
                    child: Wrap(
                      children: characterController.editingCharacters.value!
                          .map((character) {
                        return GestureDetector(
                            onTap: () {
                              if (!widget.editingShot.characters
                                  .any((c) => c.name == character.name)) {
                                widget.editingShot.characters.add(character);
                                widget.updateShot(widget.editingShot);
                              }
                              setState(() {
                                chipVisible = true;
                                selectorVisible = false;
                              });
                            },
                            child: CircleAvatar(
                              radius: 15,
                              child: Text(character.nameAbbr),
                            ));
                      }).toList(),
                    ))),
          ]),
          Wrap(
            children: widget.editingShot.characters.map<Widget>((character) {
              return ActionChip(
                backgroundColor: character.memberColor,
                onPressed: () {
                  widget.editingShot.characters.remove(character);
                  widget.updateShot(widget.editingShot);
                },
                label: Text(character.nameAbbr),
              );
            }).toList(),
          )
        ]));
  }
}
