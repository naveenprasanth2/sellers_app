import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/brandsScreens/brands_ui_design_widget.dart';
import 'package:sellers_app/brandsScreens/upload_brands_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/widgets/my_drawer.dart';
import 'package:sellers_app/widgets/text_delegate_header_widget.dart';

import '../models/brands.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
