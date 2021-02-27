import 'package:get/get.dart';

import '../models/formation.dart';
import 'auth.dart';
import 'song.dart';
import 'movement.dart';
import '../repositories/formation.dart';

class FormationController extends GetxController {
  final AuthController authController = Get.find();
  final SongController songController = Get.find();
  late MovementController movementController = Get.find();

  final FormationRepository formationRepository;

  Rx<List<SNFormation>?> formationsForSong = Rx<List<SNFormation>?>(null);
  Rx<SNFormation?> editingFormation = Rx<SNFormation>(null);

  FormationController(this.formationRepository)
      : assert(formationRepository != null);

  void submitCreate(SNFormation? formation) async {
    try {
      if (formation != null) {
        formation.creatorId = authController.user.value!.uid;
        formation.songId = songController.editingSong.value!.id;
        await formationRepository.create(formation);
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  void submitUpdate(SNFormation? formation) async {
    try {
      if (formation != null) {
        await formationRepository.update(formation);
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieve() async {
    try {
      print('Retrieving formations');
      formationsForSong(await (formationRepository.retrieveForSong(
          authController.user.value!.uid,
          songController.editingSong.value!.id)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNFormation? formation) async {
    try {
      if (formation != null) {
        await movementController.deleteForFormation(formation);
        await formationRepository.delete(formation.id);
        if (formation == editingFormation.value) {
          editingFormation.nil();
        }
        retrieve();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      if (editingFormation.value == null || editingFormation.value?.id != id) {
        editingFormation(await formationRepository.retrieveById(id));
        print('editingFormation is ${editingFormation.value?.id}');
      } else if (editingFormation.value?.id == id) {
        editingFormation.nil();
        print('editingFormation is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
