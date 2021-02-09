part of 'leancloud.dart';

class ProjectLeanCloudProvider extends LeanCloudProvider {
  Future<void> create(SNProject project) async {
    LCObject p = LCObject('SNProject');
    project.toLCObject(p);
    await p.save();
  }

  Future<SNProject> retrieveById(String id) async {
    final LCObject p = LCObject.createWithoutData('SNProject', id);
    await p.fetch();
    return SNProject.fromLCObject(p);
  }

  Future<List<SNProject>> retrieveLatestN(int amount) async {
    LCQuery query = LCQuery('SNProject')
      ..orderByDescending('createdTime')
      ..limit(amount);
    final projects = await query.find();
    return List.generate(
        projects.length, (i) => SNProject.fromLCObject(projects[i]));
  }

  Future<void> update(SNProject project) async {
    LCObject p = LCObject.createWithoutData('SNProject', project.id);
    project.toLCObject(p);
    await p.save();
    print('Update operation succeed');
  }

  Future<void> delete(String id) async {
    LCObject project = LCObject.createWithoutData('SNProject', id);
    await project.delete();
    print('Delete operation succeed');
  }

  Future<void> deleteMultiple(List<String> ids) async {
    await LCObject.deleteAll(List.generate(
        ids.length, (i) => LCObject.createWithoutData("SNProject", ids[i])));
  }
}
