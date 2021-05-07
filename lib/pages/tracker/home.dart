import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/snack_bar.dart';
import 'package:flutter_app/models/user_location.dart';
import 'package:flutter_app/pages/finder/finder.dart';
import 'package:flutter_app/pages/tracker/add.dart';
import 'package:flutter_app/pages/tracker/map.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  // Stores the id as created in the database
  // of the current device if it's connected
  static String id = '';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseUser = FirebaseAuth.instance.currentUser;
  final _devices = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('active');

  Future<void> _updateLocation(UserLocation location) async {
    if (location == null || HomePage.id.isEmpty) return;
    try {
      await _devices.doc(HomePage.id).get().then((document) {
        document.data()['lat'] = location.latitude;
        document.data()['lng'] = location.longitude;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = Provider.of<UserLocation>(context);

    // this makes sure the location is updated when the device moves
    if (HomePage.id.isNotEmpty) {
      _updateLocation(location);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Your current devices'),
        actions: [
          IconButton(
            onPressed: () async {
              if (HomePage.id.isEmpty) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/authWrapper');
              } else {
                buildSnackBar(context,
                    'Please remove the current device from the list before logging out.');
              }
            },
            icon: Icon(
              Icons.logout,
              color: Colors.redAccent[700],
            ),
          ),
          IconButton(
            icon: Icon(Icons.post_add),
            onPressed: () {
              if (_firebaseUser != null && _firebaseUser.emailVerified == true) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Finder()));
              } else {
                buildSnackBar(context,
                    'Please verify your email and log in again to access this feature.');
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _devices.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData == false || snapshot.data.docs.length == 0) {
            return Center(
              child: Text('No devices detected.'),
            );
          }
          return ListView(
            children: snapshot.data.docs.map((document) {
              return ListTile(
                title: Text(
                  document.data()['name'],
                  style: TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  document.data()['number'],
                  style: TextStyle(
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    if (document.id == HomePage.id) {
                        HomePage.id = '';
                    }
                    await _devices.doc(document.id).delete();
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(),
                      settings: RouteSettings(
                        arguments: {
                          'name': document.data()['name'],
                          'lat': document.data()['lat'],
                          'lng': document.data()['lng'],
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        child: Icon(Icons.add_outlined),
        // Go to add devices page
        onPressed: () {
          if (_firebaseUser == null) {
            buildSnackBar(context, 'Please log in to access this feature.');
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDevicePage(),
              settings: RouteSettings(
                name: 'devices',
                arguments: _devices,
              ),
            ),
          );
        },
      ),
    );
  }
}
