import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/itemsScreens/items_screen.dart';
import 'package:sellers_app/models/brands.dart';
import 'package:sellers_app/widgets/progress_bar.dart';

import '../brandsScreens/home_screen.dart';

class UploadItemsScreen extends StatefulWidget {
  final Brands model;

  const UploadItemsScreen({super.key, required this.model});

  @override
  State<UploadItemsScreen> createState() => _UploadItemsScreenState();
}

class _UploadItemsScreenState extends State<UploadItemsScreen> {
  TextEditingController itemInfoTextEditingController = TextEditingController();
  TextEditingController itemTitleTextEditingController =
      TextEditingController();
  TextEditingController itemPriceTextEditingController =
      TextEditingController();
  TextEditingController itemDescriptionTextEditingController =
      TextEditingController();
  XFile? _imgXFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool uploading = false;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String? downloadUrlImage;
  String itemUniqueID = DateTime.now().millisecondsSinceEpoch.toString();

  saveItemInfo() {
    _firebaseFirestore
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("brands")
        .doc(widget.model.brandId)
        .collection("items")
        .doc(itemUniqueID)
        .set({
      "itemId": itemUniqueID,
      "brandId": widget.model.brandId.toString(),
      "sellerUid": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "itemInfo": itemInfoTextEditingController.text.trim(),
      "itemTitle": itemTitleTextEditingController.text.trim(),
      "longDescription": itemDescriptionTextEditingController.text.trim(),
      "price": itemPriceTextEditingController.text.trim(),
      "publishDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrlImage
    }).then((value) {
      _firebaseFirestore.collection("items").doc(itemUniqueID).set({
        "itemId": itemUniqueID,
        "brandId": widget.model.brandId.toString(),
        "sellerUid": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "itemInfo": itemInfoTextEditingController.text.trim(),
        "itemTitle": itemTitleTextEditingController.text.trim(),
        "longDescription": itemDescriptionTextEditingController.text.trim(),
        "price": itemPriceTextEditingController.text.trim(),
        "publishDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrlImage
      });
    });
    setState(() {
      uploading = false;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (e) => ItemsScreen(
                    model: widget.model,
                  )));
    });
  }

  validateUploadForm() async {
    if (_imgXFile != null) {
      if (itemInfoTextEditingController.text.isNotEmpty &&
          itemTitleTextEditingController.text.isNotEmpty &&
          itemDescriptionTextEditingController.text.isNotEmpty &&
          itemPriceTextEditingController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        //upload a new image to firebase storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            _firebaseStorage.ref().child("sellersItemsImages").child(fileName);
        UploadTask uploadTask = storageRef.putFile(File(_imgXFile!.path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((urlImage) {
          downloadUrlImage = urlImage;
        });

        //save item info to firebase database
        saveItemInfo();
      } else {
        Fluttertoast.showToast(msg: "Please enter all item details");
      }
    } else {
      Fluttertoast.showToast(msg: "Please upload a item image please");
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
        title: const Text("Upload New Item"),
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
                controller: itemInfoTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Item Info",
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
                controller: itemTitleTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Item Title",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.pinkAccent,
            thickness: 1,
          ),
          //item description
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: itemDescriptionTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Item Description",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.pinkAccent,
            thickness: 1,
          ),
          //item price
          ListTile(
            leading: const Icon(
              Icons.currency_rupee,
              color: Colors.deepPurple,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                controller: itemPriceTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Item Price",
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
        title: const Text("Add New Item"),
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
                Icons.add_photo_alternate,
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
                child: const Text("Add New Item"),
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
              "item Image",
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
