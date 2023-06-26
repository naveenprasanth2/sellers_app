import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/helper/sizebox_helper.dart';

import '../models/address.dart';

class AddressDesign extends StatelessWidget {
  final Address? addressModel;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;
  final String? totalAmount;

  const AddressDesign(
      {super.key,
      this.addressModel,
      this.orderStatus,
      this.orderId,
      this.sellerId,
      this.orderByUser,
      this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Shipping Details",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              //name
              TableRow(children: [
                const Text(
                  "Name",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  addressModel!.name!,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                )
              ]),

              const TableRow(children: [
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: 4,
                ),
              ]),
              //phone Number
              TableRow(children: [
                const Text(
                  "Phone",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  addressModel!.phoneNumber!,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                )
              ]),
              const TableRow(children: [
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: 4,
                ),
              ]),
              //name
              TableRow(children: [
                const Text(
                  "Address",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  addressModel!.completeAddress!,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                )
              ]),
            ],
          ),
        ),
        SizedBoxHelper.sizeBox40,
        GestureDetector(
          onTap: () {
            if (orderStatus == "ended") {
              Navigator.pop(context);
            } else if (orderStatus == "shifted") {
              Navigator.pop(context);
            } else if (orderStatus == "normal") {
              firebaseFirestore
                  .collection("sellers")
                  .doc(sharedPreferences!.getString("uid"))
                  .update({
                "earnings": (double.parse(previousEarnings) +
                        double.parse(totalAmount!))
                    .toString(),
              }).whenComplete(() {
                firebaseFirestore.collection("orders").doc(orderId).update({
                  "status": "shifted",
                }).whenComplete(() {
                  firebaseFirestore
                      .collection("users")
                      .doc(orderByUser)
                      .collection("orders")
                      .doc(orderId)
                      .update({"status": "shifted"});
                }).whenComplete(() {
                  //todo notification to the user
                  Fluttertoast.showToast(msg: "Order status updated successfully");
                  Navigator.pop(context);
                });
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight)),
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height * .10,
              child: Center(
                child: Text(
                  orderStatus == "ended"
                      ? "Go Back"
                      : orderStatus == "shifted"
                          ? "Go Back"
                          : orderStatus == "normal"
                              ? "Confirm Shipment"
                              : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
