import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:foodorderingappadmin/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../helpers/product.dart';

class ProductProvider with ChangeNotifier {
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsByCategory = [];
  List<ProductModel> productsSearched = [];
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();

  bool featured = false;
  File? productImage;
  final picker = ImagePicker();
  String? productImageFileName;

  ProductProvider.initialize() {
    loadProducts();
    notifyListeners();
  }

  loadProducts() async {
    products = await _productServices.getProducts();
    notifyListeners();
  }

  Future loadProductsByCategory({String? categoryName}) async {
    productsByCategory =
        await _productServices.getProductsOfCategory(category: categoryName);
    notifyListeners();
  }

  Future<bool> uploadProduct(
      {String? category, String? restaurant, String? restaurantId}) async {
    try {
      String id = Uuid().v1();
      String imageUrl =
          await _uploadImageFile(imageFile: productImage, imageFileName: id);
      Map data = {
        "id": id,
        "category": category,
        "name": name.text.trim(),
        "image": imageUrl,
        "rates": 1.5,
        "rating": 4.5,
        "price": double.parse(price.text.trim()),
        "restaurant": restaurant,
        "restaurantId": restaurantId,
        "description": description.text.trim(),
        "featured": featured
      };
      _productServices.createProduct(data: data);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  changeFeatured() {
    featured = !featured;
    notifyListeners();
  }

//  method to load image files
  getImageFile({ImageSource? source}) async {
    final pickedFile =
        await picker.getImage(source: source!, maxWidth: 640, maxHeight: 400);
    productImage = File(pickedFile!.path);
    productImageFileName =
        productImage!.path.substring(productImage!.path.indexOf('/') + 1);
    notifyListeners();
  }

//  method to upload the file to firebase
  Future _uploadImageFile({File? imageFile, String? imageFileName}) async {
    Reference reference = FirebaseStorage.instance.ref().child(imageFileName!);
    UploadTask uploadTask = reference.putFile(imageFile!);
    String imageUrl =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    return imageUrl;
  }

  Future search({String? productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");
    print("THE NUMBER OF PRODUCTS DETECTED IS: ${productsSearched.length}");

    notifyListeners();
  }

  clear() {}
}
