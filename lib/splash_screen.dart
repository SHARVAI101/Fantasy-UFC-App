import 'package:constellation_brands_app/bottom_nav_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1D1D),
      body: Padding(
        padding: EdgeInsets.only(left:20, right:20),
        child: Column(

          children: [
            SizedBox(height: 70),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/cono.png',
                width: 300,
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "FANTASY",
                  style: GoogleFonts.montserrat(
                      fontSize: 35,
                      color: Colors.grey[200]
                  ),
                )
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/UFC_Logo.png',
                width: 300,
                height: 80,
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(height: 120,),
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Powered By",
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      color: Colors.grey[400]
                  ),
                )
            ),
            SizedBox(height: 5,),
            Image.asset(
              'assets/images/modelo_icon.png',
              width: 200,
              height: 60,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 50),
            SizedBox(
              height: 70,
              width:400,
              child: RaisedButton(
                // color: Colors.white,
                color: Color(0xff3a3a3a),
                textColor: Colors.grey[200],
                onPressed: () {
                  // Navigator.of(ctx).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavPage()),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "GET STARTED",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                            color: Colors.grey[300],
                            fontSize: 18
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
    );
  }
}
