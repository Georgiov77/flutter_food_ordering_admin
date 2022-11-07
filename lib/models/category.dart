import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";

  int? _id;
  String? _name;
  String? _image;

  //  getters
  int? get id => _id;

  String? get name => _name;

  String? get image => _image;

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.get(ID);
    _name = snapshot.get(NAME);
    _image = snapshot.get(IMAGE);
  }
}
