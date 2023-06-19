import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/itemsScreens/items_ui_design_widget.dart';
import 'package:sellers_app/itemsScreens/upload_items_screen.dart';
import 'package:sellers_app/models/brands.dart';
import 'package:sellers_app/widgets/text_delegate_header_widget.dart';

import '../global/global.dart';
import '../models/Items.dart';

class ItemsScreen extends StatefulWidget {
  final Brands? model;

  const ItemsScreen({super.key, this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("iShop"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (e) => const HomeScreen()));
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (e) => UploadItemsScreen(model: widget.model!)));
            },
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(
                title: "${widget.model?.brandTitle}'s items list"),
          ),
          StreamBuilder(
            stream: _firebaseFirestore
                .collection("sellers")
                .doc(sharedPreferences!.getString("uid"))
                .collection("brands")
                .doc(widget.model!.brandId)
                .collection("items")
                .orderBy("publishDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot dataSnapShot) {
              if (dataSnapShot.hasData) {
                //if brands exists
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Items itemsModel = Items.fromJson(
                        dataSnapShot.data.docs[index].data()
                            as Map<String, dynamic>);
                    return ItemsUiDesignWidget(
                      context: context,
                      model: itemsModel,
                    );
                  },
                  itemCount: dataSnapShot.data.docs.length,
                );
              } else {
                //if brand doesn't exists
                //as we are using slivers make sure using sliverToBoxAdapter
                return const SliverToBoxAdapter(
                    child: Center(
                  child: Text("No items exists"),
                ));
              }
            },
          )
        ],
      ),
    );
  }
}
