// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:practice/actions/firestoreService.dart';
import 'package:practice/components/drawer.dart';
import 'package:practice/pages/inventory.dart';

class POS extends StatefulWidget {
  const POS({super.key});

  @override
  State<POS> createState() => _POSState();
}

class _POSState extends State<POS> {

  FirestoreService firestoreService = FirestoreService();
  TextEditingController cartBarcodeIDEditor = TextEditingController();
  TextEditingController paymentMoney = TextEditingController();
  TextEditingController searchPOS = TextEditingController();

  String name = '', imageURL = '';
  bool nameOrCat = true, descTOF = true;
  int quantityCounter = 1, qtt = 0;
  double totalPriceQuantity = 0, totalAmount = 0;
  double updatedTotalPrice = 0;
  bool? discount = false;
  double payableAmount = 0;
  double discountedAmount = 0;
  double finalAmount = 0;
  double change = 0;
  int scannedBarcode = 0;
  bool scanQuantity = false;

  String scannerName = '';
  String scannerCategory = '';
  String scannerDescription = '';
  String scannerImage = '';
  String scannerFormattedDate = '';
  int scannerBatch = 0;
  int scannerBarcode = 0;
  String scannerSellingPrice = '';
  int scannerQuan = 0;
  String scannerdocid = '';

  // List<List<dynamic>> cartItem = [];
  List cartProductNames = [];
  List cartProductQuantity = [];
  List cartProductPrice = [];
  List cartProductID = [];
  List cartProductQuantityData = [];
  List cartProductBarcode = [];
  List cartProductSellingPrice = [];
  List cartProductImage = [];

  void printcart() {
    for (int j = 0; j < cartProductNames.length; j++) {
      print(cartProductNames[j]); 
    }
  }

  void countAmount(){
    setState(() {
      totalAmount += totalPriceQuantity;
    });
  }

  void deleteLists(){
    setState(() {
      cartProductID.clear();
      cartProductNames.clear();
      cartProductPrice.clear();
      cartProductQuantity.clear();
      cartProductQuantityData.clear();
      cartProductSellingPrice.clear();
      cartProductImage.clear();
      cartProductBarcode.clear();
      totalAmount = 0;
    });
  }

  void updateCart(i){
    setState(() {
      cartProductQuantity[i] = quantityCounter;
      cartProductPrice[i] = totalPriceQuantity;
    });
  }

  void deleteProductCart (i){
    setState(() {
      cartProductID.remove(cartProductID[i]);
      cartProductBarcode.remove(cartProductBarcode[i]);
      cartProductNames.remove(cartProductNames[i]);
      cartProductQuantity.remove(cartProductQuantity[i]);
      cartProductPrice.remove(double.parse(cartProductPrice[i].toStringAsFixed(2)));
      cartProductQuantityData.remove(cartProductQuantityData[i]);
      cartProductSellingPrice.remove(cartProductSellingPrice[i]);
      cartProductImage.remove(cartProductImage[i]);
    });
  }

  void clearScan() {
    setState(() {
      scannerName = '';
      scannerCategory = '';
      scannerDescription = '';
      scannerImage = '';
      scannerFormattedDate = '';
      scannerBatch = 0;
      scannerBarcode = 0;
      scannerSellingPrice = '';
      scannerQuan = 0;
      scannerdocid = '';
    });
  }

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(90, 169, 230, 1),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(249, 249, 249, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // color of the shadow
                              spreadRadius: 5, // spread radius
                              blurRadius: 7, // blur radius
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text('POINT OF SALE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                              )
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 30),
                              child: FilledButton.tonal(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(127, 200, 248, 1)), 
                                ),
                                onPressed: () {
                                  scanQuantity = true;
                                  myFocusNode.requestFocus();
                                }, 
                                child: Text('Add Quantity')
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 50),
                              width: 400,
                              child: TextField(
                                controller: searchPOS,
                                autofocus: true,
                                focusNode: myFocusNode,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search),
                                  hintText: "Search...",
                                ),
                                onChanged: (val) {
                                  setState(() {
                                   name = val.toUpperCase();
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                    
                                    // scannedBarcode = int.parse(value);

                                    quantityCounter = 1;
                                    totalPriceQuantity = double.parse(scannerSellingPrice);
                                    if (scanQuantity == true) {
                                      showDialog(
                                      context: context, 
                                      builder: (context) {
                                        return StatefulBuilder(builder: (context, setState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  width: 400,
                                                  child: BackButton(),
                                                ),
                                                Container( 
                                                  width: 100,
                                                  height: 100,
                                                  child: Image.network(scannerImage) 
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                  width: 400,
                                                  child: Text(scannerName, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context, 
                                                      builder: (context) {
                                                        return StatefulBuilder(
                                                          builder: (context, setState) =>
                                                          Dialog(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10.0),
                                                            ),
                                                            child: Container(
                                                              width: 800,
                                                              height: 500,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  Container(
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.max,
                                                                      children: [
                                                                        Container(
                                                                          width: 400,
                                                                          alignment: Alignment.topLeft,
                                                                          child: BackButton(),
                                                                        ),
                                                                        Container(
                                                                          width: 400,
                                                                          height: 450,
                                                                          child: SingleChildScrollView(
                                                                            child: Column(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.all(10),
                                                                                  width: 400,
                                                                                  child: Text(scannerName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(left: 10, bottom: 10),
                                                                                  width: 400,
                                                                                  child: Text(scannerCategory, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.all(10),
                                                                                  width: 400,
                                                                                  child: Text('Description:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(left: 10, bottom: 10, right: 20),
                                                                                  width: 400,
                                                                                  child: Text(scannerDescription, style: TextStyle(fontSize: 18), textAlign: TextAlign.justify),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Container( 
                                                                        margin: EdgeInsets.only(top: 40, bottom: 20),
                                                                        width: 200,
                                                                        height: 200,
                                                                        child: Image.network(scannerImage) 
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Container(
                                                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                                                width: 200,
                                                                                child: Text('Expiration Date:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                                                width: 200,
                                                                                child: Text('Batch Number:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                                                width: 200,
                                                                                child: Text('Barcode:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                                                width: 200,
                                                                                child: Text('Price:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                                                width: 200,
                                                                                child: Text('Quantity:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Container(
                                                                                padding: EdgeInsets.only(top: 5),
                                                                                width: 200,
                                                                                child: Text(scannerFormattedDate, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(top: 5),
                                                                                width: 200,
                                                                                child: Text(scannerBatch.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(top: 5),
                                                                                width: 200,
                                                                                child: Text(scannerBarcode.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(top: 5),
                                                                                width: 200,
                                                                                child: Text(scannerSellingPrice.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.only(top: 5),
                                                                                width: 200,
                                                                                child: Text(scannerQuan.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ]
                                                                      ),                                 
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    );
                                                  }, 
                                                  icon: Icon(Icons.more_horiz, size: 50,)
                                                ),
                                                Text('₱ ' + totalPriceQuantity.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          if (quantityCounter <= 1) {
                                                            return;
                                                          } else {
                                                            quantityCounter--;
                                                            totalPriceQuantity = double.parse(scannerSellingPrice) * quantityCounter;
                                                          }                                                                    
                                                        });
                                                      }, 
                                                      icon: Icon(Icons.remove_circle_rounded, size: 50)
                                                    ),
                                                    Text(quantityCounter.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                    IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          quantityCounter++;
                                                          totalPriceQuantity = double.parse(scannerSellingPrice) * quantityCounter;
                                                        });
                                                      },
                                                      icon: Icon(Icons.add_circle_rounded, size: 50)
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 10),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      bool found = false;
                                                      for (var i = 0; i < cartProductBarcode.length; i++) {
                                                        if (cartProductBarcode[i] == scannerBarcode) {
                                                          cartProductQuantity[i] += quantityCounter;
                                                          cartProductPrice[i] += double.parse(totalPriceQuantity.toStringAsFixed(2));
                                                          found = true;
                                                          break;
                                                        }
                                                      }
                                                      if (!found) {
                                                        cartProductID.add(scannerdocid);
                                                        cartProductBarcode.add(scannerBarcode);
                                                        cartProductNames.add(scannerName);
                                                        cartProductQuantity.add(quantityCounter);
                                                        cartProductPrice.add(double.parse(totalPriceQuantity.toStringAsFixed(2)));
                                                        cartProductQuantityData.add(scannerQuan);
                                                        cartProductSellingPrice.add(scannerSellingPrice);
                                                        cartProductImage.add(scannerImage);
                                                      }
                                                      myFocusNode.requestFocus();
                                                      clearScan();
                                                      countAmount();
                                                      print(totalAmount);
                                                      print(cartProductBarcode);
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color.fromARGB(255, 175, 212, 241),
                                                      shadowColor: const Color.fromARGB(255, 49, 50, 51),
                                                    ),
                                                    child: Text('ADD TO CART'),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                    );
                                    
                                    }
                                    else {
                                      bool found = false;
                                      for (var i = 0; i < cartProductBarcode.length; i++) {
                                        if (cartProductBarcode[i] == scannerBarcode) {
                                          cartProductQuantity[i] += quantityCounter;
                                          cartProductPrice[i] += double.parse(totalPriceQuantity.toStringAsFixed(2));
                                          found = true;
                                          break;
                                        }
                                      }
                                      if (!found) {
                                        cartProductID.add(scannerdocid);
                                        cartProductBarcode.add(scannerBarcode);
                                        cartProductNames.add(scannerName);
                                        cartProductQuantity.add(quantityCounter);
                                        cartProductPrice.add(double.parse(totalPriceQuantity.toStringAsFixed(2)));
                                        cartProductQuantityData.add(scannerQuan);
                                        cartProductSellingPrice.add(scannerSellingPrice);
                                        cartProductImage.add(scannerImage);
                                      }
                                      clearScan();
                                    }
                                    
                                    scanQuantity = false;
                                    countAmount();
                                    myFocusNode.requestFocus();
                                    name = '';
                                    searchPOS.text = '';                            
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child: StreamBuilder(
                          stream: firestoreService.getProductStream(nameOrCat, descTOF), 
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List productList = snapshot.data!.docs;

                              List filteredProducts = productList.where((product) {
                              String productName = product['name'].toString().toUpperCase();
                              String productCategory = product['category'].toString().toUpperCase();
                              String barcode = product['barcode id'].toString();

                              // Convert name to uppercase for case-insensitive comparison
                              String searchUpperCase = name.toUpperCase();

                              // Check if productName, productCategory, or barcode contains the search term
                              return productName.contains(searchUpperCase) ||
                                    productCategory.contains(searchUpperCase) ||
                                    barcode.contains(searchUpperCase);
                              }).toList();

                              return GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                                itemCount: filteredProducts.length, 
                                itemBuilder: (context, index) {
                                DocumentSnapshot document = filteredProducts[index];
                                  String docID = document.id;

                                  Map<String, dynamic> data = document.data() as Map<String,dynamic>;
                                  if (data != null) {

                                    int batchNumber = data['batch number'];
                                    int barcodeID = data['barcode id'];
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
                                    Timestamp expirationDateTimestamp = data['expiration date'];
                                    Timestamp dateReceivedTimestamp = data['date received'];
                                    DateTime expirationDate = expirationDateTimestamp.toDate();
                                    DateTime dateReceived = dateReceivedTimestamp.toDate();

                                    String formattedExpirationDate = DateFormat('MMM d, yyyy').format(dateReceived);

                                    if (name.isEmpty) {
                                      return Container(
                                        // color: Colors.blue[200],
                                        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                                        child: InkWell(
                                          onTap: (){
                                            quantityCounter = 1;
                                            totalPriceQuantity = double.parse(sellingPrice);
                                            showDialog(
                                              context: context, 
                                              builder: (context) {
                                                return StatefulBuilder(builder: (context, setState) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.topLeft,
                                                          width: 400,
                                                          child: BackButton(),
                                                        ),
                                                        Container( 
                                                          width: 100,
                                                          height: 100,
                                                          child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),  
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10, right: 10),
                                                          width: 400,
                                                          child: Text(productName, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                                        IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context, 
                                                              builder: (context) {
                                                                return StatefulBuilder(
                                                                  builder: (context, setState) =>
                                                                  Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                    ),
                                                                    child: Container(
                                                                      width: 800,
                                                                      height: 500,
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: [
                                                                          Container(
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: 400,
                                                                                  alignment: Alignment.topLeft,
                                                                                  child: BackButton(),
                                                                                ),
                                                                                Container(
                                                                                  width: 400,
                                                                                  height: 450,
                                                                                  child: SingleChildScrollView(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(10),
                                                                                          width: 400,
                                                                                          child: Text(productName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: EdgeInsets.only(left: 10, bottom: 10),
                                                                                          width: 400,
                                                                                          child: Text(category, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(10),
                                                                                          width: 400,
                                                                                          child: Text('Description:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: EdgeInsets.only(left: 10, bottom: 10, right: 20),
                                                                                          width: 400,
                                                                                          child: Text(description, style: TextStyle(fontSize: 18), textAlign: TextAlign.justify),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize: MainAxisSize.max,
                                                                            children: [
                                                                              Container( 
                                                                                margin: EdgeInsets.only(top: 40, bottom: 20),
                                                                                width: 200,
                                                                                height: 200,
                                                                                child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),  
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Expiration Date:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Batch Number:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Barcode:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Price:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Quantity:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(formattedExpirationDate, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(batchNumber.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(barcodeID.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(sellingPrice.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(productQuantity.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ]
                                                                              ),
                                                                              
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            );
                                                          }, 
                                                          icon: Icon(Icons.more_horiz, size: 50,)
                                                        ),
                                                        Text('₱ ' + totalPriceQuantity.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: (){
                                                                setState(() {
                                                                  if (quantityCounter <= 1) {
                                                                    return;
                                                                  } else {
                                                                    quantityCounter--;
                                                                    totalPriceQuantity = double.parse(sellingPrice) * quantityCounter;
                                                                  }                                                                    
                                                                });
                                                              }, 
                                                              icon: Icon(Icons.remove_circle_rounded, size: 50)
                                                            ),
                                                            Text(quantityCounter.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                            IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  quantityCounter++;
                                                                  totalPriceQuantity = double.parse(sellingPrice) * quantityCounter;
                                                                });
                                                              },
                                                              icon: Icon(Icons.add_circle_rounded, size: 50)
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(bottom: 10),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              bool found = false;
                                                              for (var i = 0; i < cartProductBarcode.length; i++) {
                                                                if (cartProductBarcode[i] == barcodeID) {
                                                                  cartProductQuantity[i] += quantityCounter;
                                                                  cartProductPrice[i] += double.parse(totalPriceQuantity.toStringAsFixed(2));
                                                                  found = true;
                                                                  break;
                                                                }
                                                              }
                                                              if (!found) {
                                                                cartProductID.add(docID);
                                                                cartProductBarcode.add(barcodeID);
                                                                cartProductNames.add(productName);
                                                                cartProductQuantity.add(quantityCounter);
                                                                cartProductPrice.add(double.parse(totalPriceQuantity.toStringAsFixed(2)));
                                                                cartProductQuantityData.add(productQuantity);
                                                                cartProductSellingPrice.add(sellingPrice);
                                                                cartProductImage.add(productImage);
                                                              }
                                                              countAmount();
                                                              print(totalAmount);
                                                              print(cartProductBarcode);
                                                              Navigator.pop(context);
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color.fromARGB(255, 175, 212, 241),
                                                              shadowColor: const Color.fromARGB(255, 49, 50, 51),
                                                            ),
                                                            child: Text('ADD TO CART'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(249, 249, 249, 1),
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
                                            child: GridTile(
                                              child: Title(
                                                color: const Color.fromRGBO(127, 200, 248, 1),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                                                        alignment: Alignment.center,
                                                        child: Text(productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center)
                                                      )
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topCenter, 
                                                      child: Text('₱ ${sellingPrice}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      height: 80,
                                                      child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                                    ), 
                                                  ],
                                                )
                                              )
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    scannerName = productName;
                                    scannerCategory = category;
                                    scannerDescription = description;
                                    scannerImage = productImage;
                                    scannerFormattedDate = formattedExpirationDate;
                                    scannerBatch = batchNumber;
                                    scannerBarcode = barcodeID;
                                    scannerSellingPrice = sellingPrice;
                                    scannerQuan = productQuantity;
                                    scannerdocid = docID;
                                    if (name.isNotEmpty) {
                                      return Container(
                                        // color: Colors.blue[200],
                                        margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                                        child: InkWell(
                                          onTap: (){
                                            quantityCounter = 1;
                                            totalPriceQuantity = double.parse(sellingPrice);
                                            showDialog(
                                              context: context, 
                                              builder: (context) {
                                                return StatefulBuilder(builder: (context, setState) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          alignment: Alignment.topLeft,
                                                          width: 400,
                                                          child: BackButton(),
                                                        ),
                                                        Container( 
                                                          width: 100,
                                                          height: 100,
                                                          child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),  
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(left: 10, right: 10),
                                                          width: 400,
                                                          child: Text(productName, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                                        IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context, 
                                                              builder: (context) {
                                                                return StatefulBuilder(
                                                                  builder: (context, setState) =>
                                                                  Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(10.0),
                                                                    ),
                                                                    child: Container(
                                                                      width: 800,
                                                                      height: 500,
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.max,
                                                                        children: [
                                                                          Container(
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                Container(
                                                                                  width: 400,
                                                                                  alignment: Alignment.topLeft,
                                                                                  child: BackButton(),
                                                                                ),
                                                                                Container(
                                                                                  width: 400,
                                                                                  height: 450,
                                                                                  child: SingleChildScrollView(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(10),
                                                                                          width: 400,
                                                                                          child: Text(productName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: EdgeInsets.only(left: 10, bottom: 10),
                                                                                          width: 400,
                                                                                          child: Text(category, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(10),
                                                                                          width: 400,
                                                                                          child: Text('Description:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                        ),
                                                                                        Container(
                                                                                          padding: EdgeInsets.only(left: 10, bottom: 10, right: 20),
                                                                                          width: 400,
                                                                                          child: Text(description, style: TextStyle(fontSize: 18), textAlign: TextAlign.justify),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize: MainAxisSize.max,
                                                                            children: [
                                                                              Container( 
                                                                                margin: EdgeInsets.only(top: 40, bottom: 20),
                                                                                width: 200,
                                                                                height: 200,
                                                                                child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),  
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Expiration Date:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Batch Number:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Barcode:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Price:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(left: 10, top: 5),
                                                                                        width: 200,
                                                                                        child: Text('Quantity:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(formattedExpirationDate, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(batchNumber.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(barcodeID.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(sellingPrice.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                      Container(
                                                                                        padding: EdgeInsets.only(top: 5),
                                                                                        width: 200,
                                                                                        child: Text(productQuantity.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ]
                                                                              ),
                                                                              
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            );
                                                          }, 
                                                          icon: Icon(Icons.more_horiz, size: 50,)
                                                        ),
                                                        Text('₱ ' + totalPriceQuantity.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                              onPressed: (){
                                                                setState(() {
                                                                  if (quantityCounter <= 1) {
                                                                    return;
                                                                  } else {
                                                                    quantityCounter--;
                                                                    totalPriceQuantity = double.parse(sellingPrice) * quantityCounter;
                                                                  }                                                                    
                                                                });
                                                              }, 
                                                              icon: Icon(Icons.remove_circle_rounded, size: 50)
                                                            ),
                                                            Text(quantityCounter.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                            IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  quantityCounter++;
                                                                  totalPriceQuantity = double.parse(sellingPrice) * quantityCounter;
                                                                });
                                                              },
                                                              icon: Icon(Icons.add_circle_rounded, size: 50)
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(bottom: 10),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              bool found = false;
                                                              for (var i = 0; i < cartProductBarcode.length; i++) {
                                                                if (cartProductBarcode[i] == barcodeID) {
                                                                  cartProductQuantity[i] += quantityCounter;
                                                                  cartProductPrice[i] += double.parse(totalPriceQuantity.toStringAsFixed(2));
                                                                  found = true;
                                                                  break;
                                                                }
                                                              }
                                                              if (!found) {
                                                                cartProductID.add(docID);
                                                                cartProductBarcode.add(barcodeID);
                                                                cartProductNames.add(productName);
                                                                cartProductQuantity.add(quantityCounter);
                                                                cartProductPrice.add(double.parse(totalPriceQuantity.toStringAsFixed(2)));
                                                                cartProductQuantityData.add(productQuantity);
                                                                cartProductSellingPrice.add(sellingPrice);
                                                                cartProductImage.add(productImage);
                                                              }
                                                              clearScan();
                                                              countAmount();
                                                              print(totalAmount);
                                                              print(cartProductBarcode);
                                                              Navigator.pop(context);
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: const Color.fromARGB(255, 175, 212, 241),
                                                              shadowColor: const Color.fromARGB(255, 49, 50, 51),
                                                            ),
                                                            child: Text('ADD TO CART'),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 20),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(249, 249, 249, 1),
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
                                            child: GridTile(
                                              child: Title(
                                                color: const Color.fromRGBO(127, 200, 248, 1),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 10,top: 10,right: 10),
                                                        alignment: Alignment.center,
                                                        child: Text(productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center)
                                                      )
                                                    ),
                                                    Container(
                                                      alignment: Alignment.topCenter, 
                                                      child: Text('₱ ${sellingPrice}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      height: 80,
                                                      child: data.containsKey('imageURL') ? Image.network(productImage) : Container(),
                                                    ), 
                                                  ],
                                                )
                                              )
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Container();
                                  }
                                }
                              );
                            } 
                            else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                // color: const Color.fromRGBO(127, 200, 248, 1),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(249, 249, 249, 1),
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
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromRGBO(90, 169, 230, 1), // specify border color
                          width: 2.0,         // specify border width
                        ),
                      ),
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(72),
                        child: Image.asset(
                          'images/monticasa.png',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: ListView.builder(
                          itemCount: cartProductNames.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                          child:
                                              Padding(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Text('${cartProductNames[index]}'))),
                                      Expanded(
                                          child: Text(
                                              '${cartProductQuantity[index]}', textAlign: TextAlign.center,)),
                                      Expanded(
                                          child:
                                              Text('${cartProductPrice[index]}'))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            child: Text('Total : ', style: TextStyle(fontWeight: FontWeight.bold))
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 35),
                            alignment: Alignment.centerRight,
                            child: Text("₱ " + totalAmount.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold))
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        title:  Container(
                          width: 50,
                          child: FilledButton.tonal(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(127, 200, 248, 1)),
                            ),
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (context) => 
                                StatefulBuilder(
                                  builder: (context, setState) => 
                                  Dialog(
                                    child: Container(
                                      width: 800,
                                      height: 700,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 30, right: 30),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              alignment: Alignment.centerLeft, 
                                                              child: Text("Payable Amount:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerLeft, 
                                                              child: Text("20% Discounted Amount:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerLeft, 
                                                              child: Text("Final Amount after Discount:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              alignment: Alignment.centerRight, 
                                                              child: Text(payableAmount.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerRight, 
                                                              child: Text(discountedAmount.toStringAsFixed(2), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                            ),
                                                            Container(
                                                              alignment: Alignment.centerRight, 
                                                              child: Text(finalAmount.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Container(
                                                //   child: StatefulBuilder(
                                                //     builder: (context, setState) {
                                                //       if (discount == true) {
                                                //         return Text(finalAmount.toString());
                                                //       }
                                                //       else{
                                                //         return Text(finalAmount.toString());
                                                //       }
                                                //     },
                                                //   ),
                                                // ),
                                                Container(
                                                  width: 200,
                                                  child: CheckboxListTile(
                                                    title: Text('DISCOUNT'),
                                                    value: discount, 
                                                    onChanged: (bool? newValue){
                                                      setState(() {
                                                        discount = newValue!;
                                                        if (discount == true) {
                                                          payableAmount = totalAmount;
                                                          discountedAmount = totalAmount * 0.2;
                                                          finalAmount = payableAmount - discountedAmount;
                                                        }
                                                        else{
                                                          payableAmount =  totalAmount;
                                                          discountedAmount = 0;
                                                          finalAmount = payableAmount;
                                                        }
                                                      });
                                                    },
                                                    activeColor: const Color.fromARGB(255, 24, 24, 24),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                  width: 200,
                                                  child: TextField(
                                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                                    ],
                                                    controller: paymentMoney,
                                                    decoration: InputDecoration(
                                                      border: UnderlineInputBorder(),
                                                      labelText: 'Enter Amount',
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(bottom: 15, left: 7),
                                                      child: FilledButton.tonal(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                          minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
                                                        ),
                                                        onPressed: (){
                                                          if (double.parse(paymentMoney.text) >= finalAmount) {
                                                            change = double.parse(paymentMoney.text) - finalAmount;
                                                            showDialog(
                                                              context: context, 
                                                              builder: (context) => Dialog(
                                                                child: Container(
                                                                  width: 400,
                                                                  height: 250,
                                                                  child: Column(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Container(
                                                                          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                                                                          child: Row(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 2,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      alignment: Alignment.centerLeft, 
                                                                                      child: Text("Payable Amount:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.centerLeft, 
                                                                                      child: Text("20% Discounted Amount:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      padding: EdgeInsets.only(bottom: 30),
                                                                                      alignment: Alignment.centerLeft, 
                                                                                      child: Text("Final Amount after Discount:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.centerLeft, 
                                                                                      child: Text("Cash:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.centerLeft, 
                                                                                      child: Text("Change:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      alignment: Alignment.centerRight, 
                                                                                      child: Text(payableAmount.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.centerRight, 
                                                                                      child: Text(discountedAmount.toStringAsFixed(2), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      padding: EdgeInsets.only(bottom: 30),
                                                                                      alignment: Alignment.centerRight, 
                                                                                      child: Text(finalAmount.toString(), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.centerRight, 
                                                                                      child: Text(paymentMoney.text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.centerRight, 
                                                                                      child: Text(change.toStringAsFixed(2), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.only(bottom: 15, left: 7),
                                                                        child: FilledButton.tonal(
                                                                          style: ButtonStyle(
                                                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                                            minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
                                                                          ),
                                                                          onPressed: (){
                                                                            for (var i = 0; i < cartProductNames.length; i++) {
                                                                              int qtt = cartProductQuantityData[i] - cartProductQuantity[i];
                                                                              firestoreService.quantityDeduction(cartProductID[i], qtt);
                                                                            }
                                                                            deleteLists();
                                                                            Navigator.pop(context);
                                                                          }, 
                                                                          child: Text("Ok")
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            Navigator.pop(context);
                                                          }
                                                        }, 
                                                        child: Text("Pay")
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(bottom: 15, left: 7),
                                                      child: FilledButton.tonal(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                          minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        }, 
                                                        child: Text("Cancel")
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color.fromRGBO(90, 169, 230, 1), // specify border color
                                                        width: 2.0,         // specify border width
                                                      ),
                                                    ),
                                                    child: SizedBox.fromSize(
                                                      size: const Size.fromRadius(72),
                                                      child: Image.asset(
                                                        'images/monticasa.png',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    child: ListView.builder(
                                                      itemCount: cartProductNames.length,
                                                      itemBuilder: (context, index) {
                                                        return SingleChildScrollView(
                                                          child: Container(
                                                            child: Center(
                                                              child: Padding(
                                                                padding: EdgeInsets.only(bottom: 10),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 3,
                                                                        child:
                                                                            Padding(
                                                                              padding: EdgeInsets.only(left: 10),
                                                                              child: Text('${cartProductNames[index]}'))),
                                                                    Expanded(
                                                                        child: Text(
                                                                            '${cartProductQuantity[index]}', textAlign: TextAlign.center,)),
                                                                    Expanded(
                                                                        child:
                                                                            Text('${cartProductPrice[index]}'))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 30, top: 30),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets.only(left: 15),
                                                          alignment: Alignment.centerLeft,
                                                          child: Text('Total : ', style: TextStyle(fontWeight: FontWeight.bold))
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets.only(right: 35),
                                                          alignment: Alignment.centerRight,
                                                          child: Text("₱ " + totalAmount.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold))
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              payableAmount = totalAmount;
                              finalAmount = totalAmount;
                              discountedAmount = 0;
                              discount = false;
                            }, child: Text('CHECK OUT')
                          ),
                        ),
                        leading: StatefulBuilder(
                          builder: (context, setState) {
                            if (cartProductQuantity.isEmpty) {
                              return Container(
                                child: IconButton(
                                  onPressed: () {
                                    
                                  }, 
                                icon: Icon(Icons.edit)
                                ),
                              );
                            }
                            else {
                              return Container(
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
                                                alignment: Alignment.topLeft,
                                                width: 300,
                                                child: BackButton(),
                                              ),
                                              Container(
                                                child: Text('Enter Barcode ID')
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                width: 200,
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                    inputFormatters: <TextInputFormatter>[
                                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                                      FilteringTextInputFormatter.digitsOnly
                                                    ],
                                                  controller: cartBarcodeIDEditor,
                                                  decoration: InputDecoration()
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(bottom: 15, right: 7),
                                                    child: FilledButton.tonal(
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                        minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
                                                      ),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                        for (var i = 0; i < cartProductBarcode.length; i++) {
                                                          if (int.parse(cartBarcodeIDEditor.text) == cartProductBarcode[i]) {
                                                            quantityCounter = cartProductQuantity[i];
                                                            totalPriceQuantity = cartProductPrice[i];
                                                            showDialog(
                                                              context: context, 
                                                              builder: (context) => 
                                                              Dialog(
                                                                child: StatefulBuilder(
                                                                  builder: (context, setState) =>
                                                                  Container(
                                                                    child: Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Container(
                                                                          alignment: Alignment.topLeft,
                                                                          width: 400,
                                                                          child: BackButton(),
                                                                        ),
                                                                        Text(cartProductBarcode[i].toString()),
                                                                        Container(
                                                                          width: 150,
                                                                          height: 150,
                                                                          child: Image.network(cartProductImage[i])
                                                                        ),
                                                                        Text(cartProductNames[i]),
                                                                        Text('₱ ' + totalPriceQuantity.toStringAsFixed(2), textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                        Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            IconButton(
                                                                              onPressed: (){
                                                                                setState(() {
                                                                                  if (quantityCounter <= 1) {
                                                                                    return;
                                                                                  } else {
                                                                                    quantityCounter--;
                                                                                    totalPriceQuantity = double.parse(cartProductSellingPrice[i]) * quantityCounter;
                                                                                  }                                                                    
                                                                                });
                                                                              }, 
                                                                              icon: Icon(Icons.remove_circle_rounded, size: 50)
                                                                            ),
                                                                            Text(quantityCounter.toString(), textAlign: TextAlign.end, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            IconButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  quantityCounter++;
                                                                                  totalPriceQuantity = double.parse(cartProductSellingPrice[i]) * quantityCounter;
                                                                                });
                                                                              },
                                                                              icon: Icon(Icons.add_circle_rounded, size: 50)
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            Container(
                                                                              padding: EdgeInsets.only(bottom: 15, right: 7),
                                                                              child: StatefulBuilder(
                                                                                builder: (context, setState) => 
                                                                                FilledButton.tonal(
                                                                                  style: ButtonStyle(
                                                                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                                                    minimumSize: MaterialStateProperty.all<Size>(Size(120, 40)),
                                                                                  ),
                                                                                  onPressed: (){
                                                                                    updateCart(i);
                                                                                    for (var j = 0; j < cartProductPrice.length; j++) {
                                                                                      updatedTotalPrice += cartProductPrice[j];
                                                                                    }
                                                                                    print(updatedTotalPrice);
                                                                                    print(cartProductPrice);
                                                                                    totalAmount = updatedTotalPrice;
                                                                                    updatedTotalPrice = 0;
                                                                                    Navigator.pop(context);
                                                                                  }, 
                                                                                  child: Text("Update")
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              padding: EdgeInsets.only(bottom: 15, left: 7),
                                                                              child: FilledButton.tonal(
                                                                                style: ButtonStyle(
                                                                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                                                  minimumSize: MaterialStateProperty.all<Size>(Size(120, 40)),
                                                                                ),
                                                                                onPressed: (){
                                                                                  deleteProductCart(i);
                                                                                  Navigator.pop(context);
                                                                                }, 
                                                                                child: Text("Remove")
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    )
                                                                  ),
                                                                ),
                                                              )
                                                            );
                                                          }
                                                        }
                                                        print(cartBarcodeIDEditor.text);
                                                        // cartBarcodeIDEditor.text = '';
                                                        // Navigator.pop(context);
                                                      }, 
                                                      child: Text("Ok")
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(bottom: 15, left: 7),
                                                    child: FilledButton.tonal(
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                        minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
                                                      ),
                                                      onPressed: (){
                                                        Navigator.pop(context);
                                                      }, 
                                                      child: Text("Cancel")
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ) ; 
                                      },
                                    );
                                  
                                  }, 
                                icon: Icon(Icons.edit, color: Colors.green)
                                ),
                              );
                            }
                          }
                        ),
                        trailing: StatefulBuilder(
                          builder: (context, setState) {
                            if (cartProductNames.isEmpty) {
                              return Container(
                                child: IconButton(
                                  onPressed: () {
                        
                                  }, 
                                  icon: Icon(Icons.cancel)
                                ),
                              );
                            } else {
                              return Container(
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
                                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                                child: Text('Are you sure to cancel transaction?')
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  FilledButton.tonal(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                                      minimumSize: MaterialStateProperty.all<Size>(Size(100, 30)),
                                                    ),
                                                    onPressed: (){
                                                      deleteLists();
                                                      Navigator.pop(context);
                                                    }, 
                                                    child: Text("Ok")
                                                  ),
                                                  FilledButton.tonal(
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                                      minimumSize: MaterialStateProperty.all<Size>(Size(100, 30)),
                                                    ),
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    }, 
                                                    child: Text("Cancel")
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ) ; 
                                      },
                                    );
                                  }, 
                                icon: Icon(Icons.cancel, color: Colors.red,)),
                              );
                            }
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}