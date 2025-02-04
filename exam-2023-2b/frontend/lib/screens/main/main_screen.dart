import 'package:flutter/material.dart';
import 'package:frontend/repo/repo.dart';
import 'package:frontend/screens/add/add_edit_screen.dart';
import 'package:frontend/screens/main/main_screen_view_model.dart';
import 'package:frontend/theme/app_colors.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/widgets/category_list_tile.dart';
import 'package:frontend/widgets/entity_list_tile.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState(); 
}

class MainScreenState extends State<MainScreen> {
  final MainScreenViewModel viewModel = MainScreenViewModel(Repo());
  final TextEditingController textEditingController = TextEditingController();
  String? selectedCategory;
  var logger = Logger();

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
          Text(
            selectedCategory == null || selectedCategory == ""
              ? "Category not selected!"
              : selectedCategory!,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 24),
          ),
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelStyle: const TextStyle(color: Colors.grey),
              suffix: IconButton(
                onPressed: onSave,
                icon: const Icon(
                  Icons.check,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            controller: textEditingController,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 40,
          ),
          if (selectedCategory == null || selectedCategory == "") ...[
            categoriesWidget()
          ] else ...[
              Column(
                children: [
                  Text(
                    "Items of category ${selectedCategory!}:",
                    style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  categoryItemsWidget(selectedCategory!),
                ],
              ),
            ],
            const Divider(
              color: Colors.white70,
              thickness: 2,
            ),
          ],
        
      )
    ),
  );

  Widget categoriesWidget() => StreamBuilder(
    stream: viewModel.getCategories(),
    builder: (context, snapshot) {
      return snapshot.connectionState == ConnectionState.waiting
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : ListView(
          shrinkWrap: true,
          children: snapshot.data!
            .map((e) => CategoryListTile(category: e))
            .toList()
        );
    }
  );

  Widget categoryItemsWidget(String category) => StreamBuilder(
    stream: viewModel.getActivitiesForCategory(category),
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
                onEdit: () {
                  Navigator.of(context)
                    .push(MaterialPageRoute(
                      builder: (BuildContext context) => AddEditScreen(entityToUpdate: e)))
                    .then((_) {
                      setState(() {
                        categoriesWidget();
                      });
                    });
                },
                onDelete: () {
                  viewModel.deleteActivity(e.id!).first.then((_) {
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
                categoriesWidget();
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

  VoidCallback get onSave => () {
    selectedCategory = textEditingController.text;
    setState(() {
      textEditingController.clear();
    });
  };

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}