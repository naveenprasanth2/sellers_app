import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/helper/sizebox_helper.dart';
import 'package:sellers_app/splashScreen/splash_screen.dart';
import 'package:sellers_app/widgets/custom_text_field.dart';
import 'package:sellers_app/global/global.dart';

import '../widgets/loading_dialog.dart';

class LoginTabPage extends StatefulWidget {
  const LoginTabPage({super.key});

  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController =
      TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? _currentUser;

  validateForm() async {
    showDialog(
        context: context,
        builder: (c) =>
            const LoadingDialogWidget(message: "Registering your account"));
    if (emailTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty) {
      await _firebaseAuth
          .signInWithEmailAndPassword(
              email: emailTextEditingController.text,
              password: passwordTextEditingController.text)
          .then((value) {
        _currentUser = value.user;
      }).catchError((errorMessage) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error occurred: \n $errorMessage");
      });
    }
    if (_currentUser != null) {
      checkIfUserRecordExists();
    }
  }

  checkIfUserRecordExists() async {
    await _firebaseFirestore
        .collection("sellers")
        .doc(_currentUser!.uid)
        .get()
        .then((record) async {
      //check record exists, then check status is approved
      if (record.exists) {
        if (record.data()!["status"] == "approved") {
          //send user to home screen
          await sharedPreferences!.setString("uid", record.data()!["uid"]);
          await sharedPreferences!.setString("email", record.data()!["email"]);
          await sharedPreferences!.setString("name", record.data()!["name"]);
          await sharedPreferences!
              .setString("photoUrl", record.data()!["photoUrl"]);
          await sharedPreferences!
              .setString("status", record.data()!["status"]);
          await sharedPreferences!.setString("phone", record.data()!["phone"]);
          await sharedPreferences!
              .setString("address", record.data()!["address"]);
          //todo   //I have made the changes here for double ( string to double )
          await sharedPreferences!
              .setDouble("earnings", record.data()!["earnings"])
              .then((value) => Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const SplashScreen())));
        } else {
          //status not approved
          Navigator.pop(context);
          _firebaseAuth.signOut();
          Fluttertoast.showToast(
              msg:
                  "You have been blocked by admin,\n please contact customer care");
        }
      } else {
        _firebaseAuth.signOut();
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "This seller doesn't exists");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBoxHelper.sizeBox12,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/seller.png",
              height: MediaQuery.of(context).size.height * 0.40,
            ),
          ),
          //inputs fields
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintText: "Email"),
                CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    isObscure: true,
                    hintText: "Password"),
                SizedBoxHelper.sizeBox20,
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () {
              validateForm();
            },
            child: const Text(
              "Sign In",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
