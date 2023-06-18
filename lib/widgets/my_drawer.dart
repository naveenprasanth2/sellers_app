import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/helper/sizebox_helper.dart';
import 'package:sellers_app/splashScreen/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [
          //header
          Container(
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                //user profile image
                SizedBox(
                  height: 160,
                  width: 160,
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(sharedPreferences!.getString("photoUrl")!),
                  ),
                ),
                SizedBoxHelper.sizeBox12,
                Text(
                  sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBoxHelper.sizeBox12,
          const Divider(
            height: 10,
            color: Colors.grey,
            thickness: 2,
          ),

          //body
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Container(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  //home
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Home",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),

                  //my_orders
                  ListTile(
                    leading: const Icon(
                      Icons.reorder,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "My Orders",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),

                  //not yet received orders button
                  ListTile(
                    leading: const Icon(
                      Icons.picture_in_picture_alt_rounded,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Not yet received orders",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  //history
                  ListTile(
                    leading: const Icon(
                      Icons.access_time,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "History",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  //search button
                  ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Search",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  //logout
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      color: Colors.grey,
                    ),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const SplashScreen()));
                    },
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.grey,
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
