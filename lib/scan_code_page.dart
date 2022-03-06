import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/qrcode_reader_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanCodePage extends StatefulWidget {
  @override
  _ScanCodePageState createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {

  GlobalKey<QrcodeReaderViewState> qrViewKey = GlobalKey();

  Future onScan(String fighterID) async {
    // update
    var this_fighter_data;
    try {
      var this_fighter = await Firestore.instance.collection("fighters_collection")
          .document(fighterID)
          .get();
      this_fighter_data = this_fighter.data();
    }
    on Exception catch (e){
      print("exception"+e.toString());
    }
    if(this_fighter_data["redeemed"]==false){
      // that means, this fighter hasnt been redeemed yet

      //updating fighters_collection
      Future<void> saveData1() async{
        Firestore.instance.collection('fighters_collection').doc(fighterID).update({"redeemed": true});
      }
      saveData1();

      // updating the user_fighters_collection
      Future<void> saveData2() async{
        var list = [fighterID];
        Firestore.instance.collection('user_fighters_collection').doc("fMMJJLuUWPnBE5gMs7DV").updateData({"fighters": FieldValue.arrayUnion(list)});
      }
      saveData2();

      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("NEW FIGHTER UNLOCKED!"),
            content: Text(this_fighter_data["name"]),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Continue"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
      qrViewKey.currentState.startScan();
    }
    else{
      // this fighter/qr code has already been scanned before
      await showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("CODE USED ALREADY!"),
            content: Text("This code has been used previously! Try a new code."),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Continue"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
      qrViewKey.currentState.startScan();
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QrcodeReaderView(key: qrViewKey, onScan: onScan),
    );
  }
}
