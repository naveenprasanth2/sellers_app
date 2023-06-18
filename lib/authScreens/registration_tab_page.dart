import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/widgets/loading_dialog.dart';

import '../helper/sizebox_helper.dart';
import '../widgets/custom_text_field.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class RegistrationTabPage extends StatefulWidget {
  const RegistrationTabPage({super.key});

  @override
  State<RegistrationTabPage> createState() => _RegistrationTabPageState();
}

class _RegistrationTabPageState extends State<RegistrationTabPage> {
  TextEditingController nameTextEditingController =
      TextEditingController(text: "summa");
  TextEditingController emailTextEditingController =
      TextEditingController(text: "pelexom486@aaorsi.com");
  TextEditingController passwordTextEditingController =
      TextEditingController(text: "test1234");
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController(text: "test1234");
  TextEditingController phoneTextEditingController =
      TextEditingController(text: "9999999999");
  TextEditingController locationTextEditingController =
      TextEditingController(text: "paris");
  GlobalKey<FormState> formKey = GlobalKey();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String downloadUrlImage = "";

  XFile? _imgXFile;
  final ImagePicker _imagePicker = ImagePicker();

  void getImageFromGallery() async {
    _imgXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imgXFile;
    });
  }

  formValidation() async {
    //image validation
    if (_imgXFile == null) {
      Fluttertoast.showToast(msg: "Please select an image.");
    } else {
      //image already selected
      if (passwordTextEditingController.text ==
          confirmPasswordTextEditingController.text) {
        if (passwordTextEditingController.text.isNotEmpty &&
            confirmPasswordTextEditingController.text.isNotEmpty &&
            nameTextEditingController.text.isNotEmpty &&
            emailTextEditingController.text.isNotEmpty &&
            phoneTextEditingController.text.isNotEmpty &&
            locationTextEditingController.text.isNotEmpty) {
          // to show circular progress indicator we need show dialog
          showDialog(
              context: context,
              builder: (c) => const LoadingDialogWidget(
                  message: "Registering your account"));
          //1. upload image to the database
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference storageRef =
              _firebaseStorage.ref().child("sellersImages").child("fileName");
          UploadTask uploadImageTask =
              storageRef.putFile(File(_imgXFile!.path));

          TaskSnapshot taskSnapshot = await uploadImageTask.whenComplete(() {});
          taskSnapshot.ref.getDownloadURL().then((urlImage) {
            downloadUrlImage = urlImage;
          });
          //2. authenticate the user and send to home page
          saveInformationToDatabase();
        } else {
          Fluttertoast.showToast(msg: "Please fill all the necessary fields");
        }
      } else {
        Fluttertoast.showToast(msg: "Passwords doesn't match");
      }
    }
  }

  saveInformationToDatabase() async {
    User? currentUser;
    await _firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text)
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred \n $errorMessage");
    });
    if (currentUser != null) {
      saveInfoToFirestoreAndLocally(currentUser);
    }
  }

  void saveInfoToFirestoreAndLocally(User? currentUser) async {
    _firebaseFirestore.collection("sellers").doc(currentUser!.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameTextEditingController.text.trim(),
      "photoUrl": downloadUrlImage,
      "status": "approved",
      "phone": phoneTextEditingController.text,
      "address": locationTextEditingController.text.trim(),
      "earnings": 0.0
    });

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!.setString("name", nameTextEditingController.text);
    await sharedPreferences!.setString("photoUrl", downloadUrlImage);
    await sharedPreferences!.setString("status", "approved");
    await sharedPreferences!
        .setString("phone", phoneTextEditingController.text);
    await sharedPreferences!
        .setString("location", locationTextEditingController.text);
    await sharedPreferences!.setDouble("earnings", 0.0).then((value) =>
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBoxHelper.sizeBox12,
          //get image for profile
          GestureDetector(
            onTap: () {
              getImageFromGallery();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundImage: _imgXFile == null
                  ? null
                  : FileImage(
                      File(_imgXFile!.path),
                    ),
              child: _imgXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      color: Colors.grey,
                      size: MediaQuery.of(context).size.width * 0.20,
                    )
                  : null,
            ),
          ),
          SizedBoxHelper.sizeBox12,
          //inputs fields

          //username
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                    textEditingController: nameTextEditingController,
                    iconData: Icons.person,
                    hintText: "User Name"),
                CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintText: "Email"),
                CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    isObscure: true,
                    hintText: "Password"),
                CustomTextField(
                    textEditingController: confirmPasswordTextEditingController,
                    iconData: Icons.lock,
                    isObscure: true,
                    hintText: "Confirm Password"),
                CustomTextField(
                    textEditingController: phoneTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Phone Number"),
                InkWell(
                  onTap: () {},
                  child: CustomTextField(
                    textEditingController: locationTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Location",
                    isEnabled: true,
                  ),
                ),
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
              formValidation();
            },
            child: const Text(
              "Sign Up",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBoxHelper.sizeBox30,
        ],
      ),
    );
  }
}
