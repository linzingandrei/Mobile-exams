import 'package:frontend/model/my_entity.dart';
import 'package:frontend/repo/repo.dart';

class ExploreScreenViewModel {
  final Repo repo;

  ExploreScreenViewModel(this.repo);

  // Stream<List<MyEntity>> getAllRecipes() => repo.getAllRecipes();
  Stream<List<Map<String, dynamic>>> getRecipeAveragePerMonth() => repo.getRecipeAveragePerMonth();
}