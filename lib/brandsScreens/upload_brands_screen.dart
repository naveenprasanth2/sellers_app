import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/brandsScreens/home_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/widgets/progress_bar.dart';

class UploadBrandsScreen extends StatefulWidget {
  const UploadBrandsScreen({super.key});

  @override
  State<UploadBrandsScreen> createState() => _UploadBrandsScreenState();
}

class _UploadBrandsScreenState extends State<UploadBrandsScreen> {
  TextEditingController brandInfoTextEditingController =
      TextEditingController();
  TextEditingController brandTitleTextEditingController =
      TextEditingController();
  XFile? _imgXFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool uploading = false;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String? downloadUrlImage;
  String brandUniqueID = DateTime.now().millisecondsSinceEpoch.toString();

  saveBrandInfo() {
    _firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(brandUniqueID)
        .set({
      "brandId": brandUniqueID,
      "sellerUid": sharedPreferences!.getString("uid"),
      "brandInfo": brandInfoTextEditingController.text.trim(),
      "brandTitle": brandTitleTextEditingController.text.trim(),
      "publishDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrlImage
    });
    setState(() {
      uploading = false;
      //make sure to update this unique id as its initialized once in class level only
      //so below line gives new id
      brandUniqueID = DateTime.now().millisecondsSinceEpoch.toString();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(
          context, MaterialPageRoute(builder: (e) => const HomeScreen()));
    });
  }

  validateUploadForm() async {
    if (_imgXFile != null) {
      if (brandInfoTextEditingController.text.isNotEmpty &&
          brandTitleTextEditingController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        //upload a new image to firebase storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            _firebaseStorage.ref().child("sellersBrandsImages").child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(_imgXFile!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((urlImage) {
          downloadUrlImage = urlImage;
        });

        //save brand info to firebase database
        saveBrandInfo();
      } else {
        Fluttertoast.showToast(msg: "Please enter all brand details");
      }
    } else {
      Fluttertoast.showToast(msg: "Please upload a brand image please");
    }
  }

  uploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (e) => const HomeScreen()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              onPressed: () {
                uploading == true ? null : validateUploadForm();
              },
              icon: const Icon(Icons.cloud_upload),
            ),
          )
        ],
        title: const Text("Upload New Brand"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          )),
        ),
      ),
      body: ListView(
        children: [
          //this gives linear progress bar to upload
          uploading == true ? linearProgressBar() : Container(),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: FileImage(
                      File(_imgXFile!.path),
                    ),
                  )),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.pinkAccent,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: brandInfoTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Brand Info",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.pinkAccent,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: brandTitleTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Brand Title",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.pinkAccent,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _imgXFile == null ? defaultScreen() : uploadFormScreen();
  }

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Brand"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          )),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.topRight),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.white,
                size: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  obtainImageFromDialogBox();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text("Add New Brand"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  obtainImageFromDialogBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Brand Image",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  getImageFromCamera();
                },
                child: const Text(
                  "Capture with Camera",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getImageFromGallery();
                  getImageFromGallery();
                },
                child: const Text(
                  "Upload from Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        });
  }

  void getImageFromGallery() async {
    _imgXFile = await _imagePicker
        .pickImage(
      source: ImageSource.gallery,
    )
        .then((value) {
      Navigator.pop(context);
      return value;
    });
    setState(() {
      _imgXFile;
    });
  }

  void getImageFromCamera() async {
    _imgXFile =
        await _imagePicker.pickImage(source: ImageSource.camera).then((value) {
      Navigator.pop(context);
      return value;
    });
    setState(() {
      _imgXFile;
    });
  }
}
