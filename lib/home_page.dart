import 'dart:async';

import 'package:constellation_brands_app/fighter_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isProcessing = true;
  var my_fighters_list = [];
  var my_fighters_id_list = [];
  var points = 0;

  var new_winners = [];
  var new_losers = [];

  Future<void> getFighters() async {
    setState(() {
      _isProcessing=true;
    });

    try {
      var user_fighters = await Firestore.instance.collection("user_fighters_collection")
          .document("fMMJJLuUWPnBE5gMs7DV")
          .get();

      for(var i=0; i<user_fighters["fighters"].length; i++){
        var this_fighter = await Firestore.instance.collection("fighters_collection")
            .document(user_fighters["fighters"][i])
            .get();
        var this_fighter_map = this_fighter.data();
        this_fighter_map["id"] = user_fighters["fighters"][i];
        my_fighters_list.add(this_fighter_map);
        my_fighters_id_list.add(user_fighters["fighters"][i]);
      }
      print(my_fighters_list);
      print(my_fighters_id_list);

      points = user_fighters["points"];
    }
    on Exception catch (e){
      print("exception"+e.toString());
    }

    setState(() {
      _isProcessing=false;
    });

    getWinLoseData();
  }

  Future<void> getWinLoseData() async {

    try {
      var fights_snap = await Firestore.instance.collection("fights_collection")
          .get();
      var fights_data = fights_snap.docs.map((doc)=>doc.data()).toList();

      print(fights_data);

      for(var i=0; i<fights_data.length; i++){
        if(fights_data[i]["downloaded"]==false){
          print(my_fighters_list);
          if(my_fighters_id_list.contains(fights_data[i]["winner"])){
            // print("jerere");
            // getting image
            for(var j=0; j<my_fighters_list.length; j++){
              if(my_fighters_list[j]["id"]==fights_data[i]["winner"]){
                fights_data[i]["imageURL"] = my_fighters_list[j]["imageURL"];
                fights_data[i]["myfighter"] = my_fighters_list[j]["name"];
                break;
              }
            }

            var thistotal = 0;
            if(fights_data[i]["type"]=="knockout"){
              thistotal+=10;
              print("knock out ~~~~~~~~~~~~~~~~~~~~~~~`");
            }
            else if(fights_data[i]["type"]=="submission"){
              thistotal+=8;
            }
            else if(fights_data[i]["type"]=="decision"){
              thistotal+=5;
            }

            if(fights_data[i]["round1finish"]==true){
              thistotal+=10;
              print("round 1 finish ~~~~~~~~~~~~~~~~~~~~~~~`");
            }

            thistotal+=20; // for winning

            fights_data[i]["thistotal"] = thistotal;

            new_winners.add(fights_data[i]);

            //updating points on the server
            points+=thistotal;
            Future<void> saveData2() async{
              Firestore.instance.collection('user_fighters_collection').doc("fMMJJLuUWPnBE5gMs7DV").update({"points": points});
            }
            saveData2();
          }

          if(my_fighters_id_list.contains(fights_data[i]["loser"])){
            // getting image
            var copy = {...fights_data[i]};
            for(var j=0; j<my_fighters_list.length; j++){
              if(my_fighters_list[j]["id"]==fights_data[i]["loser"]){
                copy["imageURL"] = my_fighters_list[j]["imageURL"];
                copy["myfighter"] = my_fighters_list[j]["name"];
                break;
              }
            }
            new_losers.add(copy);
          }

          // fights_data[i]["downloaded"]=true;

          //updating this collection on the server
          Future<void> saveData1() async{
            Firestore.instance.collection('fights_collection').doc(fights_data[i]["id"]).update({"downloaded": true});
          }
          saveData1();
        }
      }

      setState(() {});
      printAllWinLose();
    }
    on Exception catch (e){
      print("exception"+e.toString());
    }
  }

  void printAllWinLose() async {
    print("printing winners and losers");
    print(new_winners);
    print(new_losers);
    for(var i=0; i<new_winners.length; i++) {
      // await Future.delayed(Duration(milliseconds: 50));
      showDialog(
        context: context,
        builder: (ctx) =>
          AlertDialog(
            backgroundColor: Color(0xFF9CCC65),
            title: Text(
              "YOUR FIGHTER WON!",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 30
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            // contentPadding: EdgeInsets.only(top: 0,left:20,right:20,bottom:10),
            content: Wrap(
              // scrollDirection: Axis.vertical,
              // direction: Axis.vertical,
              children: [
                Image.network(
                  new_winners[i]["imageURL"],
                  fit: BoxFit.cover,
                ),
                SizedBox(height:30),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      new_winners[i]["myfighter"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18
                      ),
                    ),
                  ),
                ),
                SizedBox(height:10),
                Divider(),
                SizedBox(height: 10),
                Text(
                  "Victory By: "+new_winners[i]["type"]+((new_winners[i]["type"]=="knockout")?" (+10)":((new_winners[i]["type"]=="submission")?" (+8)":" (+5)")),
                  // textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 16
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "First Round Win: "+((new_winners[i]["round1finish"]==true)?"YES (+10 points)":"NO"),
                  // textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 16
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Total = +"+new_winners[i]["thistotal"].toString()+" points",
                  // textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.grey[600],
                      fontSize: 16
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                height: 50,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: RaisedButton(
                  color: Color(0xff2d3436),
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Text(
                    "CONTINUE",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
      );
    }

    for(var i=0; i<new_losers.length; i++){
      showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              backgroundColor: Color(0xFFD32F2F),
              title: Text(
                "YOUR FIGHTER LOST",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 30
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              // contentPadding: EdgeInsets.only(top: 0,left:20,right:20,bottom:10),
              content: Wrap(
                // scrollDirection: Axis.vertical,
                // direction: Axis.vertical,
                children: [
                  Image.network(
                    new_losers[i]["imageURL"],
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        new_losers[i]["myfighter"],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: RaisedButton(
                    color: Color(0xff2d3436),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Text(
                      "CONTINUE",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
      );
    }

  }

  @override
  void initState() {
    super.initState();

    new Timer(new Duration(milliseconds: 10), () {
      getFighters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282828),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right:5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              spreadRadius: 5,
                              blurRadius: 30,
                              offset: Offset(0,3)
                          )
                        ]
                    ),
                    child: Image.asset(
                      'assets/images/user.png',
                      width:100,
                      height:100
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Sharvai",
                        style: GoogleFonts.montserrat(
                          // fontFamily: 'FreeSans',
                            fontSize: 35,
                            // color: Color(0xFF152D4E)
                            color: Colors.grey[200]
                        ),
                      ),
                      // SizedBox(height: 10),
                      Text(
                        "Total Points: "+points.toString(),
                        style: GoogleFonts.montserrat(
                          // fontFamily: 'FreeSans',
                            fontSize: 13,
                            color: Colors.yellowAccent
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "MY FIGHTERS",
              style: GoogleFonts.muli(
                // fontFamily: 'FreeSans',
                  fontSize: 18,
                  color: Colors.grey[300]

              ),
            ),
            Flexible(
              child: (_isProcessing==true)?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red[300])))
                  :
              (my_fighters_list.length==0)?
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/open-box.png",
                      height: 200
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "You have no fighters in your roster at the moment",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          // fontFamily: 'FreeSans',
                            fontSize: 15,
                            color: Colors.grey[500]
                        ),
                      ),
                    ),
                  ],
                )
              )
                  :
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  itemCount: my_fighters_list.length,
                  itemBuilder: (BuildContext context, int i){
                    String name = my_fighters_list[my_fighters_list.length-1-i]["name"];
                    String imageURL = my_fighters_list[my_fighters_list.length-1-i]["imageURL"];
                    return new Column(
                      children: [
                        SizedBox(height: 10,),
                        SizedBox(
                          height: 100,
                          child: RaisedButton(
                            // color: Colors.white,
                            color: Color(0xff3a3a3a),
                            textColor: Colors.grey[200],
                            onPressed: () {
                              // Navigator.of(ctx).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FighterPage(fighterId: my_fighters_list[my_fighters_list.length-1-i]["id"])),
                              );
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    imageURL,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width:15),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.grey[200],
                                            fontSize: 18
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: Text(
                                          "Record: " + my_fighters_list[my_fighters_list.length-1-i]["record"].toString(),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.grey[500],
                                              fontSize: 13
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
