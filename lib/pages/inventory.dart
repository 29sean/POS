// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, empty_catches, unnecessary_null_comparison
import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practice/actions/firestoreService.dart';
import 'package:practice/components/drawer.dart';
import 'package:snapshot/snapshot.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});
  
  @override
  State<Inventory> createState() => _InventoryState();
}

// TextEditingController searchController = TextEditingController();
// TextEditingController searchAvailable = TextEditingController();

final TextEditingController pname = TextEditingController();
final TextEditingController pdescription = TextEditingController();
final TextEditingController pquan = TextEditingController();
final TextEditingController psellingprice = TextEditingController();
final TextEditingController punitcost = TextEditingController();
final TextEditingController pcat = TextEditingController();
final TextEditingController psupplier = TextEditingController();
final TextEditingController ppricelevel1 = TextEditingController();
final TextEditingController ppricelevel2 = TextEditingController();

class _InventoryState extends State<Inventory> {

final FirestoreService firestoreService = FirestoreService();

var collection = FirebaseFirestore.instance.collection('products');
late List<Map<String, dynamic>> items ;
bool isLoaded = false;

  String name = 'ALL ITEMS', search = '', searchAv = '', imageURL = '';
  bool nameOrCat = true, descTOF = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Inventory"),
        backgroundColor: Colors.blue[500],
      ),
      drawer: MyDrawer(),
      body: Container(
        color: Colors.blue[300],
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 15),
                        color: Colors.blue[300],
                        alignment: Alignment.centerLeft,
                        height: 60,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("Inventory", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
                        ),
                      ),
                      Container(
                        color: Colors.blue[300],
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20, bottom: 20),
                        height: 50,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("List of medicines available for sales.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  height: 40,
                  margin: EdgeInsets.only(right: 30),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search...",
                    ),
                    onChanged: (val) {
                      setState(() {
                        search = val.toUpperCase();
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.white,
              height: 10,
            ),
            Container(
              height: 40,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 70,
                    color: Colors.amber,
                    child: Text('Image', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
                  ),
                  Container(
                    color: Colors.blue,
                    width: 300,
                    child: Text('Product Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Qty', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Selling Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Unit Cost', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('Suppplier', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Price Level 1', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Price Level 2', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            // ListTile(
            //   title: Container(
            //     margin: EdgeInsets.only(left: 30),
            //     child: Row(
            //       children: [
            //         Container(
            //           color: Colors.blue,
            //           width: 200,
            //           child: Text('Product Name', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(flex: 2, child: Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(child: Text('Qty', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(child: Text('Selling Price', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(child: Text('Unit Cost', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(flex: 2, child: Text('Category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(flex: 2, child: Text('Suppplier', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(child: Text('Price Level 1', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //         Expanded(child: Text('Price Level 2', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
            //       ],
            //     ),
            //   ),
            //   leading: Container(
            //     alignment: Alignment.center,
            //     width: 50,
            //     color: Colors.amber,
            //     child: Text('Image')
            //   )
            // ),
            
            //ITEM DISPLAY CONTAINER
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getProductStream(nameOrCat, descTOF),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List productList = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = productList[index];
                          String docID = document.id;

                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          if (data != null) {
                            // Use type annotations for clarity and safety
                            String productName = data['name'] as String? ?? "";
                            String description = data['description'] as String? ?? "";
                            int productQuantity = data['quantity'] as int? ?? 0;
                            String category = data['category'] as String? ?? "";
                            String supplier = data['supplier'] as String? ?? "";
                            String sellingPrice = (data['selling price'] ?? "") as String;
                            String unitCost = (data['unit cost'] ?? "") as String;
                            String productImage = data['imageURL'] as String? ?? "";
                            int priceLevel1 = data['price level 1'] as int? ?? 0;
                            int priceLevel2 = data['price level 2'] as int? ?? 0;

                            // Now you can use these variables as needed.

                            if (name == 'ALL ITEMS' && search.isEmpty) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(productName)),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context, 
                                            builder: (context) {
                                              return Dialog(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Text(description)),
                                                    Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: ElevatedButton(onPressed: (){
                                                        Navigator.pop(context);
                                                      }, 
                                                      child: Text('Back')),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }, 
                                        icon: Icon(Icons.more_horiz)
                                      )
                                    ),
                                    Expanded(child: Text(productQuantity.toString())),
                                    Expanded(child: Text(sellingPrice.toString())),
                                    Expanded(child: Text(unitCost.toString())),
                                    Expanded(flex: 2, child: Text(category)),
                                    Expanded(flex: 2, child: Text(supplier)),
                                    Expanded(child: Text(priceLevel1.toString())),
                                    Expanded(child: Text(priceLevel2.toString())),                                    
                                  ],
                                ),
                                leading: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  width: 50,
                                  height: 50,
                                  child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                ),
                              );
                            } 

                            //DISPLAY SEARCH 
                            if ((data['name'].toString().startsWith(search) && data['category'].toString().startsWith(category)) || (name == 'ALL ITEMS' && data['name'].toString().startsWith(search) || name == 'ALL ITEMS' && data['category'].toString().startsWith(search)) || (data['barcode id'].toString().startsWith(search))) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(flex: 2, child: Text(productName)),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context, 
                                            builder: (context) {
                                              return Dialog(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Text(description)),
                                                    Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: ElevatedButton(onPressed: (){
                                                        Navigator.pop(context);
                                                      }, 
                                                      child: Text('Back')),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }, 
                                        icon: Icon(Icons.more_horiz)
                                      )
                                    ),
                                    Expanded(child: Text(productQuantity.toString())),
                                    Expanded(child: Text(sellingPrice.toString())),
                                    Expanded(child: Text(unitCost.toString())),
                                    Expanded(flex: 2, child: Text(category)),
                                    Expanded(flex: 2, child: Text(supplier)),
                                    Expanded(child: Text(priceLevel1.toString())),
                                    Expanded(child: Text(priceLevel2.toString())), 
                                  ],
                                ),
                                trailing: Wrap(
                                  children: <Widget>[
                                    IconButton(onPressed: (){
                                      pname.text = productName;
                                      pcat.text = category;
                                      psellingprice.text = sellingPrice.toString();
                                      pquan.text = productQuantity.toString();
                                      // action(docID);
                                    }, icon: Icon(Icons.edit, color: Colors.green)),
                                    IconButton(onPressed: (){
                                      firestoreService.deleteProduct(docID);
                                    }, icon: Icon(Icons.delete, color: Colors.red))
                                  ],
                                ),
                                leading: Container(
                                  margin: EdgeInsets.only(right: 20),
                                  width: 50,
                                  height: 50,
                                  child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                ),
                              );
                            }
                            return Container();
                            } else {
                              // Handle case where data is null, depending on your application logic.
                            }                      
                        },
                      );
                    }
                    else {
                      return Expanded(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text('No product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40))
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
