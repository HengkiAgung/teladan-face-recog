import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:teladan/models/Attendance/UserShiftRequest.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/utils/helper.dart';

import '../../../bloc/request_detail/request_detail_bloc.dart';
import '../../../bloc/request_shift_list/request_shift_list_bloc.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../components/avatar_profile_component.dart';
import '../../../components/cancel_request_component.dart';
import '../../../utils/middleware.dart';

class DetailShiftRequestPage extends StatefulWidget {
  final int id;
  const DetailShiftRequestPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<DetailShiftRequestPage> createState() =>
      DetailShiftRequestPageState(id: id);
}

class DetailShiftRequestPageState extends State<DetailShiftRequestPage> {
  final int id;

  int gmt = 0;

  getGMT() async {
    final secondsFromGMT = await LocalePlus().getSecondsFromGMT();

    setState(() {
      gmt = ((secondsFromGMT ?? 0) / 3600).round() - 8;
    });
  }

  @override
  void initState() {
    getGMT();
    super.initState();
  }

  void onCancle() {
    Middleware().authenticated(context);

    context.read<RequestDetailBloc>().add(GetRequestDetail(
        id: id.toString(), type: "attendance", model: UserShiftRequest()));

    context.read<RequestShiftListBloc>().add(GetRequestList());
  }
  
  DetailShiftRequestPageState({required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: const Color.fromARGB(255, 226, 226, 226),
            height: 1,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Center(
              child: Text(
                "Detail Request Shift",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Spacer()
        ],
      ),
      body: BlocBuilder<RequestDetailBloc, RequestDetailState>(
        builder: (context, state) {
          if (state is RequestDetailLoading) {
            return const Padding(
              padding: EdgeInsets.only(top:18.0, left: 18),
              child: Text("loading..."),
            );
          } else if (state is RequestDetailLoadSuccess) {
            UserShiftRequest request = state.request;

            Color colorStatus;

            if (request.status == "Waiting") {
              colorStatus = Colors.amber;
            } else if (request.status == "Approved") {
              colorStatus = Colors.green;
            } else {
              colorStatus = Colors.red.shade900;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return const Text('Loading...');
                          } else if (state is UserLoadSuccess) {
                            // Handle the error case here.
                            return AvatarProfileComponent(
                              user: state.user,
                            );
                          } else {
                            return const Text('Failed to load user data');
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                (MediaQuery.of(context).size.width / 2) - 60),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorStatus,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          request.status,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
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
                          children: [
                            Expanded(
                              child: Text(
                                "Tanggal",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                request.date,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                          children: [
                            Expanded(
                              child: Text(
                                "Shift",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${request.workingShift.name}, ${formatHourTime(request.workingShift.working_start, gmt)} - ${formatHourTime(request.workingShift.working_end, gmt)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                                "Alasan",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                request.notes,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      request.approvalLine!.email != ""
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 15,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 0.5,
                                        color:
                                            Color.fromARGB(160, 158, 158, 158),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Approved by",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${request.approvalLine!.name}, ${request.approvalLine!.email}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: const Color.fromARGB(
                                                255, 51, 51, 51),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 15,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 0.5,
                                        color:
                                            Color.fromARGB(160, 158, 158, 158),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Catatan ",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          request.comment != ""
                                              ? request.comment
                                              : "-",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: const Color.fromARGB(
                                                255, 51, 51, 51),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                request.status == "Waiting"
                    ? CancelRequestComponent(
                        id: request.id,
                        type: "shift",
                        onCancle: onCancle,
                      )
                    : const SizedBox()
              ],
            );
          } else {
            return const Text("Failed to load detail attendance request");
          }
        },
      ),
    );
  }
}
