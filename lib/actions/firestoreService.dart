import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FirestoreService{

  final CollectionReference product = FirebaseFirestore.instance.collection('products');
  final CollectionReference receive = FirebaseFirestore.instance.collection('receive');
  final CollectionReference receivedOrders = FirebaseFirestore.instance.collection('receivedOrders');
  final CollectionReference sales = FirebaseFirestore.instance.collection('sales');

  Future<void> updateProduct(String docID, String newPName, String newPQuan, String newCat, String newPrice, String newImageURL){
    return product.doc(docID).update({
      'name': newPName,
      'quantity': newPQuan,
      'category': newCat,
      'price': newPrice,
      'imageURL': newImageURL,
    });
  }

  Future<void> receiveProduct(int batchNumber, int barcodeid, String pname, String pdescription, int pquan, double psellingprice, double punitcost, String pcat, String psupplier, int plevel1, int plevel2, String imageURL, DateTime expirationDate, DateTime dateReceived, String status){
    return receive.add({
      'batch number': batchNumber,
      'barcode id' : barcodeid,
      'name': pname,
      'description': pdescription,
      'quantity': pquan,
      'selling price': psellingprice,
      'unit cost': punitcost,
      'category': pcat,
      'supplier': psupplier,
      'price level 1': plevel1,
      'price level 2': plevel2,
      'imageURL': imageURL,
      'expiration date': expirationDate,
      'date received': dateReceived,
      'status': status
    });
  }

  Future<void> addToInventory(int batchNumber, int barcodeid, String pname, String pdescription, int pquan, String psellingprice, String punitcost, String pcat, String psupplier, int plevel1, int plevel2, String imageURL, DateTime expirationDate, DateTime dateReceived){
    return product.add({
      'batch number': batchNumber,
      'barcode id' : barcodeid,
      'name': pname,
      'description': pdescription,
      'quantity': pquan,
      'selling price': psellingprice,
      'unit cost': punitcost,
      'category': pcat,
      'supplier': psupplier,
      'price level 1': plevel1,
      'price level 2': plevel2,
      'imageURL': imageURL,
      'expiration date': expirationDate,
      'date received': dateReceived,
    });
  }

  //UPDATE STATUS
  Future<void> updateStatus(String docID, String status){
    return receive.doc(docID).update({
      'status': status,
    });
  }

  Future<void> addReceivedOrders(int batchNumber, DateTime dateReceived){
    return receivedOrders.add({
      'batch number': batchNumber,
      'date received': dateReceived
    });
  }

  //display to
  Stream<QuerySnapshot> getProductStream(bool nameOrCat, bool descTOF) {
    if (nameOrCat) {
      return product.orderBy('name', descending: descTOF).snapshots();
    } else {
      return product.orderBy('category', descending: descTOF).snapshots();
    }
  }

  //Display Orders
  Stream<QuerySnapshot> getOrdersStream(){
    return receivedOrders.orderBy('date received', descending: true).snapshots();
  }

  //Display Order
  Stream<QuerySnapshot> getOrderStream(){
    return receive.orderBy('name', descending: true).snapshots();
  }

  Stream<QuerySnapshot> sortByQuantity(){
    return product.orderBy('quantity', descending: false).snapshots();
  }

  Future<void> deleteProduct(String docID){
    return product.doc(docID).delete();
  }

  Future<void> quantityDeduction(String docID, int quantity){
    return product.doc(docID).update({
      'quantity': quantity,
    });
  }

  
  // //ADD 2 CART
  // Future<void> add2Cart(String name, int quantity, double total){
  //   return cart.add({
  //     'name': name,
  //     'quantity': quantity,
  //     'total': total
  //   });
  // }

  // //DISPLAY CART
  // Stream<QuerySnapshot> getCartStream(){
  //   final cartStream = cart.snapshots();

  //   return cartStream;
  // }
}

