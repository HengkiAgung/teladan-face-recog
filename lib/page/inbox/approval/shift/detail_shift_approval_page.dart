import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:teladan/bloc/notification_badge/notification_badge_bloc.dart';
import 'package:teladan/models/Attendance/UserShiftRequest.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/utils/helper.dart';

import '../../../../bloc/approval_detail/approval_detail_bloc.dart';
import '../../../../bloc/approval_list/approval_list_bloc.dart';
import '../../../../components/approval_action_component.dart';
import '../../../../components/detail_request_component.dart';
import '../../../../utils/middleware.dart';

// ignore: must_be_immutable
class DetailShiftApprovalPage extends StatefulWidget {
  String id;
  DetailShiftApprovalPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<DetailShiftApprovalPage> createState() =>
      // ignore: no_logic_in_create_state
      _DetailShiftApprovalPageState(id: id);
}

class _DetailShiftApprovalPageState extends State<DetailShiftApprovalPage> {
  String id;
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

  _DetailShiftApprovalPageState({required this.id});

  void refreshBloc() {
    Middleware().authenticated(context);
    context.read<NotificationBadgeBloc>().add(UpdateShiftNotification());

    context.read<ApprovalDetailBloc>().add(GetRequestDetail(id: id.toString(),type: "shift",model: UserShiftRequest()));
    context.read<ApprovalListBloc>().add(GetRequestList(key: "userShiftRequest", type: "shift", model: UserShiftRequest()));
  }

  @override
  Widget build(BuildContext context) {
    // var shift = userShiftRequest[0].user!.userEmployment!.workingScheduleShift.workingShift;
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
      body: BlocBuilder<ApprovalDetailBloc, ApprovalDetailState>(
        builder: (context, state) {
          if (state is ApprovalDetailLoading) {
            return const Text("Loading...");
          } else if (state is ApprovalDetailLoadSuccess) {
            var request = state.request as UserShiftRequest;
            var shift = request.workingShift;
            List<List<String>> stringChildren = [];

            stringChildren.addAll([
              ["Tanggal absensi", request.date],
              [
                "Shift",
                "${shift.name}, ${formatHourTime(shift.working_start, gmt)} - ${formatHourTime(shift.working_end, gmt)}"
              ],
              ["Reason", request.notes],
            ]);

            if (request.comment != "") {
              stringChildren.add(["Comment", request.comment]);
            }

            return Column(
                children: [
                  Expanded(
                    child: DetailRequestComponent(
                      user: request.user!,
                      status: request.status,
                      stringChildren: stringChildren,
                    ),
                  ),
                  request.status == "Waiting"
                      ? ApprovalActionComponent(
                          type: "shift",
                          id: request.id.toString(),
                          function: refreshBloc,
                        )
                      : const SizedBox(),
                ],
              );
          }
          return const Text("Failed to load request");
        },
      )
    );
  }
}
