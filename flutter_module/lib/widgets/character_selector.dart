import 'package:flutter/material.dart';

import '../models/song.dart';
import '../models/shot.dart';
import '../models/character.dart';

class CharacterSelector extends StatefulWidget {
  final SNShot editingShot;
  final Function updateShot;
  final SNSong editingSong;

  CharacterSelector(
      {required this.editingShot,
      required this.updateShot,
      required this.editingSong});

  // ! 这样使用是不对的
  @override
  CharacterSelectorState createState() =>
      CharacterSelectorState(editingShot, updateShot, editingSong);
}

class CharacterSelectorState extends State<CharacterSelector>
    with TickerProviderStateMixin {
  final SNShot editingShot;
  final Function updateShot;
  final SNSong editingSong;
  late Animation<double> animation;
  late AnimationController _animationController;
  bool chipVisible = true;
  bool selectorVisible = false;

  CharacterSelectorState(this.editingShot, this.updateShot, this.editingSong);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
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
                      children: SNCharacter.membersSortedByGrade(
                              editingSong.subordinateKikaku)
                          .map((character) {
                        return GestureDetector(
                            onTap: () {
                              if (!editingShot.characters
                                  .any((c) => c.name == character.name)) {
                                editingShot.characters.add(character);
                                updateShot(editingShot);
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
            children: <Widget>[] +
                editingShot.characters.map((character) {
                  return ActionChip(
                    backgroundColor: character.memberColor,
                    onPressed: () {
                      editingShot.characters.remove(character);
                      updateShot(editingShot);
                    },
                    label: Text(character.nameAbbr),
                  );
                }).toList(),
          )
        ]));
  }
}
