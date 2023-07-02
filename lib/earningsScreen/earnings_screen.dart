import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/helper/sizebox_helper.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  double earnings = 0.0;

  readTotalEarnings() async {
    await firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      setState(() {
        earnings = double.parse(snap.data()!["earnings"]);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    readTotalEarnings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₹ $earnings",
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Total Earnings",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),
              SizedBoxHelper.sizeBox40,
              Card(
                color: Colors.pinkAccent,
                margin: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 100,
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Go Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
