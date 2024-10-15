import 'package:flutter/material.dart';
import 'package:foodverse_frontend/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? GoToSavedFoods;
  final Function()? GoToAddedFoods;
  final Function()? GoToFilterFoods;
  final Function()? GoToHomePage;
  final Function()? GoToGptPage;
  final Function()? LogOut;
  final Function()? Search;

  const MyDrawer(
      {super.key,
      required this.GoToSavedFoods,
      required this.GoToAddedFoods,
      required this.GoToFilterFoods,
      required this.GoToHomePage,
      required this.LogOut,
      required this.GoToGptPage,
      required this.Search});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal,
      child: Column(
        children: [
          //header
          const DrawerHeader(
              child: Icon(Icons.person, color: Colors.white, size: 64)),
          //filtered food
          MyListTile(icon: Icons.home, text: 'H O M E', onTap: GoToHomePage),
          //addded food
          MyListTile(icon: Icons.add, text: 'A D D', onTap: GoToAddedFoods),
          //saved food
          MyListTile(
              icon: Icons.star, text: 'S A V E D', onTap: GoToSavedFoods),
          MyListTile(
              icon: Icons.filter, text: 'F I L T E R', onTap: GoToFilterFoods),
          //settings
          MyListTile(
              icon: Icons.settings,
              text: ' A S K  T O  G P T',
              onTap: GoToGptPage),
          //logout
          MyListTile(
              icon: Icons.exit_to_app, text: 'L O G O U T', onTap: LogOut),
          //fallows
          MyListTile(icon: Icons.search, text: 'S E A R C H', onTap: Search),
          //messages
        ],
      ),
    );
  }
}