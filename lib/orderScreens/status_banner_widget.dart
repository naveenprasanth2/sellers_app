import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  bool? status;
  String? orderStatus;

  StatusBanner({super.key, this.status, this.orderStatus});

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successfully" : "Order Unsuccessful";

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.topRight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
          ),
          Text(
            orderStatus == "ended"
                ? "Parcel Delivered $message"
                : orderStatus == "shifted"
                    ? "Parcel shifted $message"
                    : orderStatus == "normal"
                        ? "Order Placed $message"
                        : "",
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
