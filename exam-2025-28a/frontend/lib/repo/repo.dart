import 'package:collection/collection.dart';
import 'package:frontend/dao/my_entity_dao.dart';
import 'package:frontend/model/my_entity.dart';
import 'package:frontend/networking/rest_client.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class Repo {
  static bool useLocal = false;
  static bool hasInternet = true;
  static late final Logger logger;

  static late final MyEntityDao entityDao;
  static late final RestClient client;

  Future<bool> backup() {
    print("Backup called...");
    return client.getRecipes().asStream().flatMap((entities2) {
      for (var entity in entities2) {
        print("AICI1 ${entity.toJson()}");
      }

      return entityDao.findAllEntities().asStream().asyncMap((entities) async {
        await entityDao.deleteAllEntities();

        for(var entity in entities2) {
          entityDao.insertMyEntity(entity);
        }
        return true;
      });
    }).first;
  }

  Stream<List<MyEntity>> getRecipes() {
    if (useLocal) {
      return entityDao
        .findAllEntities()
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return backup()
      .then((_) {
        print("AICI: ${client.getRecipes()}");
        return client.getRecipes();
      })
      .asStream()
      .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
  }

  Stream<List<MyEntity>> getAllRecipes() {
    if (useLocal) {
      return entityDao
        .findAllEntities()
        .asStream()
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return client
      .getAllRecipes()
      .asStream()
      .onErrorResume((error, stackTrace) => Stream.error(error.toString())); 
  }

  Stream<List<Map<String, dynamic>>> getTop3Categories() {
    if (useLocal) {
      return entityDao
        .findAllEntities()
        .asStream()
        .map((entities) {
          var grouped = groupBy(entities, (MyEntity e) => e.category);
          print(grouped);

          var categoryAverages = grouped.entries
            .map((entry) => {
              "category": entry.key,
              "averageRating": entry.value.map((e) => e.rating).reduce((a, b) => a! + b!)! / entry.value.length
            })
            .toList();
          
          print(categoryAverages);

          categoryAverages.sort((a, b) => (b["averageRating"] as double).compareTo(a["averageRating"] as double));

          return categoryAverages.take(3).toList();
        });
    }
    return client
      .getAllRecipes()
      .asStream()
      .map((entities) {
        var grouped = groupBy(entities, (MyEntity e) => e.category);
        print(grouped);

        var categoryAverages = grouped.entries.map((entry) {
          List<double?> ratings = entry.value.map((e) => e.rating).toList();

          double avgRating = ratings.isNotEmpty
              ? ratings.reduce((a, b) => a! + b!)! / ratings.length
              : 0.0;

          return {
            "category": entry.key,
            "averageRating": avgRating,
          };
        }).toList();
        print(categoryAverages);

        categoryAverages.sort((a, b) => (b["averageRating"] as double).compareTo(a["averageRating"] as double));

        return categoryAverages.take(3).toList();
      });
  }

  Stream<List<Map<String, dynamic>>> getRecipeAveragePerMonth() {
    if (useLocal) {
      return entityDao
        .findAllEntities()
        .asStream()
        .map((recipes) {
          var grouped = groupBy(recipes, (MyEntity e) {
            DateTime date = DateTime.parse(e.date!);
            return '${date.year}-${date.month.toString().padLeft(2, '0')}';
          });

          var monthlyAverages = grouped.entries.map((entry) {
            List<double?> ratings = entry.value.map((e) => e.rating).toList();

            double avgRating = ratings.isNotEmpty
              ? ratings.reduce((a, b) => a! + b!)! / ratings.length
              : 0.0;

            var yearMonth = entry.key.split('-');
            String year = yearMonth[0];
            String month = yearMonth[1];

            return {
              "year": year,
              "month": month,
              "averageRating": avgRating
            };
          }).toList();

          monthlyAverages.sort((a, b) {
            return (b["year"] as String).compareTo(a["year"] as String) == 0
              ? (b["month"] as String).compareTo(a["month"] as String)
              : (b["year"] as String).compareTo(a["year"] as String);
          });

          return monthlyAverages;
        });
    }
    return client 
      .getAllRecipes()
      .asStream()
      .map((recipes) {
        var grouped = groupBy(recipes, (MyEntity e) {
          DateTime date = DateTime.parse(e.date!);
          return '${date.year}-${date.month.toString().padLeft(2, '0')}';
        });

        var monthlyAverages = grouped.entries.map((entry) {
          List<double?> ratings = entry.value.map((e) => e.rating).toList();

          double avgRating = ratings.isNotEmpty
            ? ratings.reduce((a, b) => a! + b!)! / ratings.length
            : 0.0;

          var yearMonth = entry.key.split('-');
          String year = yearMonth[0];
          String month = yearMonth[1];

          return {
            "year": year,
            "month": month,
            "averageRating": avgRating
          };
        }).toList();

        monthlyAverages.sort((a, b) {
          return (b["year"] as String).compareTo(a["year"] as String) == 0
            ? (b["month"] as String).compareTo(a["month"] as String)
            : (b["year"] as String).compareTo(a["year"] as String);
        });

        return monthlyAverages;
      });
  } 

  Stream<String> addEntity(MyEntity entity) {
    if (hasInternet) {
      return client
        .postEntity(entity)
        .asStream()
        .flatMap((_) => Stream.value("ok"))
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }

  Stream<String> deleteEntity(int id) {
    if (hasInternet) {
      return client
        .deleteEntityById(id)
        .asStream()
        .flatMap((_) => Stream.value("ok"))
        .onErrorResume((error, stackTrace) => Stream.error(error.toString()));
    }
    return Stream.error("No internet connection");
  }

  // Stream<String> updateEntity(int id)
}