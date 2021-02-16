import 'package:get/get.dart';

import '../models/formation.dart';
import 'song.dart';
import '../repositories/formation.dart';

class FormationController extends GetxController {
  SongController songController = Get.find();

  final FormationRepository formationRepository;

  RxList<SNFormation> formationsForSong = RxList<SNFormation>(null);
  Rx<SNFormation> editingFormation = Rx<SNFormation>(null);

  FormationController(this.formationRepository)
      : assert(formationRepository != null);

  void submitCreate(SNFormation formation) async {
    try {
      if (formation == null) {
        throw FormatException('Null value passed in');
      }
      await formationRepository.create(formation);
      formation.authorId = '1';
      formation.songId = songController.editingSong.value.id;
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieve() async {
    try {
      print('Retrieving formations');
      formationsForSong(await (formationRepository
          .retrieveForSong(songController.editingSong.value.id)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNFormation formation) async {
    try {
      await formationRepository.delete(formation.id);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      if (editingFormation == Rx<SNFormation>(null) ||
          editingFormation.value.id != id) {
        editingFormation(await formationRepository.retrieveById(id));
        print('editingFormation is ${editingFormation.value.id}');
      } else if (editingFormation.value.id == id) {
        editingFormation.nil();
        print('editingFormation is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
