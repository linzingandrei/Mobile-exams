import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/screens/explore/explore_screen.dart';
import 'package:frontend/screens/home/home_screen_view_model.dart';
import 'package:frontend/screens/insights/insights_screen.dart';
import 'package:frontend/screens/main/main_screen.dart';
import 'package:frontend/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final HomeScreenViewModel viewModel = HomeScreenViewModel();
  StreamSubscription? subscription;
  int selectedTabIndex = 0;

  @override
  void initState() {
    subscription = viewModel.listenForAddedItems().listen((entity) {
      Future.delayed(const Duration(milliseconds: 300)).then((_) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("A new item has been added!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entity.title ?? "")
            ],
          ),
        )
      ));
    })
    ..onError((error) {
      Utils.displayError(context, error.toString());
    });

    super.initState();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setState(() {});
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: bottomNavBar,
    );
  }

  Widget get currentScreen {
    switch (selectedTabIndex) {
      case 0:
        return const MainScreen();
      case 1:
        return const ExploreScreen();
      case 2:
        return const InsightsScreen();
      default:
        return const MainScreen();
    }
  }

  Widget get bottomNavBar => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black12,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    unselectedItemColor: Colors.white38,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Recipes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.format_list_bulleted),
        label: 'Explore',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.format_list_bulleted),
        label: 'Insights',
      ),
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.square),
      //   label: "Insigts"
      // )
    ],
    currentIndex: selectedTabIndex,
    onTap: (index) => setState(() {
      selectedTabIndex = index;
    }),
  );

  @override
  void dispose() {
    subscription?.cancel();
    viewModel.dispose();
    super.dispose();
  }
}