import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:teladan/utils/helper.dart';

import '../../bloc/attendance_detail/attendance_detail_bloc.dart';
import '../../bloc/attendance_log/attendance_log_bloc.dart';
import '../../models/Attendance.dart';
import '../../utils/middleware.dart';
import 'detail_attendance_page.dart';

class LogAttendance extends StatefulWidget {
  const LogAttendance({super.key});

  @override
  State<LogAttendance> createState() => _LogAttendanceState();
}

class _LogAttendanceState extends State<LogAttendance> {
  int gmt = 0;

  getGMT() async {
    final secondsFromGMT = await LocalePlus().getSecondsFromGMT();

    setState(() {
      gmt = ((secondsFromGMT ?? 0) / 3600).round() - 8;
    });
  }

  List<Attendance> _logAtendance = [];

  late ScrollController _scrollController;
  int page = 1;
  DateTime selectedDate = DateTime.now();

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<AttendanceLogBloc>().add(ScrollFetch(page: page));
    }
  }

  @override
  void initState() {
    getGMT();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Log Attendance",
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
      body: BlocBuilder<AttendanceLogBloc, AttendanceLogState>(
        builder: (context, state) {
          if (state is AttendanceLogLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 18),
              child: Text("loading..."),
            );
          } else if (state is AttendanceLogLoadFailure) {
            return Text("Failed to load attendance log");
          } else if (state is AttendanceLogLoadSuccess) {
            _logAtendance = state.attendance;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // filter date dropdown
              Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                ),
                padding: const EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: 20,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                      width: 1.0,
                      color: Color.fromARGB(160, 158, 158, 158),
                    ),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Filter Date",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "${selectedDate.year}-${selectedDate.month}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                              context.read<AttendanceLogBloc>().add(GetAttendanceLog(month: date.month, year: date.year));
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 60),
                        child: Icon(Icons.date_range),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 60),
                        child: Text(
                          "Check In",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Check Out",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    Middleware().authenticated(context);
                    DateTime now = DateTime.now();
                    int month = now.month;

                    context
                        .read<AttendanceLogBloc>()
                        .add(GetAttendanceLog(month: month, year: now.year));
                    setState(() {
                      page = 1;
                      selectedDate = DateTime.now();
                    });
                  },
                  child: ListView.builder(
                    controller:
                        _logAtendance.length > 9 ? _scrollController : null,
                    itemCount: _logAtendance.length,
                    itemBuilder: (BuildContext context, int index) {
                      var attendance = _logAtendance[index];
                      String checkIn = formatDateToHourTime(attendance.check_in, gmt) != "" ? formatDateToHourTime(attendance.check_in, gmt) : "-";
                      String checkOut = formatDateToHourTime(attendance.check_out, gmt) != "" ? formatDateToHourTime(attendance.check_out, gmt) : "-";

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
                          onTap: () {
                            Middleware().authenticated(context);
                            context.read<AttendanceDetailBloc>().add(
                                GetAttendanceDetail(date: attendance.date));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailAttendance(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      attendance.date,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 50,
                                      child: Text(
                                        checkIn,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 50,
                                      child: Text(
                                        checkOut,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              (state is AttendanceLogFetchNew)
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        height: 40,
                        child: Text("Loading..."),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
