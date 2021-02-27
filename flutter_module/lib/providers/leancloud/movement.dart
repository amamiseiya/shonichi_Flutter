part of 'leancloud.dart';

class MovementLeanCloudProvider extends LeanCloudProvider {
  // Future<void> create(SNMovement movement) async {
  //   final LCObject f = LCObject('SNMovement');
  //   movement.toLCObject(f);
  //   await f.save();
  //   print('Provider: Create operation succeed');
  // }

  // Future<List<SNMovement>> retrieveForFormation(String formationId) async {
  //   LCQuery<LCObject> query = LCQuery('SNMovement')
  //     ..whereEqualTo('formationId', formationId)
  //     ..orderByDescending('startTime');
  //   final movements = await query.find();
  //   print(
  //       'Provider: ' + movements.length.toString() + ' movement(s) retrieved');
  //   return List.generate(
  //       movements.length, (i) => SNMovement.fromLCObject(movements[i]));
  // }

  // Future<void> update(SNMovement movement) async {
  //   LCObject f = LCObject.createWithoutData('SNMovement', movement.id);
  //   movement.toLCObject(f);
  //   await f.save();
  //   print('Provider: Update operation succeed');
  // }

  // Future<void> delete(String id) async {
  //   LCObject movement = LCObject.createWithoutData('SNMovement', id);
  //   await movement.delete();
  //   print('Provider: Delete operation succeed');
  // }
}
