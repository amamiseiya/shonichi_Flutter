part of 'firestore.dart';

class AssetFirestoreProvider extends FirestoreProvider {
// 弃用。目前认为，不需要单独为每个资源添加一个数据库记录，需要的时候直接从存储里读就好了。

  // final CollectionReference _assetRef =
  //     FirebaseFirestore.instance.collection('sn_asset');

  // // * -------- Asset CRUD --------

  // Future<List<SNAsset>> retrieveAssetsForSong(String songId) async {
  //   final snapshot = await _assetRef
  //       .where('dataId', isEqualTo: songId)
  //       .where('type', isEqualTo: 'SongVideo')
  //       .orderBy('name')
  //       .get();
  //   print(
  //       'Provider: ' + snapshot.docs.length.toString() + ' asset(s) retrieved');
  //   return List.generate(snapshot.docs.length,
  //       (i) => SNAsset.fromJson(snapshot.docs[i].data(), snapshot.docs[i].id));
  // }

  // Future<List<String?>> retrieveAssetForCharacters(
  //     List<SNCharacter> characters, SNAssetType type) async {
  //   return Future.wait(characters.map<Future<String?>>((character) async {
  //     if (character.romaji != null) {
  //       String typeDescription;
  //       switch (type) {
  //         case SNAssetType.CharacterFullLengthPhoto:
  //           typeDescription = 'CharacterFullLengthPhoto';
  //           break;
  //         case SNAssetType.CharacterHalfLengthPhoto:
  //           typeDescription = 'CharacterHalfLengthPhoto';
  //           break;
  //         case SNAssetType.CharacterAvatar:
  //           typeDescription = 'CharacterAvatar';
  //           break;
  //         default:
  //           throw FormatException('Invalid SNAssetType');
  //       }
  //       final snapshot = await _assetRef
  //           .where('dataId', isEqualTo: character.romaji!)
  //           .where('type', isEqualTo: typeDescription)
  //           .get();
  //       if (snapshot.docs.length == 1) {
  //         return snapshot.docs.first.get('uri') as String;
  //       } else if (snapshot.docs.isEmpty) {
  //         throw FormatException('No record fetched');
  //       } else {
  //         throw FormatException('Fetched records > 1');
  //       }
  //     } else {
  //       throw FormatException('Character doesn\'t have romaji name');
  //     }
  //   }));
  // }
}
