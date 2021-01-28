import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/song.dart';
import '../model/shot.dart';
import '../model/character.dart';
import '../bloc/shot/shot_crud_bloc.dart';
import '../bloc/song/song_crud_bloc.dart';

class CharacterSelector extends StatefulWidget {
  final SNShot editingShot;
  final Function updateShot;
  final SNSong editingSong;

  CharacterSelector(
      {Key key,
      @required this.editingShot,
      @required this.updateShot,
      @required this.editingSong})
      : super(key: key);

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
  Animation<double> animation;
  AnimationController _animationController;
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
    return OverflowBox(
        maxWidth: 200,
        maxHeight: 90,
        child: Row(children: [
          // child: GestureDetector(
          // onTapDown: (details) {
          //   print('onPanDown');
          //   setState(() {
          //     chipVisible = false;
          //     selectorVisible = true;
          //   });
          // },
          // onTapCancel: () {
          //   print('onPanDown');
          //   setState(() {
          //     chipVisible = true;
          //     selectorVisible = false;
          //   });
          // },
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
                      onTapCancel: () {
                        print('onTapCancel');
                        setState(() {
                          chipVisible = true;
                          selectorVisible = false;
                        });
                      },
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
