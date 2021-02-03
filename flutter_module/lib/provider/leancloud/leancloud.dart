import 'package:leancloud_storage/leancloud.dart';

import '../../model/project.dart';

abstract class LeanCloudProvider {
  // Future<void> create();
  // Future<void> retrieve();
  // Future<void> update();
  // Future<void> delete();
}

class ProjectLeanCloudProvider extends LeanCloudProvider {
  Future<void> create(SNProject project) async {
    LCObject object = LCObject('SNProject');

    await object.save();
  }
}
