part of 'leancloud.dart';

class ProjectLeanCloudProvider extends LeanCloudProvider {
  // Future<void> create(SNProject project) async {
  //   LCObject p = LCObject('SNProject');
  //   project.toLCObject(p);
  //   await p.save();
  //   print('Provider: Create operation succeed');
  // }

  // Future<SNProject> retrieveById(String id) async {
  //   final LCObject p = LCObject.createWithoutData('SNProject', id);
  //   await p.fetch();
  //   print('Provider: Retrieved project: ' + p.toString());
  //   return SNProject.fromLCObject(p);
  // }

  // Future<List<SNProject>> retrieveLatestN(int amount) async {
  //   LCQuery query = LCQuery('SNProject')
  //     ..orderByDescending('createdTime')
  //     ..limit(amount);
  //   final projects = await query.find();
  //   print('Provider: ' + projects.length.toString() + ' project(s) retrieved');
  //   return List.generate(
  //       projects.length, (i) => SNProject.fromLCObject(projects[i]));
  // }

  // Future<void> update(SNProject project) async {
  //   LCObject p = LCObject.createWithoutData('SNProject', project.id);
  //   project.toLCObject(p);
  //   await p.save();
  //   print('Provider: Update operation succeed');
  // }

  // Future<void> delete(String id) async {
  //   LCObject project = LCObject.createWithoutData('SNProject', id);
  //   await project.delete();
  //   print('Provider: Delete operation succeed');
  // }

  // Future<void> deleteMultiple(List<String> ids) async {
  //   await LCObject.deleteAll(List.generate(
  //       ids.length, (i) => LCObject.createWithoutData("SNProject", ids[i])));
  //   print('Provider: Batch delete operation succeed');
  // }
}
