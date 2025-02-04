import 'package:frontend/model/my_entity.dart';
import 'package:frontend/repo/repo.dart';

class MainScreenViewModel {
  final Repo repo;

  MainScreenViewModel(this.repo);

  Stream<List<MyEntity>> getRecipes() => repo.getRecipes();
  Stream<String?> deleteRecipe(int id) => repo.deleteEntity(id);
}