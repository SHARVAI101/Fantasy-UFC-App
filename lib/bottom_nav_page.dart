import 'package:constellation_brands_app/home_page.dart';
import 'package:constellation_brands_app/scan_code_page.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavPage extends StatefulWidget {
  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {

  int _currentindex=0;

  Widget callpage(int currentIndex){
    switch(currentIndex){
      case 0: return HomePage();
      case 1: return ScanCodePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: callpage(_currentindex)
      ),
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.white,
          elevation: 20,
          backgroundColor: Color(0xFF1D1D1D),
          currentIndex: _currentindex,
          unselectedItemColor: Colors.grey[700],
          //   unselectedItemColor: Color(0xFFE5C68A),
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          // selectedItemColor: Colors.tealAccent[700],
          // selectedItemColor: Color(0xFF152D4E),
            selectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30.0,
                // color: Colors.tealAccent[700],
              ),
              // title: SizedBox.shrink(),
              title: Text(
                "HOME",
                style: GoogleFonts.montserrat(
                  // fontFamily: 'FreeSans',
                ),
              ),
            ),
            BottomNavigationBarItem(
                icon: FaIcon(
                  // FontAwesomeIcons.gamepad,
                  // FontAwesomeIcons.dragon,
                  // FontAwesomeIcons.fighterJet,
                  FontAwesomeIcons.barcode,
                  size: 30,
                ),
                // title: SizedBox.shrink(),
                title: Text(
                  "SCAN QR CODE",
                  style: GoogleFonts.montserrat(
                    // fontFamily: 'FreeSans',
                  ),
                ),
            ),
          ],
          onTap: (index){
            setState(() {
              _currentindex=index;
            });
          }
        )
    );
  }
}
