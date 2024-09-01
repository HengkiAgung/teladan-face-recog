import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/bloc/notification_badge/notification_badge_bloc.dart';

import '../../../../bloc/approval_detail/approval_detail_bloc.dart';
import '../../../../bloc/approval_list/approval_list_bloc.dart';
import '../../../../components/approval_action_component.dart';
import '../../../../components/detail_request_component.dart';
import '../../../../models/Attendance/UserLeaveRequest.dart';
import '../../../../utils/middleware.dart';

// ignore: must_be_immutable
class DetailTimeOffApprovalPage extends StatefulWidget {
  String id;
  DetailTimeOffApprovalPage({super.key, required this.id});

  @override
  // ignore: no_logic_in_create_state
  State<DetailTimeOffApprovalPage> createState() =>
      // ignore: no_logic_in_create_state
      _DetailTimeOffApprovalPageState(id: id);
}

class _DetailTimeOffApprovalPageState extends State<DetailTimeOffApprovalPage> {
  String id;

  _DetailTimeOffApprovalPageState({required this.id});

  void refreshBloc() {
    Middleware().authenticated(context);
    context.read<NotificationBadgeBloc>().add(UpdateTimeOffNotification());

    context.read<ApprovalDetailBloc>().add(GetRequestDetail(id: id.toString(),type: "time-off",model: UserLeaveRequest()));
    context.read<ApprovalListBloc>().add(GetRequestList(key: "userTimeOffRequest", type: "time-off", model: UserLeaveRequest()));
  }

  @override
  Widget build(BuildContext context) {
    // var shift = userTimeOffRequest[0].user!.userEmployment!.workingScheduleTimeOff.workingTimeOff;
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
                "Detail Request Time Off",
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
            var request = state.request;
            List<List<String>> stringChildren = [];

            if (request.id != 0) {
              if (request.notes != "") {
                stringChildren.addAll([
                  ["Reason", request.notes],
                ]);
              }

              if (request.leaveRequestCategory.name != "") {
                stringChildren.addAll([
                  ["Category", request.leaveRequestCategory.name],
                ]);
              }

              if (request.start_date != "") {
                stringChildren.addAll([
                  ["Start Date", request.start_date],
                ]);
              }

              if (request.end_date != "") {
                stringChildren.addAll([
                  ["End Date", request.end_date],
                ]);
              }

              if (request.date != null) {
                stringChildren.addAll([
                  ["Date", request.date],
                ]);
                if (request.working_start != null) {
                  stringChildren.addAll([ 
                    ["Working Start", request.working_start],
                  ]); 
                }
                if (request.working_end != null) {
                  stringChildren.addAll([
                    ["Working End", request.working_end],
                  ]);
                }
              } else {
                stringChildren.addAll([
                  ["Taken", request.taken.toString()],
                ]);
              }

              if (request.comment != "") {
                stringChildren.add(["Comment", request.comment]);
              }
            }

            return Column(
              children: [
                Expanded(
                  child: DetailRequestComponent(
                    user: request.user!,
                    status: request.status,
                    stringChildren: stringChildren,
                    file: request.file,
                    type: "timeoff",
                  ),
                ),
                request.status == "Waiting"
                    ? ApprovalActionComponent(
                        type: "time-off",
                        id: request.id.toString(),
                        function: refreshBloc,
                      )
                    : const SizedBox(),
              ],
            );
          }

          return const Text("Failed to load request");
        },
      ),
    );
  }
}
