import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FighterPage extends StatefulWidget {

  String fighterId;
  FighterPage({Key key, this.fighterId}): super(key: key);

  @override
  _FighterPageState createState() => _FighterPageState();
}

class _FighterPageState extends State<FighterPage> {

  bool _isProcessing = true;
  var this_fighter_data;

  Future<void> getFighterData() async {
    setState(() {
      _isProcessing=true;
    });

    try {
      var this_fighter = await Firestore.instance.collection("fighters_collection")
          .document(widget.fighterId)
          .get();
      this_fighter_data = this_fighter.data();
    }
    on Exception catch (e){
      print("exception"+e.toString());
    }

    setState(() {
      _isProcessing=false;
    });
  }

  @override
  void initState() {
    super.initState();

    print(widget.fighterId);

    new Timer(new Duration(milliseconds: 10), () {
      getFighterData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282828),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

      ),
      body: (_isProcessing==true)?Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.red[300])))
          :
      Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                scrollDirection: Axis.vertical,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*SizedBox(
                    width: 100,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:2),
                            child: Icon(
                                Icons.chevron_left,
                                // color: Colors.white
                              color: Colors.grey[800]
                            ),
                          ),
                          Text(
                            "HOME",
                            style: GoogleFonts.montserrat(
                              // fontFamily: 'FreeSans',
                                fontSize: 15,
                                // color: Colors.white
                              color: Colors.grey[800]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),*/
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0,3)
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                        child: Image.network(
                          this_fighter_data["imageURLbanner"],
                          // width: 200,
                          // height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      this_fighter_data["name"],
                      style: GoogleFonts.muli(
                        // fontFamily: 'FreeSans',
                          fontSize: 30,
                          color: Colors.grey[200]
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      this_fighter_data["record"],
                      style: GoogleFonts.muli(
                        // fontFamily: 'FreeSans',
                          fontSize: 13,
                          color: Colors.grey[500]
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  Padding(
                    padding: const EdgeInsets.only(left: 70.0, right: 70),
                    child: SizedBox(
                      height: 40,
                      width: 150,
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => FighterPage()),
                          // );
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'VIEW IN 3D',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  SizedBox(height: 35),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10.0),
                  //   child: Text(
                  //     "Upcoming Fight",
                  //     style: GoogleFonts.muli(
                  //       // fontFamily: 'FreeSans',
                  //         fontSize: 20,
                  //         color: Colors.grey[800]
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Previous Fights",
                      style: GoogleFonts.muli(
                        // fontFamily: 'FreeSans',
                          fontSize: 20,
                          color: Colors.grey[400]
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: SizedBox(
                      height: 70,
                      child: FlatButton(
                        // color: Colors.white,
                        color: Color(0xff3a3a3a),
                        textColor: Colors.grey[200],
                        onPressed: () {
                          // Navigator.of(ctx).pop
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width:15),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Conor McGregor vs Eddie Alvarez",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey[200],
                                        fontSize: 15
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Text(
                                      "Result: Won by TKO",
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
