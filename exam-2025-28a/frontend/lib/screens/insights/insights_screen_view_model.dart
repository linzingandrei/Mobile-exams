import 'package:frontend/model/my_entity.dart';
import 'package:frontend/repo/repo.dart';

class InsightsScreenViewModel {
  final Repo repo;

  InsightsScreenViewModel(this.repo);

  // Stream<List<MyEntity>> getAllRecipes() => repo.getAllRecipes();
  Stream<List<Map<String, dynamic>>> getTop3Categories() => repo.getTop3Categories();
}