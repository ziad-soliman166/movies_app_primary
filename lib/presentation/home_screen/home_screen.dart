import 'package:flutter/material.dart';
import 'package:movies/presentation/home_screen/widgets/tabs/browse_tab/browse_tab.dart';
import 'package:movies/presentation/home_screen/widgets/tabs/home_tab/home_tab.dart';
import 'package:movies/presentation/home_screen/widgets/tabs/search_tab/search_tab.dart';

import '../../core/assets_manager.dart';
import 'widgets/tabs/watchList_tab/watchList_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<dynamic> watchlistMovies = [];

  late List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      HomeTab(watchlistMovies: watchlistMovies),
      SearchTab(),
      BrowseTab(),
      WatchlistTab(watchlistMovies: watchlistMovies),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AssetsManager.homeIcon)),
              label: "Home"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AssetsManager.searchIcon)),
              label: "Search"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AssetsManager.browseIcon)),
              label: "Browse"),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AssetsManager.watchListIcon)),
              label: "WatchList"),
        ],
      ),
      body: tabs[selectedIndex],
    );
  }
}
