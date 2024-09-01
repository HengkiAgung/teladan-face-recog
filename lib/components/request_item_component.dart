import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class RequestItemComponent extends StatelessWidget {
  String title;
  List<Widget> children;
  String status;
  void Function()? fun;

  RequestItemComponent({super.key, required this.title, required this.children, required this.status, this.fun});
  
  @override
  Widget build(BuildContext context) {
    Color colorStatus;

    if (status == "Waiting") {
      colorStatus = Colors.amber;
    } else if (status == "Approved") {
      colorStatus = Colors.green;
    } else {
      colorStatus = Colors.red.shade900;
    }

    return Container(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
        top: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Color.fromARGB(160, 158, 158, 158),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: fun,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  ...children,
                  Text(
                    "Status",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: colorStatus,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_vert),
              const SizedBox(
                width: 12,
              )
            ],
          ),
        ),
      ),
    );
  }
}
