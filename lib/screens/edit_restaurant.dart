import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingappadmin/helpers/restaurant.dart';
import 'package:foodorderingappadmin/helpers/style.dart';
import 'package:foodorderingappadmin/widgets/custom_file_button.dart';
import 'package:foodorderingappadmin/widgets/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class EditRestaurant extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();
  final myController = TextEditingController();
  final rating = TextEditingController();
  final avgPrice = TextEditingController();
  final picker = ImagePicker();
  String? productImageFileName;
  File? productImage;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    //  method to load image files
    getImageFile({ImageSource? source}) async {
      final pickedFile =
          await picker.getImage(source: source!, maxWidth: 640, maxHeight: 400);
      productImage = File(pickedFile!.path);
      productImageFileName =
          productImage!.path.substring(productImage!.path.indexOf('/') + 1);
    }

//  method to upload the file to firebase
    Future _uploadImageFile({File? imageFile, String? imageFileName}) async {
      Reference reference =
          FirebaseStorage.instance.ref().child(imageFileName!);
      UploadTask uploadTask = reference.putFile(imageFile!);
      String imageUrl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      return imageUrl;
    }

    updateRestaurant({String? name, double? rating, double? avgprice}) async {
      String id = Uuid().v1();
      String imageUrl =
          await _uploadImageFile(imageFile: productImage, imageFileName: id);
      await FirebaseFirestore.instance
          .collection("restaurants")
          .doc(user!.uid)
          .update({
        "name": name,
        "rating": rating,
        "avgPrice": avgprice,
        "image": imageUrl,
      });
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: white,
          title: Text(
            "Επεξεργασία Στοιχείων \n Εστιατορίου",
            style: TextStyle(color: black),
          )),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    child: CustomFileUploadButton(
                  icon: Icons.image,
                  text: "Προσθήκη Φωτογραφίας",
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            child: new Wrap(
                              children: <Widget>[
                                new ListTile(
                                    leading: new Icon(Icons.image),
                                    title: new Text('From gallery'),
                                    onTap: () async {
                                      getImageFile(source: ImageSource.gallery);
                                      Navigator.pop(context);
                                    }),
                                new ListTile(
                                    leading: new Icon(Icons.camera_alt),
                                    title: new Text('Take a photo'),
                                    onTap: () async {
                                      getImageFile(source: ImageSource.camera);
                                      Navigator.pop(context);
                                    }),
                              ],
                            ),
                          );
                        });
                  },
                )),
              ],
            ),
          ),
          Visibility(
            child: FlatButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        child: new Wrap(
                          children: <Widget>[
                            new ListTile(
                                leading: new Icon(Icons.image),
                                title: new Text('From gallery'),
                                onTap: () async {
                                  getImageFile(source: ImageSource.gallery);
                                  Navigator.pop(context);
                                }),
                            new ListTile(
                                leading: new Icon(Icons.camera_alt),
                                title: new Text('Take a photo'),
                                onTap: () async {
                                  getImageFile(source: ImageSource.camera);
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      );
                    });
              },
              child: CustomText(
                text: "Αλλαγή Φωτογραφίας",
                color: primary,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: black, width: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.5),
                        offset: Offset(2, 7),
                        blurRadius: 7)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: TextField(
                  controller: myController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Όνομα Εστιατορίου",
                      hintStyle: TextStyle(
                          color: grey, fontFamily: "Sen", fontSize: 18)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: black, width: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.5),
                        offset: Offset(2, 7),
                        blurRadius: 7)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: TextField(
                  controller: avgPrice,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Μέση Τιμή Γεύματος",
                      hintStyle: TextStyle(
                          color: grey, fontFamily: "Sen", fontSize: 18)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: black, width: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withOpacity(0.5),
                        offset: Offset(2, 7),
                        blurRadius: 7)
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: TextField(
                  controller: rating,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Rating",
                      hintStyle: TextStyle(
                          color: grey, fontFamily: "Sen", fontSize: 18)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Container(
                decoration: BoxDecoration(
                    color: primary,
                    border: Border.all(color: black, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.3),
                          offset: Offset(2, 7),
                          blurRadius: 4)
                    ]),
                child: FlatButton(
                  onPressed: () async {
                    updateRestaurant(
                      name: myController.text,
                      rating: double.parse(rating.text),
                      avgprice: double.parse(avgPrice.text),
                    );
                    _key.currentState!.showSnackBar(SnackBar(
                      content: Text("Upload completed"),
                      duration: const Duration(seconds: 10),
                    ));
                  },
                  child: CustomText(
                    text: "Δημοσίευση",
                    color: white,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
