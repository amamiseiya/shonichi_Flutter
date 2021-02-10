import 'package:get/get.dart';

import '../models/shot_table.dart';
import 'project.dart';

class ShotTableController extends GetxController {
  RxList<SNShotTable> shotTablesForSong = RxList<SNShotTable>(null);
  Rx<SNShotTable> editingShotTable = Rx<SNShotTable>(null);

  void retrieve() {}
}
