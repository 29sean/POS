// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:practice/pages/dashboard.dart';
import 'package:practice/pages/inventory.dart';
import 'package:practice/pages/login.dart';
import 'package:practice/pages/pos.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Sean Tongco"),
            accountEmail: Text("tongcosean06@gmail.com"),
            decoration: BoxDecoration(
              color: Colors.blue[400]
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/monticasa.png'),
              backgroundColor: Colors.white,
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Inventory'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Inventory()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.point_of_sale),
            title: Text('Point of Sale'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => POS()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'),
            trailing: CircleAvatar(
              radius: 12,
              child: Text(
                '14',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
          ),
          Expanded(
            child: Container(), // Placeholder for expanded space
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
