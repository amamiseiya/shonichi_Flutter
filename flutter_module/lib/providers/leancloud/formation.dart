part of 'leancloud.dart';

class FormationLeanCloudProvider extends LeanCloudProvider {
  Future<void> create(SNFormation formation) async {
    final LCObject f = LCObject('SNFormation');
    formation.toLCObject(f);
    await f.save();
    print('Provider: Create operation succeed');
  }

  Future<List<SNFormation>> retrieveForTable(String tableId) async {
    LCQuery<LCObject> query = LCQuery('SNFormation')
      ..whereEqualTo('tableId', tableId)
      ..orderByDescending('startTime');
    final formations = await query.find();
    print('Provider: ' +
        formations.length.toString() +
        ' formation(s) retrieved');
    return List.generate(
        formations.length, (i) => SNFormation.fromLCObject(formations[i]));
  }

  Future<void> update(SNFormation formation) async {
    LCObject f = LCObject.createWithoutData('SNFormation', formation.id);
    formation.toLCObject(f);
    await f.save();
    print('Provider: Update operation succeed');
  }

  Future<void> delete(String id) async {
    LCObject formation = LCObject.createWithoutData('SNFormation', id);
    await formation.delete();
    print('Provider: Delete operation succeed');
  }
}
