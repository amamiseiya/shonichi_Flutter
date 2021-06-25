import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/formation.dart';
import 'auth.dart';
import 'project.dart';
import 'song.dart';
import 'move.dart';
import '../repositories/formation.dart';

class FormationController extends GetxController {
  late final AuthController authController = Get.find();
  late final ProjectController projectController = Get.find();
  late final SongController songController = Get.find();
  late final MoveController moveController = Get.find();

  final FormationRepository formationRepository;

  Rxn<List<SNFormation>> formationsForSong = Rxn<List<SNFormation>>(null);
  Rxn<SNFormation> editingFormation = Rxn<SNFormation>(null);

  FormationController(this.formationRepository)
      : assert(formationRepository != null);

  Future<SNFormation> submitCreate(SNFormation? formation) async {
    try {
      if (formation != null) {
        formation.creatorId = authController.user.value!.uid;
        formation.songId = songController.editingSong.value!.id;
        final DocumentReference docRef =
            await formationRepository.create(formation);
        await retrieve();
        await select(docRef.id);
        return docRef
            .get()
            .then((value) => SNFormation.fromJson(value.data(), value.id));
      } else {
        throw FormatException('Formation is null');
      }
    } catch (e) {
      print(e);
    }
    throw Exception();
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
        await moveController.deleteForFormation(formation);
        await formationRepository.delete(formation.id);
        if (formation == editingFormation.value) {
          editingFormation();
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
        final newFormation = await formationRepository.retrieveById(id);
        editingFormation(newFormation);
        projectController.editingProject.value!.formationId = id;
        projectController.submitUpdate(projectController.editingProject.value!);
        print('editingFormation is ${editingFormation.value?.id}');
      } else if (editingFormation.value?.id == id) {
        editingFormation();
        print('editingFormation is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
