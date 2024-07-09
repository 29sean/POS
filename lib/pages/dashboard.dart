// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice/actions/firestoreService.dart';
import 'package:practice/components/drawer.dart';
import 'package:practice/pages/inventory.dart';
import 'package:practice/pages/pos.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          backgroundColor: Colors.blue[200],
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Column(
            children: [
              Expanded(
                // flex: 3,
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 350,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10) ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // color of the shadow
                              spreadRadius: 5, // spread radius
                              blurRadius: 7, // blur radius
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        padding: EdgeInsets.only(left: 15,),
                        alignment: Alignment.centerLeft,
                        child: Text('Stock Alerts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // color of the shadow
                              spreadRadius: 5, // spread radius
                              blurRadius: 7, // blur radius
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 30, right: 30),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(child: Container(padding: EdgeInsets.only(left: 15,), child: Text('Name', style: TextStyle(fontSize: 13)))),
                            Expanded(child: Text('Quantity', style: TextStyle(fontSize: 13))),
                            Expanded(child: Text('Expiration Date', style: TextStyle(fontSize: 13))),
                          ],
                        ),
                        // child: ListTile(
                        //   title: Row(
                        //     children: [
                        //       Expanded(child: Text('Name', style: TextStyle(fontSize: 13))),
                        //       Expanded(child: Text('Quantity', style: TextStyle(fontSize: 13))),
                        //       Expanded(child: Text('Expiration Date', style: TextStyle(fontSize: 13))),
                        //     ],
                        //   ),
                        // )
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // color of the shadow
                                spreadRadius: 5, // spread radius
                                blurRadius: 7, // blur radius
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: firestoreService.sortByQuantity(), 
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List ordersList = snapshot.data!.docs;
                      
                                return ListView.builder(
                                  itemCount: ordersList.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot document = ordersList[index];
                                    // String docID = document.id;
                      
                                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      
                                    String name = data['name'];
                                    int quantity = data['quantity'];
                                    Timestamp expirationDateTimestamp = data['expiration date'];
                      
                                    DateTime expirationDate = expirationDateTimestamp.toDate();

                                    if (data['quantity'] <= 10) {
                                      return Container(
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            if ((data['quantity'] <= 5)) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red[200],
                                                  border: Border(
                                                    bottom: BorderSide(width: .3),
                                                    top: BorderSide(width: .3)
                                                  )
                                                ),
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 15, right: 100), 
                                                        child: Text(name, style: TextStyle(fontSize: 13))
                                                      )
                                                    ),
                                                    Expanded(child: Text(quantity.toString(), style: TextStyle(fontSize: 13))),
                                                    Expanded(child: Text(expirationDate.toString(), style: TextStyle(fontSize: 13)))
                                                  ],
                                                ),
                                              );
                                            }
                                            if ((data['quantity'] >= 5 && data['quantity'] <= 10)) {
                                              return Container(
                                                 decoration: BoxDecoration(
                                                  color: Colors.orange[200],
                                                  border: Border(
                                                    bottom: BorderSide(width: .3),
                                                    top: BorderSide(width: .3)
                                                  )
                                                ),
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 15, right: 100),
                                                        child: Text(name, style: TextStyle(fontSize: 13))
                                                      )
                                                    ),
                                                    Expanded(child: Text(quantity.toString(), style: TextStyle(fontSize: 13))),
                                                    Expanded(child: Text(expirationDate.toString(), style: TextStyle(fontSize: 13)))
                                                  ],
                                                ),
                                              );
                                            }
                                            return Container(
                                              height: 40,
                                              child: Row(
                                                children: [
                                                  Expanded(child: Text(name, style: TextStyle(fontSize: 13))),
                                                  Expanded(child: Text(quantity.toString(), style: TextStyle(fontSize: 13))),
                                                  Expanded(child: Text(expirationDate.toString(), style: TextStyle(fontSize: 13)))
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    } 
                    
                                    // if (data['quantity'] <= 10) {
                                    //   return ListTile(
                                    //     title: StatefulBuilder(
                                    //       builder: (context, setState) {
                                    //         if ((data['quantity'] <= 5)) {
                                    //           return Container(
                                    //             color: Colors.red[300],
                                    //             child: Row(
                                    //               children: [
                                    //                 Expanded(child: Text(name, style: TextStyle(fontSize: 13))),
                                    //                 Expanded(child: Text(quantity.toString(), style: TextStyle(fontSize: 13))),
                                    //                 Expanded(child: Text(expirationDate.toString(), style: TextStyle(fontSize: 13)))
                                    //               ],
                                    //             ),
                                    //           );
                                    //         }
                                    //         if ((data['quantity'] >= 5 && data['quantity'] <= 10)) {
                                    //           return Container(
                                    //             color: Colors.orange[300],
                                    //             child: Row(
                                    //               children: [
                                    //                 Expanded(child: Text(name, style: TextStyle(fontSize: 13))),
                                    //                 Expanded(child: Text(quantity.toString(), style: TextStyle(fontSize: 13))),
                                    //                 Expanded(child: Text(expirationDate.toString(), style: TextStyle(fontSize: 13)))
                                    //               ],
                                    //             ),
                                    //           );
                                    //         }
                                    //         return Container(
                                    //           child: Row(
                                    //             children: [
                                    //               Expanded(child: Text(name)),
                                    //               Expanded(child: Text(quantity.toString())),
                                    //               Expanded(child: Text(expirationDate.toString()))
                                    //             ],
                                    //           ),
                                    //         );
                                    //       },
                                    //     ),
                                    //   );
                                    // } 
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
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Inventory()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // color of the shadow
                                  spreadRadius: 5, // spread radius
                                  blurRadius: 7, // blur radius
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory, 
                                  size: 100,
                                ),
                                Text("Inventory", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => POS()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // color of the shadow
                                  spreadRadius: 5, // spread radius
                                  blurRadius: 7, // blur radius
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.point_of_sale, 
                                  size: 100,
                                ),
                                Text("Point of Sale", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
