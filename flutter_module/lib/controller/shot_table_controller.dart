import 'package:get/get.dart';

import '../model/shot_table.dart';
import 'project_controller.dart';

class ShotTableController extends GetxController {
  RxList<SNShotTable> shotTablesForSong = RxList<SNShotTable>(null);
  Rx<SNShotTable> editingShotTable = Rx<SNShotTable>(null);

  void retrieve() {}
}
