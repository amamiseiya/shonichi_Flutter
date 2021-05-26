import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/storyboard.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class StoryboardRepository {
  final provider = StoryboardFirestoreProvider();

  Future<DocumentReference> create(SNStoryboard storyboard) =>
      provider.create(storyboard);

  Future<SNStoryboard> retrieveById(String id) => provider.retrieveById(id);

  Future<List<SNStoryboard>> retrieveForSong(String creatorId, String songId) =>
      provider.retrieveForSong(creatorId, songId);

  Future<void> update(SNStoryboard storyboard) => provider.update(storyboard);

  Future<void> delete(String id) => provider.delete(id);

  Future<SNStoryboard?> getLatestStoryboard(String songId) =>
      provider.getLatestStoryboard(songId);
}
