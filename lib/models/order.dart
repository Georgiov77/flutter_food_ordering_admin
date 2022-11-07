import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";
  static const RESTAURANT_ID = "restaurantId";

  String? _id;
  String? _restaurantId;
  String? _description;
  String? _userId;
  String? _status;
  int? _createdAt;
  double? _total;


//  getters
  String? get id => _id;

  String? get restaurantId => _restaurantId;

  String? get description => _description;

  String? get userId => _userId;

  String? get status => _status;

  double? get total => _total;


  int? get createdAt => _createdAt;

  // public variable
  List<CartItemModel>? cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.get(ID);
    _description = snapshot.get(DESCRIPTION);
    _total = snapshot.get(TOTAL);
    _status = snapshot.get(STATUS);
    _userId = snapshot.get(USER_ID);
    _createdAt = snapshot.get(CREATED_AT);
    cart = _convertCartItems(snapshot.get(CART), _createdAt!);

  }

  List<CartItemModel> _convertCartItems(List cart, int createdAt){
    List<CartItemModel> convertedCart = [];
    for(Map cartItem in cart){
      convertedCart.add(CartItemModel.fromMap(cartItem, createdAt));
    }
    return convertedCart;
  }

}
