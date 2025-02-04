import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/database.dart';
import 'package:frontend/networking/rest_client.dart';
import 'package:frontend/repo/repo.dart';
import 'package:frontend/screens/home/home_screen.dart';
import 'package:frontend/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
    await $FloorAppDatabase.databaseBuilder('flutter_database_2.db').build();
  final dao = database.myEntityDao;

  Repo.entityDao = dao;
  final dio = Dio();

  Repo.client = RestClient(dio);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes app',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        scaffoldBackgroundColor: AppColors.backgroundColor,
        dialogTheme: Theme.of(context).dialogTheme.copyWith(
          backgroundColor: const Color(0xFF262626),
          titleTextStyle: const TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.bold,
            fontSize: 22),
          contentTextStyle:
            const TextStyle(color: Colors.white60, fontSize: 16),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
