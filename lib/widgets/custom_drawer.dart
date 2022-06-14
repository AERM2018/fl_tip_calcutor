import 'package:flutter/material.dart';
import 'package:tip_calc/screens/screens.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Text('Hello Angel',
                style: TextStyle(fontSize: 35, color: Colors.white),
                textAlign: TextAlign.center),
          ),
          ListTile(
            title: const Text("New tip"),
            leading: const Icon(Icons.monetization_on_outlined),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TipScreen())),
          ),
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsScreen())),
          )
        ],
      ),
    );
  }
}
