import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';

import '../orderScreens/order_card.dart';

class ShiftedOrdersScreen extends StatefulWidget {
  const ShiftedOrdersScreen({super.key});

  @override
  State<ShiftedOrdersScreen> createState() => _ShiftedOrdersScreenState();
}

class _ShiftedOrdersScreenState extends State<ShiftedOrdersScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          )),
        ),
        title: const Text(
          "Shifted Orders",
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: _firebaseFirestore
            .collection("orders")
            .where("status", isEqualTo: "shifted")
            .where("sellerUid", isEqualTo: sharedPreferences!.getString("uid"))
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (_, AsyncSnapshot dataSnapshot) {
          if (dataSnapshot.hasData) {
            return ListView.builder(
                itemCount: dataSnapshot.data.docs.length,
                itemBuilder: (c, index) {
                  return FutureBuilder(
                    future: _firebaseFirestore
                        .collection("items")
                        .where("itemId",
                            whereIn: cartMethods.separateOrderItemIds(
                                (dataSnapshot.data.docs[index].data()
                                    as Map<String, dynamic>)["productIds"]))
                        .where("sellerUid",
                            whereIn: (dataSnapshot.data.docs[index].data()
                                as Map<String, dynamic>)["uid"])
                        .orderBy("publishDate", descending: true)
                        .get(),
                    builder: (c, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return OrderCard(
                          itemCount: snapshot.data.docs.length,
                          data: snapshot.data.docs,
                          orderId: dataSnapshot.data.docs[index].id,
                          quantitiesList: cartMethods.separateItemQuantities(
                              (dataSnapshot.data.docs[index].data()
                                  as Map<String, dynamic>)["productIds"]),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "No Orders Found \n Place a new order",
                            style:
                                TextStyle(color: Colors.white54, fontSize: 15),
                          ),
                        );
                      }
                    },
                  );
                });
          } else {
            return const Center(
              child: Text("No Orders Found \n Place a new order",
                  style: TextStyle(color: Colors.white54, fontSize: 15)),
            );
          }
        },
      ),
    );
  }
}
