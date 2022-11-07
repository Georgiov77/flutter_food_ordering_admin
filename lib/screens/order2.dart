import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodorderingappadmin/helpers/style.dart';
import 'package:foodorderingappadmin/providers/app.dart';
import 'package:foodorderingappadmin/providers/user.dart';
import 'package:foodorderingappadmin/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class OrdersScreen2 extends StatefulWidget {
  User? user;
  @override
  State<OrdersScreen2> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen2> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('orders')
        .where("restaurantIds", arrayContains: user.restaurant!.id)
        .snapshots();

    print(_usersStream.length);

    final app = Provider.of<AppProvider>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: black),
            backgroundColor: white,
            elevation: 0.0,
            title: CustomText(text: "Orders"),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          backgroundColor: white,
          body: ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  leading: CustomText(
                    text: "${data["total"]} €",
                    weight: FontWeight.bold,
                  ),
                  title: Text(data["cart"][0]['name']),
                  subtitle: Text(
                    "Ποσότητα ${data["cart"][0]['quantity']}",
                    style: TextStyle(color: black, fontSize: 15),
                  ),
                  trailing: CustomText(
                    text: "${data["status"]}",
                    color: Colors.green,
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
