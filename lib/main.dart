import 'dart:io';
import 'package:dreamprivatecontest/addcontest.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
  late BannerAd myBanner;
  bool isloaded = false;

  void initState() {
    super.initState();
    myBanner = BannerAd(
      adUnitId: "ca-app-pub-6812988945725571/9807702797",
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(() {
          isloaded = true;
        });
      }, onAdFailedToLoad: (_, error) {
        print(error);
      }),
    );

    myBanner.load();
  }

  Widget ad() {
    if (isloaded == true) {
      return Container(
          alignment: Alignment.center,
          child: AdWidget(ad: myBanner),
          width: myBanner.size.width.toDouble(),
          height: myBanner.size.height.toDouble());
    } else {
      return Text('ad');
    }
  }

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
      bottomNavigationBar: ad(),
      appBar: AppBar(
        title: Text("dream private contest"),
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("contest")
            .orderByChild("createat")
            .limitToLast(5)
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
                  return Column(
                    children: [
                      Container(
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
                            } else {
                              launch(fd_data.values
                                  .elementAt(index)['contesturl']
                                  .toString());
                            }
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
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 5.0),
                      //   child: ad(),
                      // )
                    ],
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
