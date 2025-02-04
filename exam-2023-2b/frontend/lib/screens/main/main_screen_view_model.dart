import 'package:frontend/model/my_entity.dart';
import 'package:frontend/repo/repo.dart';

class MainScreenViewModel {
  final Repo repo;

  MainScreenViewModel(this.repo);

  Stream<List<String?>> getCategories() => repo.getCategories();
  Stream<List<MyEntity>> getActivitiesForCategory(String category) => 
    repo.getActivitiesForCategory(category);
  Stream<String?> deleteActivity(int id) => repo.deleteEntity(id);
  Stream<String?> updateIntensity(int id, String intensity) => repo.updateIntensity(id, intensity);
}