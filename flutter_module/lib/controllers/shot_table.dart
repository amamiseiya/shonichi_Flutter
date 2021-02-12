import 'package:get/get.dart';

import '../models/shot_table.dart';
import 'song.dart';
import '../repositories/shot_table.dart';

class ShotTableController extends GetxController {
  SongController songController = Get.find();

  final ShotTableRepository shotTableRepository;

  RxList<SNShotTable> shotTablesForSong = RxList<SNShotTable>(null);
  Rx<SNShotTable> editingShotTable = Rx<SNShotTable>(null);

  ShotTableController(this.shotTableRepository)
      : assert(shotTableRepository != null);

  void submitCreate(SNShotTable shotTable) async {
    try {
      if (shotTable == null) {
        throw FormatException('Null value passed in');
      }
      shotTable.authorId = '1';
      shotTable.songId = songController.editingSong.value.id;
      await shotTableRepository.create(shotTable);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieve() async {
    try {
      print('Retrieving shotTables');
      shotTablesForSong(await (shotTableRepository
          .retrieveForSong(songController.editingSong.value.id)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(SNShotTable shotTable) async {
    try {
      await shotTableRepository.delete(shotTable.id);
      retrieve();
    } catch (e) {
      print(e);
    }
  }

  Future<void> select(String id) async {
    try {
      if (editingShotTable == Rx<SNShotTable>(null) ||
          editingShotTable.value.id != id) {
        editingShotTable(await shotTableRepository.retrieveById(id));
        print('editingShotTable is ${editingShotTable.value.id}');
      } else if (editingShotTable.value.id == id) {
        editingShotTable(null);
        print('editingShotTable is null');
      }
    } catch (e) {
      print(e);
    }
  }
}
