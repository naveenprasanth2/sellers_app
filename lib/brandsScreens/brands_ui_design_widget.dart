import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/itemsScreens/items_screen.dart';
import 'package:sellers_app/splashScreen/splash_screen.dart';

import '../global/global.dart';
import '../models/brands.dart';

class BrandsUiDesignWidget extends StatefulWidget {
  Brands? model;
  BuildContext? context;

  BrandsUiDesignWidget({
    super.key,
    required this.model,
    this.context,
  });

  @override
  State<BrandsUiDesignWidget> createState() => _BrandsUiDesignWidgetState();
}

class _BrandsUiDesignWidgetState extends State<BrandsUiDesignWidget> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  deleteBrand() {
    _firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(widget.model!.brandId)
        .delete();
    Navigator.push(
        context, MaterialPageRoute(builder: (e) => const SplashScreen()));
    Fluttertoast.showToast(msg: "Brand deleted.");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (e) => ItemsScreen(
                      model: widget.model,
                    )));
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Image.network(
                  widget.model!.thumbnailUrl.toString(),
                  height: 220,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.model!.brandTitle.toString(),
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 3,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          deleteBrand();
                        },
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: Colors.pinkAccent,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
