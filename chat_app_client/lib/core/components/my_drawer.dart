import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_uid');
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xffFFFFFF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    'assets/images/logokg.png', // Path to your image
                    height: 80, // Adjust the size as needed
                    width: 80,
                    fit: BoxFit.contain, // Keeps the image proportional
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Home"),
                      leading: const Icon(Icons.home),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/users');
                      },
                    ),
                    // ListTile(
                    //   title: const Text("Blocked Users"),
                    //   leading: const Icon(Icons.person),
                    //   onTap: () {
                    //     Navigator.pushNamed(context, '/blocked');
                    //   },
                    // ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 32),
            child: ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
