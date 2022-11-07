import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingappadmin/helpers/screen_navigation.dart';
import 'package:foodorderingappadmin/helpers/style.dart';
import 'package:foodorderingappadmin/models/order.dart';
import 'package:foodorderingappadmin/providers/product.dart';
import 'package:foodorderingappadmin/providers/user.dart';
import 'package:foodorderingappadmin/widgets/custom_text.dart';
import 'package:foodorderingappadmin/widgets/product.dart';
import 'package:foodorderingappadmin/widgets/small_floating_button.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'add_products_screen.dart';
import 'edit_restaurant.dart';
import 'login.dart';
import 'order2.dart';
import 'orders.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    bool hasImage = false;
    List orders = [];

    getOrders() async {
      await FirebaseFirestore.instance
          .collection("orders")
          .where("restaurantIds", arrayContains: userProvider.user!.uid)
          .snapshots()
          .forEach((element) {
        orders.add(element);
      });
      return orders;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        elevation: 0.5,
        backgroundColor: primary,
        title: CustomText(
          text: "Πωλήσεις: €",
          color: white,
        ),
        actions: <Widget>[],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: primary),
              accountName: CustomText(
                text: userProvider.restaurant?.name ?? "",
                color: white,
                weight: FontWeight.bold,
                size: 18,
              ),
              accountEmail: CustomText(
                text: userProvider.user!.email ?? "",
                color: white,
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.home),
              title: CustomText(text: "Αρχική"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.restaurant),
              title: CustomText(text: "Το Εστιατόριό Μου"),
            ),
            ListTile(
              onTap: () {
                changeScreen(context, OrdersScreen2());
              },
              leading: Icon(Icons.bookmark_border),
              title: CustomText(text: "Οι Παραγγελίες"),
            ),
            ListTile(
              onTap: () {
                changeScreen(context, AddProductScreen());
              },
              leading: Icon(Icons.fastfood),
              title: CustomText(text: "Προσθήκη Προϊόντων"),
            ),
            ListTile(
              onTap: () {
                userProvider.signOut();
                changeScreenReplacement(context, LoginScreen());
              },
              leading: Icon(Icons.exit_to_app),
              title: CustomText(text: "Αποσύνδεση"),
            ),
          ],
        ),
      ),
      backgroundColor: white,
      body: SafeArea(
          child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
//                  Positioned.fill(
//                      child: Align(
//                        alignment: Alignment.center,
//                        child: Loading(),
//                      )),

              // restaurant image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
                child: Image.network(
                  userProvider.restaurant!.image!,
                  fit: BoxFit.fill,
                ),
              ),

              // fading black
              Container(
                height: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(2),
                      bottomRight: Radius.circular(2),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.025),
                      ],
                    )),
              ),

              //restaurant name
              Positioned.fill(
                  bottom: 30,
                  left: 10,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomText(
                        text: userProvider.restaurant!.name,
                        color: white,
                        size: 24,
                        weight: FontWeight.normal,
                      ))),

              // average price
              Positioned.fill(
                  bottom: 10,
                  left: 10,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomText(
                        text:
                            "Μέση Τιμή Γεύματος:  ${userProvider.restaurant!.avgPrice} €",
                        color: white,
                        size: 16,
                        weight: FontWeight.w300,
                      ))),

              Positioned.fill(
                  bottom: 2,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow[900],
                                size: 20,
                              ),
                            ),
                            Text("${userProvider.restaurant!.rating}"),
                          ],
                        ),
                      ),
                    ),
                  )),

              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      width: 45,
                      child: FloatingActionButton(
                        heroTag: "btnedit",
                        onPressed: () {
                          changeScreen(context, EditRestaurant());
                        },
                        child: Icon(Icons.edit),
                        backgroundColor: primary,
                      ),
                    ),
                  ),
                ),
              ),

              //like button
              Positioned.fill(
                  top: 5,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: GestureDetector(
                        onTap: () {},
                        child: SmallButton(Icons.favorite),
                      ),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(-2, -1),
                          blurRadius: 5),
                    ]),
                child: ListTile(
                    onTap: () {
                      changeScreen(context, OrdersScreen2());
                    },
                    leading: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset("images/delivery.png"),
                    ),
                    title: CustomText(
                      text: "Οι Παραγγελίες Μου",
                      size: 24,
                    ),
                    trailing: CustomText(
                      text: orders.length.toString(),
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(-2, -1),
                          blurRadius: 5),
                    ]),
                child: ListTile(
                    onTap: () {
                      changeScreen(context, AddProductScreen());
                    },
                    leading: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset("images/fd.png"),
                    ),
                    title: CustomText(
                      text: "Τα Προϊόντα Μου",
                      size: 24,
                    ),
                    trailing: CustomText(
                      text: userProvider.products.length.toString(),
                      size: 24,
                      weight: FontWeight.bold,
                    )),
              ),
            ),
          ),

          // products
          Column(
            children: userProvider.products
                .map((item) => GestureDetector(
                      onTap: () {
//                    changeScreen(context, Details(product: item,));
                      },
                      child: ProductWidget(
                        product: item,
                      ),
                    ))
                .toList(),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        heroTag: "btnadd",
        onPressed: () {
          changeScreen(context, AddProductScreen());
        },
        child: Icon(Icons.add),
        backgroundColor: primary,
        tooltip: 'Προσθήκη Προϊόντος',
      ),
    );
  }

  Widget imageWidget({bool? hasImage, String? url}) {
    if (hasImage!)
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: url!,
        height: 160,
        fit: BoxFit.fill,
        width: double.infinity,
      );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                size: 40,
              ),
            ],
          ),
          CustomText(text: "Χωρίς Φωτογραφία")
        ],
      ),
      height: 160,
    );
  }
}
