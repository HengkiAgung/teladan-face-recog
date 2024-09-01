import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/bloc/approval_assignment_list/approval_assignment_list_bloc.dart';
import 'package:teladan/bloc/notification_badge/notification_badge_bloc.dart';
import 'package:teladan/page/inbox/approval/assignment/assignment_approval_page.dart';
import 'package:teladan/page/inbox/approval/attendance/attendance_approval_page.dart';
import 'package:teladan/page/inbox/approval/time_off/time_off_approval_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/approval_list/approval_list_bloc.dart';
import '../../models/Attendance/UserAttendanceRequest.dart';
import '../../models/Attendance/UserLeaveRequest.dart';
import '../../models/Attendance/UserShiftRequest.dart';
import '../../utils/middleware.dart';
import 'approval/shift/shift_approval_page.dart';

class NeedApprovalPage extends StatelessWidget {
  const NeedApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          // Cuti
          GestureDetector(
            onTap: () {
              Middleware().authenticated(context);

              context.read<ApprovalListBloc>().add(GetRequestList(
                  key: "userTimeOffRequest",
                  type: "time-off",
                  model: UserLeaveRequest()));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimeOffApprovalPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
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
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Time Off",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<NotificationBadgeBloc, NotificationBadgeState>(
                    builder: (context, state) {
                      if (state is NotificationBadgeLoadSuccess) {
                        var timeoffCounter = state.timeoff;

                        return timeoffCounter > 0
                            ? Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    timeoffCounter < 10 ? '$timeoffCounter' : '9+',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                              )
                            : const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),

          // Absensi
          GestureDetector(
            onTap: () {
              Middleware().authenticated(context);

              context.read<ApprovalListBloc>().add(GetRequestList(
                  key: "userAttendanceRequest",
                  type: "attendance",
                  model: UserAttendanceRequest()));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceApprovalPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
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
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(Icons.location_history_rounded),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Absensi",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<NotificationBadgeBloc, NotificationBadgeState>(
                    builder: (context, state) {
                      if (state is NotificationBadgeLoadSuccess) {
                        var attendanceCounter = state.attendance;

                        return attendanceCounter > 0
                            ? Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    attendanceCounter < 10 ? '$attendanceCounter' : '9+',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                            : const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),

          // Perubahan Shift
          GestureDetector(
            onTap: () {
              Middleware().authenticated(context);

              context.read<ApprovalListBloc>().add(GetRequestList(
                  key: "userShiftRequest",
                  type: "shift",
                  model: UserShiftRequest()));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShiftApprovalPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
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
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(Icons.loop_rounded),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Perubahan Shift",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<NotificationBadgeBloc, NotificationBadgeState>(
                    builder: (context, state) {
                      if (state is NotificationBadgeLoadSuccess) {
                        var shiftCounter = state.shift;

                        return shiftCounter > 0
                            ? Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Text(
                                    shiftCounter < 10 ? '$shiftCounter' : '9+',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                            : const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),

          // Assignment
          GestureDetector(
            onTap: () {
              Middleware().authenticated(context);

              context
                  .read<ApprovalAssignmentListBloc>()
                  .add(const GetApprovalAssigment());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssignmentApprovalPage(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
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
                  const SizedBox(
                    width: 12,
                  ),
                  const Icon(Icons.assignment),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    "Assignment",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 51, 51, 51),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<NotificationBadgeBloc, NotificationBadgeState>(
                    builder: (context, state) {
                      if (state is NotificationBadgeLoadSuccess) {
                        var assignmentCounter = state.assignment;

                        return assignmentCounter > 0
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  assignmentCounter < 10 ? '$assignmentCounter' : '9+',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
