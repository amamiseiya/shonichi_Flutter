import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/song.dart';
import '../model/shot.dart';
import '../model/character.dart';
import '../bloc/shot/shot_crud_bloc.dart';
import '../bloc/song/song_crud_bloc.dart';

class CharacterSelector extends StatefulWidget {
  final SNShot currentShot;
  final Function updateShot;
  final SNSong currentSong;

  CharacterSelector(
      {Key key,
      @required this.currentShot,
      @required this.updateShot,
      @required this.currentSong})
      : super(key: key);
  @override
  CharacterSelectorState createState() =>
      CharacterSelectorState(currentShot, updateShot, currentSong);
}

class CharacterSelectorState extends State<CharacterSelector>
    with TickerProviderStateMixin {
  SongCrudBloc songBloc;
  ShotCrudBloc shotBloc;
  final SNShot currentShot;
  final Function updateShot;
  final SNSong currentSong;
  Animation<double> animation;
  AnimationController _animationController;
  bool chipVisible = true;
  bool selectorVisible = false;

  CharacterSelectorState(this.currentShot, this.updateShot, this.currentSong);

  @override
  void initState() {
    super.initState();
    shotBloc = BlocProvider.of<ShotCrudBloc>(context);
    songBloc = BlocProvider.of<SongCrudBloc>(context);
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
                              currentSong.subordinateKikaku)
                          .map((character) {
                        return GestureDetector(
                            onTap: () {
                              if (!currentShot.characters
                                  .any((c) => c.name == character.name)) {
                                currentShot.characters.add(character);
                                updateShot(currentShot);
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
                currentShot.characters.map((character) {
                  return ActionChip(
                    backgroundColor: character.memberColor,
                    onPressed: () {
                      currentShot.characters.remove(character);
                      updateShot(currentShot);
                    },
                    label: Text(character.nameAbbr),
                  );
                }).toList(),
          )
        ]));
  }
}
