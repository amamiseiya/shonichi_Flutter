import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

import 'character.dart';

class AssetController extends GetxController {
  final CharacterController characterController = Get.find();

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final CollectionReference _assetRef =
      FirebaseFirestore.instance.collection('sn_asset');

  Future<List<Null>> updateCharacterAsset() async {
    final llMembers =
        await characterController.retrieveForKikaku(Get.context!, 'ラブライブ！');
    return Future.wait(llMembers.map((character) async {
      if (character.romaji != null) {
        final snapshot =
            await _assetRef.where('dataId', isEqualTo: character.romaji!).get();
        if (snapshot.docs.length == 1) {
          final doc = snapshot.docs.first;
          doc.reference.update({
            'uri': await getImageURI('ラブライブ！', character.romaji!, 'full_length')
          });
        }
      }
    }));
  }

  Future<String> getImageURI(String kikaku, String romaji, String size) async {
    final String _kikaku;
    switch (kikaku) {
      case 'ラブライブ！':
        _kikaku = 'lovelive';
        break;
      default:
        throw FormatException('Kikaku is not supported');
    }
    final String fileName = _kikaku +
        '/' +
        romaji.replaceAll(' ', '_').toLowerCase() +
        '_' +
        size +
        '.png';
    print(fileName);
    return storage.ref().child('images').child(fileName).getDownloadURL();
  }

  Future<String> getVideoURI(String id) async {
    return storage.ref().child('videos').child(id).getDownloadURL();
  }
}
