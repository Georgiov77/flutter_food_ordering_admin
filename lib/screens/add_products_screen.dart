import 'package:flutter/material.dart';
import 'package:foodorderingappadmin/helpers/category.dart';
import 'package:foodorderingappadmin/helpers/style.dart';
import 'package:foodorderingappadmin/models/category.dart';
import 'package:foodorderingappadmin/providers/app.dart';
import 'package:foodorderingappadmin/providers/category.dart';
import 'package:foodorderingappadmin/providers/product.dart';
import 'package:foodorderingappadmin/providers/user.dart';
import 'package:foodorderingappadmin/widgets/custom_file_button.dart';
import 'package:foodorderingappadmin/widgets/custom_text.dart';
import 'package:foodorderingappadmin/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _key = GlobalKey<ScaffoldState>();
  var _currentItemSelected = 'A';
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    String? category;
    final items = ["A", "B", "C"];

    return Scaffold(
      key: _key,
      appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: white,
          title: Text(
            "Προσθήκη Προϊόντος",
            style: TextStyle(color: black),
          )),
      body: appProvider.isLoading
          ? Loading()
          : ListView(
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
                        child: productProvider.productImage == null
                            ? CustomFileUploadButton(
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
                                                  leading:
                                                      new Icon(Icons.image),
                                                  title:
                                                      new Text('From gallery'),
                                                  onTap: () async {
                                                    productProvider
                                                        .getImageFile(
                                                            source: ImageSource
                                                                .gallery);
                                                    Navigator.pop(context);
                                                  }),
                                              new ListTile(
                                                  leading: new Icon(
                                                      Icons.camera_alt),
                                                  title:
                                                      new Text('Take a photo'),
                                                  onTap: () async {
                                                    productProvider
                                                        .getImageFile(
                                                            source: ImageSource
                                                                .camera);
                                                    Navigator.pop(context);
                                                  }),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child:
                                    Image.file(productProvider.productImage!)),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: productProvider.productImage != null,
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
                                        productProvider.getImageFile(
                                            source: ImageSource.gallery);
                                        Navigator.pop(context);
                                      }),
                                  new ListTile(
                                      leading: new Icon(Icons.camera_alt),
                                      title: new Text('Take a photo'),
                                      onTap: () async {
                                        productProvider.getImageFile(
                                            source: ImageSource.camera);
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
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomText(text: "Προτεινόμενο Προϊόν"),
                        Switch(
                            value: productProvider.featured,
                            onChanged: (value) {
                              productProvider.changeFeatured();
                            })
                      ],
                    )),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CustomText(
                      text: "Κατηγορία:",
                      color: grey,
                      weight: FontWeight.w300,
                    ),
                    DropdownButton<String>(
                      value: categoryProvider.selectedCategory,
                      style: TextStyle(
                          color: primary, fontWeight: FontWeight.w300),
                      icon: Icon(
                        Icons.filter_list,
                        color: primary,
                      ),
                      elevation: 0,
                      onChanged: (value) {
                        categoryProvider.changeSelectedCategory(value!.trim());
                      },
                      items: categoryProvider.categoriesName
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                  ],
                ),
                Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
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
                        controller: productProvider.name,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Όνομα Προϊόντος",
                            hintStyle: TextStyle(
                                color: grey, fontFamily: "Sen", fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
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
                        controller: productProvider.description,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Περιγραφή Προϊόντος",
                            hintStyle: TextStyle(
                                color: grey, fontFamily: "Sen", fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
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
                        controller: productProvider.price,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Τιμή",
                            hintStyle: TextStyle(
                                color: grey, fontFamily: "Sen", fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
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
                          // category = categoryProvider.selectedCategory;
                          print(category);
                          appProvider.changeLoading();
                          if (await productProvider.uploadProduct(
                              category: categoryProvider.selectedCategory,
                              restaurantId: userProvider.restaurant!.id,
                              restaurant: userProvider.restaurant!.name)) {
                            _key.currentState!.showSnackBar(SnackBar(
                              content: Text("Upload Completed"),
                              duration: const Duration(seconds: 10),
                            ));
                            appProvider.changeLoading();

                            return;
                          }

                          _key.currentState!.showSnackBar(SnackBar(
                            content: Text("Upload Failed"),
                            duration: const Duration(seconds: 10),
                          ));
                          userProvider.loadProductsByRestaurant(
                              restaurantId: userProvider.restaurant!.id);
                          await userProvider.reload();
                          appProvider.changeLoading();
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

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}
