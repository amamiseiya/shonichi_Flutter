part of 'firestore.dart';

class AssetFirestoreProvider extends FirestoreProvider {
  final CollectionReference _assetRef =
      FirebaseFirestore.instance.collection('sn_asset');

  // * -------- Asset CRUD --------

  Future<List<SNAsset>> retrieveAssetsForSong(String songId) async {
    final snapshot = await _assetRef
        .where('dataId', isEqualTo: songId)
        .orderBy('name')
        .get();
    print(
        'Provider: ' + snapshot.docs.length.toString() + ' asset(s) retrieved');
    return List.generate(snapshot.docs.length,
        (i) => SNAsset.fromMap(snapshot.docs[i].data(), snapshot.docs[i].id));
  }

  Future<List<String?>> retrieveAssetForCharacters(
      List<SNCharacter> characters) async {
    return Future.wait(characters.map<Future<String?>>((character) async {
      if (character.romaji != null) {
        final snapshot =
            await _assetRef.where('dataId', isEqualTo: character.romaji!).get();
        if (snapshot.docs.length == 1) {
          return snapshot.docs.first.get('uRI') as String;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }));
  }
}
