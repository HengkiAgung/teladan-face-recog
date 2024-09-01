import '../models/Employee/User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import 'avatar_profile_component.dart';

// ignore: must_be_immutable
class DetailRequestComponent extends StatefulWidget {
  User user;
  List<List<String>> stringChildren;
  String status;
  String? file;
  String? type;
  void Function()? fun;

  DetailRequestComponent({
    super.key,
    required this.user,
    required this.status,
    this.file = null,
    this.type = null,
    required this.stringChildren,
    this.fun,
  });

  @override
  // ignore: no_logic_in_create_state
  State<DetailRequestComponent> createState() => _DetailRequestComponentState(
        user: user,
        status: status,
        stringChildren: stringChildren,
        file: file,
        type: type,
        fun: fun,
      );
}

class _DetailRequestComponentState extends State<DetailRequestComponent> {
  User user;
  List<List<String>> stringChildren;
  String status;
  String? file;
  String? type;
  void Function()? fun;

  _DetailRequestComponentState({
    required this.user,
    required this.status,
    required this.file,
    required this.type,
    required this.stringChildren,
    this.fun,
  });

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

    List<Widget> children = stringChildren.map((List<String> text) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                text[0],
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Text(
                text[1],
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: const Color.fromARGB(255, 51, 51, 51),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: [
        AvatarProfileComponent(user: user),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width / 2) - 60),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: colorStatus,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            status,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        ...children,
        file != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "File",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          launch(
                              "${Config.storageUrl}/request/$type/$file");
                        },
                        child: Text(
                          file!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
