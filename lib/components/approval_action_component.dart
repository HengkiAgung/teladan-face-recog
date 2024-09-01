// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/approval_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/user/user_bloc.dart';
import 'modal_bottom_sheet_component.dart';

// ignore: must_be_immutable
class ApprovalActionComponent extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();
  String id;
  String type;
  final VoidCallback function;

  ApprovalActionComponent(
      {super.key,
      required this.id,
      required this.type,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comment",
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: commentController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  String token = "";
                  if (state is UserLoadSuccess) {
                    token = state.token;
                  }
                  return Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        ModalBottomSheetComponent().loadingIndicator(context, "Mengirim data...");

                        bool updated = await ApprovalRepository().updateRequest(
                            token: token,
                            type: type,
                            id: id,
                            status: "Rejected",
                            comment: commentController.text);

                        Navigator.pop(context);
                        if (updated) {
                          function();
                        } else {
                          ModalBottomSheetComponent().errorIndicator(context, "Gagal mengubah status request");
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          "Reject",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
              Expanded(
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    String token = "";
                    if (state is UserLoadSuccess) {
                      token = state.token;
                    }
                    return GestureDetector(
                      onTap: () async {
                        ModalBottomSheetComponent().loadingIndicator(context, "Mengirim data...");

                        bool updated = await ApprovalRepository().updateRequest(
                            token: token,
                            type: type,
                            id: id,
                            status: "Approved",
                            comment: commentController.text);
                        
                        Navigator.pop(context);
                        if (updated) {
                          function();
                        } else {
                          ModalBottomSheetComponent().errorIndicator(context, "Gagal mengubah status request");
                        }
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Text(
                          "Approve",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
