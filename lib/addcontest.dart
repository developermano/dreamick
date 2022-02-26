import 'package:dreamprivatecontest/contest.dart';
import 'package:dreamprivatecontest/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Addcontest extends StatefulWidget {
  @override
  _AddcontestState createState() => _AddcontestState();
}

class _AddcontestState extends State<Addcontest> {
  var matchnamecon = new TextEditingController();
  var entrycon = new TextEditingController();
  var totalspotcon = new TextEditingController();
  var linkcon = new TextEditingController();

  late InterstitialAd _interstitialAd;
  void initState() {
    super.initState();
    // Load ads.

    InterstitialAd.load(
        adUnitId: "ca-app-pub-6812988945725571/2482864970",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add contest"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              controller: matchnamecon,
              decoration: const InputDecoration(
                hintText: 'IND VS AUS',
                labelText: 'match name',
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: entrycon,
              decoration: const InputDecoration(
                hintText: '5',
                labelText: 'entryfee',
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: totalspotcon,
              decoration: const InputDecoration(
                hintText: '5',
                labelText: 'total spot',
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.url,
              controller: linkcon,
              decoration: const InputDecoration(
                hintText: 'https://dream11.com/....',
                labelText: 'contest link',
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    if (matchnamecon.text != "" &&
                        entrycon.text != "" &&
                        totalspotcon.text != "" &&
                        linkcon.text != "") {
                      _interstitialAd.show();
                      FirebaseDatabase.instance.ref("contest").push().set({
                        "matchname": matchnamecon.text,
                        "entryfee": entrycon.text,
                        "totalspot": totalspotcon.text,
                        "contesturl": linkcon.text,
                        "createat": DateTime.now().millisecondsSinceEpoch
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("ADD CONTEST")),
            )
          ],
        ),
      ),
    );
  }
}
