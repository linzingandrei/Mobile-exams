import 'package:flutter/material.dart';
import 'package:frontend/repo/repo.dart';
import 'package:frontend/screens/add/add_edit_screen.dart';
import 'package:frontend/screens/main/main_screen_view_model.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/widgets/entity_list_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState(); 
}

class MainScreenState extends State<MainScreen> {
  final MainScreenViewModel viewModel = MainScreenViewModel(Repo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: screen,
    );
  }

  Widget get screen => SingleChildScrollView(
    child: Utils.checkInternetScreenWrapper(
      onRetry: () => setState(() {}),
      onUseLocal: () => setState(() {
        Repo.useLocal = true;
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          recipeItemsWidget(),
        ],
      )
    ),
  );

  Widget recipeItemsWidget() => StreamBuilder(
    stream: viewModel.getRecipes(),
    builder: (context, snapshot) {
      return snapshot.connectionState == ConnectionState.waiting
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!
            .map((e) => EntityListTile(
              entity: e,
              onDelete: () {
                viewModel.deleteRecipe(e.id!).first.then((_) {
                  Utils.displayMessage(
                    context,
                    "Success on delete"
                  );
                  setState(() {});
                }).onError((error, stackTrace) {
                  Utils.displayError(
                    context,
                    "Error on delete"
                  );
                  setState(() {});
                });
              },
            ))
            .toList(),
        );
    }
  );

  AppBar get appBar => AppBar(
    title: const Text(
      "Main",
      style: TextStyle(fontSize: 30, color: Colors.black54),
    ),
    actions: [
      if (Repo.hasInternet)
        IconButton(
          onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (BuildContext context) => const AddEditScreen()))
            .then((_) {
              setState(() {
                recipeItemsWidget();
              });
            }),
            icon: const Icon(Icons.add_circle, color: Colors.black54),
        ),
      if (Repo.useLocal)
        IconButton(
          onPressed: () => setState(() {
            Repo.useLocal = false;
          }),
          icon: const Icon(Icons.cloud, color: Colors.black54),
        )
    ],
  );
}