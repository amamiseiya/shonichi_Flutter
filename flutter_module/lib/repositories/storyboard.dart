import '../models/storyboard.dart';
import '../providers/sqlite/sqlite.dart';
import '../providers/firestore/firestore.dart';

class StoryboardRepository {
  final provider = StoryboardFirestoreProvider();

  Future<void> create(SNStoryboard storyboard) async =>
      await provider.create(storyboard);

  Future<SNStoryboard> retrieveById(String id) async =>
      await provider.retrieveById(id);

  Future<List<SNStoryboard>> retrieveForSong(
          String creatorId, String songId) async =>
      await provider.retrieveForSong(creatorId, songId);

  Future<void> update(SNStoryboard storyboard) async =>
      await provider.update(storyboard);

  Future<void> delete(String id) async => await provider.delete(id);

  Future<SNStoryboard?> getLatestStoryboard(String songId) async =>
      await provider.getLatestStoryboard(songId);
}
