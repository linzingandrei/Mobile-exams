import 'package:flutter/material.dart';
import 'package:frontend/repo/repo.dart';
import 'package:frontend/screens/insights/insights_screen_view_model.dart';
import 'package:frontend/utils.dart';
import 'package:frontend/widgets/entity_list_tile.dart';
import 'package:frontend/widgets/insights_list_tile.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => InsightsScreenState(); 
}

class InsightsScreenState extends State<InsightsScreen> {
  final InsightsScreenViewModel viewModel = InsightsScreenViewModel(Repo());

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
          insightsWidget(),
        ],
      )
    ),
  );

  Widget insightsWidget() => StreamBuilder(
    stream: viewModel.getTop3Categories(),
    builder: (context, snapshot) {
      return snapshot.connectionState == ConnectionState.waiting
        ? const Center(
          child: CircularProgressIndicator(),
        )
        : ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!
            .map((i) => InsightsListTile(
              insight: i,
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
      // if (Repo.hasInternet)
      //   IconButton(
      //     onPressed: () => Navigator.of(context)
      //       .push(MaterialPageRoute(
      //         builder: (BuildContext context) => const AddEditScreen()))
      //       .then((_) {
      //         setState(() {
      //           recipeItemsWidget();
      //         });
      //       }),
      //       icon: const Icon(Icons.add_circle, color: Colors.black54),
      //   ),
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