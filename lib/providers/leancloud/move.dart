part of 'leancloud.dart';

class MoveLeanCloudProvider extends LeanCloudProvider {
  // Future<void> create(SNMove move) async {
  //   final LCObject f = LCObject('SNMove');
  //   move.toLCObject(f);
  //   await f.save();
  //   print('Provider: Create operation succeed');
  // }

  // Future<List<SNMove>> retrieveForFormation(String formationId) async {
  //   LCQuery<LCObject> query = LCQuery('SNMove')
  //     ..whereEqualTo('formationId', formationId)
  //     ..orderByDescending('startTime');
  //   final moves = await query.find();
  //   print(
  //       'Provider: ' + moves.length.toString() + ' move(s) retrieved');
  //   return List.generate(
  //       moves.length, (i) => SNMove.fromLCObject(moves[i]));
  // }

  // Future<void> update(SNMove move) async {
  //   LCObject f = LCObject.createWithoutData('SNMove', move.id);
  //   move.toLCObject(f);
  //   await f.save();
  //   print('Provider: Update operation succeed');
  // }

  // Future<void> delete(String id) async {
  //   LCObject move = LCObject.createWithoutData('SNMove', id);
  //   await move.delete();
  //   print('Provider: Delete operation succeed');
  // }
}
