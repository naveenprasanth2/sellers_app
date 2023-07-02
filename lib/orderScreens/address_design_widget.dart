import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
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

  sendNotificationToUser(String userUid, String orderId) async {
    String sellerDeviceToken = "";
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["userDeviceToken"] != null) {
        sellerDeviceToken = snapshot.data()!["userDeviceToken"].toString();
      }

      notificationFormat(
          sellerDeviceToken, orderId, sharedPreferences!.getString("name"));
    });
  }

  notificationFormat(String userDeviceToken, String orderId, String? name) {
    //all these things are as per fcm documentation, don't deviate
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': fcmServerToken,
    };

    Map<String, String> bodyNotification = {
      'body':
      'Dear User, new order number (# $orderId) has been shipped by $name \n You will receive it soon',
      'title': 'Parcel Shifted'
    };

    Map dataMap = {
      'click_action': "FLUTTER_NOTIFICATION_CLICK",
      'id': '1',
      'status': 'done',
      'userOrderId': orderId
    };

    Map officialNotificationFormat = {
      'notification': bodyNotification,
      'data': dataMap,
      'priority': 'high',
      'to': userDeviceToken
    };
    //comes from http dependency
    post(
      //uri is as per documentation
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat)
    );
  }

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
                  sendNotificationToUser(orderByUser! , orderId!);
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
