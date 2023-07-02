import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/functions/functions.dart';
import 'package:sellers_app/global/global.dart';

class PushNotificationSystem {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Stream<RemoteMessage> firebaseMessagingListen = FirebaseMessaging.onMessage;
  Stream<RemoteMessage> firebaseMessagingOnOpen =
      FirebaseMessaging.onMessageOpenedApp;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future whenNotificationReceived(BuildContext homeScreenContext) async {
    //1. Terminated
    //when app is completely closed and opened directly from the push notifications
    firebaseMessaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      //show notification
      if (remoteMessage != null) {
        //open app and show notification data
        showNotificationWhenOpenApp(
            remoteMessage.data['userOrderId'], homeScreenContext);
      }
    });

    //2. Foreground
    //when the app is open and it receives a push notification
    firebaseMessagingListen.listen((RemoteMessage? remoteMessage) {
      //show notification
      if (remoteMessage != null) {
        //show notification data
        showNotificationWhenOpenApp(
            remoteMessage.data['userOrderId'], homeScreenContext);
      }
    });

    //3. Background
    //when app is running in background and opened directly from the push notifications
    firebaseMessagingOnOpen.listen((RemoteMessage? remoteMessage) {
      //show notification
      if (remoteMessage != null) {
        //show notification data
        showNotificationWhenOpenApp(
            remoteMessage.data['userOrderId'], homeScreenContext);
      }
    });
  }

  //generate device recognition token

  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await firebaseMessaging.getToken();

    firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .update({
      "sellerDeviceToken": registrationDeviceToken,
    });
    firebaseMessaging.subscribeToTopic("allSellers");
    firebaseMessaging.subscribeToTopic("allUsers");
  }

  showNotificationWhenOpenApp(
      String userOrderId, BuildContext homeScreenContext) async {
    await firebaseFirestore
        .collection("orders")
        .doc(userOrderId)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] == 'ended') {
        showReusableSnackBar(
            homeScreenContext,
            "Order id number: $userOrderId \n has been delivered & received by the user",
            Colors.green);
      }else {
        showReusableSnackBar(
            homeScreenContext,
            "You have a new order \n Order id number: $userOrderId \n Please ship it as soon as possible",
            Colors.green);
      }
    });
  }
}
