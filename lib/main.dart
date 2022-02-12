import 'dart:io';

import 'package:dreamprivatecontest/addcontest.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: Mainapp(),
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
  ));
}

class Mainapp extends StatefulWidget {
  @override
  _MainappState createState() => _MainappState();
}

class _MainappState extends State<Mainapp> {
  void launchlink(String url) {
    if (Platform.isAndroid) {
      launch(url);
    } else {
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dream private contest"),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("contest")
            .orderByChild("createat")
            .limitToLast(50)
            .onValue,
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasError) {
            return Center(
              child: Text("error:" + snap.error.toString()),
            );
          }
          if (snap.hasData) {
            Map fd_data = snap.data.snapshot.value;
            if (fd_data.length == 0) {
              return Center(
                child: Text("no data found"),
              );
            }

            return ListView.builder(
                itemCount: fd_data.length,
                itemBuilder: (context, index) {
                  index = fd_data.length - 1 - index;
                  return Container(
                    height: 80,
                    margin: EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        if (Platform.isAndroid) {
                          launch(
                              fd_data.values
                                  .elementAt(index)['contesturl']
                                  .toString(),
                              universalLinksOnly: true);
                        } else {}
                        launch(fd_data.values
                            .elementAt(index)['contesturl']
                            .toString());
                      },
                      child: Card(
                        elevation: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "₹" +
                                        fd_data.values
                                            .elementAt(index)['entryfee'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    "entryfee",
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    fd_data.values
                                        .elementAt(index)['matchname'],
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    fd_data.values
                                        .elementAt(index)['totalspot'],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text("total spot")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addcontest()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
