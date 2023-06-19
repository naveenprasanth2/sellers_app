import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/itemsScreens/items_screen.dart';
import 'package:sellers_app/splashScreen/splash_screen.dart';

import '../global/global.dart';
import '../models/Items.dart';
import '../models/brands.dart';

class ItemDetailsScreen extends StatefulWidget {
  Items? model;

  ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  deleteItem() {
    _firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(widget.model!.brandId)
        .collection("items")
        .doc(widget.model!.itemId)
        .delete()
        .then((value) {
      _firebaseFirestore
          .collection("items")
          .doc(widget.model!.itemId)
          .delete()
          .then((value) {
        Fluttertoast.showToast(
            msg: "the item ${widget.model!.itemTitle} is deleted successfully");
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (e) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model!.itemTitle.toString()),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          deleteItem();
        },
        label: const Text("Delete this item"),
        icon: const Icon(Icons.delete_sweep),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.model!.thumbnailUrl.toString()),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 8.0,
            ),
            child: Text(
              widget.model!.itemTitle.toString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.pinkAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${widget.model!.price} ₹",
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.pink),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, right: 330),
            child: Divider(
              height: 1,
              thickness: 2,
              color: Colors.pinkAccent,
            ),
          )
        ],
      ),
    );
  }
}
