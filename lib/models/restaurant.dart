import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  static const ID = "id";
  static const NAME = "name";
  static const AVG_PRICE = "avgPrice";
  static const RATING = "rating";
  static const RATES = "rates";
  static const IMAGE = "image";
  static const POPULAR = "popular";
  static const USER_LIKES = "userLikes";

  String? _id;
  String? _name;
  String? _image;
  List<String>? _userLikes;
  double? _rating;
  double? _avgPrice;
  bool? _popular;
  double? _rates;

//  getters
  String? get id => _id;

  String? get name => _name;

  String? get image => _image;

  List<String>? get userLikes => _userLikes;

  double? get avgPrice => _avgPrice;

  double? get rating => _rating;

  bool? get popular => _popular;

  double? get rates => _rates;

  // public variable
  bool? liked = false;

  RestaurantModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.get(ID);
    _name = snapshot.get(NAME);
    _image = snapshot.get(IMAGE);
    _avgPrice = snapshot.get(AVG_PRICE);
    _rating = snapshot.get(RATING);
    _popular = snapshot.get(POPULAR);
    _rates = snapshot.get(RATES);
  }
}
