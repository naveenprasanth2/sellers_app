import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/brandsScreens/brands_ui_design_widget.dart';
import 'package:sellers_app/brandsScreens/upload_brands_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/push_notifications/push_notifications_system.dart';
import 'package:sellers_app/widgets/my_drawer.dart';
import 'package:sellers_app/widgets/text_delegate_header_widget.dart';

import '../functions/functions.dart';
import '../models/brands.dart';
import '../splashScreen/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  getSellerEarningsFromDatabase() {
    _firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((dataSnapshot) {
      previousEarnings = dataSnapshot.data()!["earnings"].toString();
    }).whenComplete(() => getSellerEarningsFromDatabase());
  }

  restrictBlockedSellersFromUsingSellersApp() async {
    await _firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        showReusableSnackBar(
            context, "You are blocked \n Please contact admin", Colors.red);
        FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (e) => const SplashScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.generateDeviceRecognitionToken();
    //context is sent from the home screen
    pushNotificationSystem.whenNotificationReceived(context);
    restrictBlockedSellersFromUsingSellersApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.pinkAccent,
                    Colors.purpleAccent,
                  ]),
            ),
          ),
          title: const Text(
            "iShop",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (e) => const UploadBrandsScreen()));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverPersistentHeader(
              pinned: true,
              delegate: TextDelegateHeaderWidget(title: "My Brands"),
            ),
            StreamBuilder(
              stream: _firebaseFirestore
                  .collection("sellers")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("brands")
                  .orderBy("publishDate", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot dataSnapShot) {
                if (dataSnapShot.hasData) {
                  //if brands exists
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Brands brandsModel = Brands.fromJson(
                          dataSnapShot.data.docs[index].data()
                              as Map<String, dynamic>);
                      return BrandsUiDesignWidget(
                        context: context,
                        model: brandsModel,
                      );
                    },
                    itemCount: dataSnapShot.data.docs.length,
                  );
                } else {
                  //if brand doesn't exists
                  //as we are using slivers make sure using sliverToBoxAdapter
                  return const SliverToBoxAdapter(
                      child: Center(
                    child: Text("No brands exists"),
                  ));
                }
              },
            )
          ],
        ));
  }
}
