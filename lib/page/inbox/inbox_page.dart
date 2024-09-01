import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'need_approval_page.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
    final List<Widget> _listWidget = [
    const NeedApprovalPage(),
  ];
  // void _onNavBarTapped(int index) {
  //   setState(() {
  //     navIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 12),
            margin: EdgeInsetsDirectional.only(top: 20),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "Inbox",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 7),
            margin: EdgeInsetsDirectional.only(top: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Color.fromARGB(160, 158, 158, 158),
                ),
              ),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: (){
                    // _onNavBarTapped(1);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Butuh Persetujuan",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _listWidget[0],
        ],
      ),
    );
  }
}