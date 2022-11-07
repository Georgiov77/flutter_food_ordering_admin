import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const RATING = "rating";
  static const IMAGE = "image";
  static const PRICE = "price";
  static const RESTAURANT_ID = "restaurantId";
  static const RESTAURANT = "restaurant";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const RATES = "rates";
  static const USER_LIKES = "userLikes";

  String? _id;
  String? _name;
  String? _restaurantId;
  String? _restaurant;
  String? _category;
  String? _image;
  String? _description;

  double? _rating;
  double? _price;
  double? _rates;

  bool? _featured;

  String? get id => _id;

  String? get name => _name;

  String? get restaurant => _restaurant;

  String? get restaurantId => _restaurantId;

  String? get category => _category;

  String? get description => _description;

  String? get image => _image;

  double? get rating => _rating;

  double? get price => _price;

  bool? get featured => _featured;

  double? get rates => _rates;

  // public variable
  bool liked = false;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.get(ID);
    _image = snapshot.get(IMAGE);
    _restaurant = snapshot.get(RESTAURANT);
    _restaurantId = snapshot.get(RESTAURANT_ID);
    _description = snapshot.get(DESCRIPTION);
    _featured = snapshot.get(FEATURED);
    _price = snapshot.get(PRICE);
    _category = snapshot.get(CATEGORY);
    _rating = snapshot.get(RATING);
    _rates = snapshot.get(RATES);
    _name = snapshot.get(NAME);
  }
}
