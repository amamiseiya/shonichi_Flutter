import 'package:get/get.dart';

import '../models/formation_table.dart';
import 'song.dart';
import '../repositories/formation_table.dart';

class FormationTableController extends GetxController {
  SongController songController = Get.find();

  final FormationTableRepository formationTableRepository;

  RxList<SNFormationTable> formationTablesForSong =
      RxList<SNFormationTable>(null);
  Rx<SNFormationTable> editingFormationTable = Rx<SNFormationTable>(null);

  FormationTableController(this.formationTableRepository)
      : assert(formationTableRepository != null);

  void submitCreate(SNFormationTable formationTable) async {
    try {
      if (formationTable == null) {
        throw FormatException('Null value passed in');
      }
      await formationTableRepository.create(formationTable);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieve() async {
    try {
      print('Retrieving formationTables');
      formationTablesForSong(await (formationTableRepository
          .retrieveForSong(songController.editingSong.value.id)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNFormationTable formationTable) async {
    try {
      await formationTableRepository.delete(formationTable.id);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      if (editingFormationTable == Rx<SNFormationTable>(null) ||
          editingFormationTable.value.id != id) {
        editingFormationTable(await formationTableRepository.retrieveById(id));
        print('editingFormationTable is ${editingFormationTable.value.id}');
      } else if (editingFormationTable.value.id == id) {
        editingFormationTable(null);
        print('editingFormationTable is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
