import 'package:frontend/model/my_entity.dart';
import 'package:frontend/repo/repo.dart';

class AddEditViewModel {
  final Repo repo;

  AddEditViewModel(this.repo);

  Stream<String> addEntity(MyEntity entity) => repo.addEntity(entity);

  Stream<String> updateEntity(int id, String intensity) { 
    print("$intensity");
    return repo.updateIntensity(id, intensity);}
}