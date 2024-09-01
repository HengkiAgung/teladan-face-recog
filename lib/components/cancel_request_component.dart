import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/request_repository.dart';
import 'modal_bottom_sheet_component.dart';

// ignore: must_be_immutable
class CancelRequestComponent extends StatelessWidget {
  int id;
  String type;
  final VoidCallback onCancle;

  CancelRequestComponent({super.key, required this.id, required this.type, required this.onCancle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 212, 212, 212),
            blurRadius: 4,
            offset: Offset(-2, 2), // Shadow position
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          ModalBottomSheetComponent().loadingIndicator(context, "Sedang mengirim data...");

          bool updated = await RequestRepository().cancelRequest(id: id, type: type);
          Navigator.pop(context);
          if (updated) {
            onCancle();
          }
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.amber
          ),
          child: Text(
            "Cancel",
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
