// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:teladan/bloc/notification_badge/notification_badge_bloc.dart';
import 'package:teladan/components/modal_bottom_sheet_component.dart';
import 'package:teladan/face_detection/utils/convertImage.dart';
import 'package:teladan/face_detection/widget/face_detector_view.dart';
import 'package:teladan/models/Summaries.dart';
import 'package:teladan/utils/auth.dart';
import 'package:teladan/utils/helper.dart';
import 'package:image/image.dart' as imglib;

import '../bloc/attendance_log/attendance_log_bloc.dart';
import '../bloc/attendance_today/attendance_today_bloc.dart';
import '../bloc/summaries/summaries_bloc.dart';
import '../bloc/user/user_bloc.dart';
import '../models/Attendance.dart';
import '../repositories/attendance_repository.dart';
import '../utils/middleware.dart';
import 'attendance/log_attendance_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int gmt = 0;
  String latitude = "0";
  String longitude = "0";

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

  @override
  Widget build(BuildContext context) {
    final attendanceLog = BlocProvider.of<AttendanceTodayBloc>(context);

    if (attendanceLog.state is! AttendanceTodayLoadSuccess) {
      context.read<AttendanceTodayBloc>().add(GetAttendanceToday());
    }

    final summaries = BlocProvider.of<SummariesBloc>(context);
    if (summaries.state is! SummariesLoadSuccess) {
      context.read<SummariesBloc>().add(GetAttendanceSummaries());
    }

    final notification = BlocProvider.of<NotificationBadgeBloc>(context);
    if (notification.state is! NotificationBadgeLoadSuccess) {
      context.read<NotificationBadgeBloc>().add(GetAllNotification());
    }

    DateTime now = DateTime.now();
    var formatter = DateFormat('HH');
    int formattedHour = int.parse(formatter.format(now));

    String time;
    if (formattedHour >= 5 && formattedHour < 11) {
      time = 'Pagi';
    } else if (formattedHour >= 11 && formattedHour < 15) {
      time = 'Siang';
    } else if (formattedHour >= 15 && formattedHour < 18) {
      time = 'Sore';
    } else {
      time = 'Malam';
    }

    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.infinity,
        child: RefreshIndicator(
          onRefresh: () async {
            Middleware().authenticated(context);
            context.read<AttendanceTodayBloc>().add(GetAttendanceToday());
            context.read<SummariesBloc>().add(GetAttendanceSummaries());
          },
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.amber.shade800),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat $time",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              if (state is UserLoadSuccess) {
                                return Text(
                                  state.user.name,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Jangan lupa absen hari ini!",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<AttendanceTodayBloc, AttendanceTodayState>(
                      builder: (context, state) {
                        if (state is AttendanceTodayLoading) {
                          return Text(
                            "Loading ...",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          );
                        } else if (state is AttendanceTodayLoadSuccess) {
                          Attendance attendance = state.attendance;

                          String checkIn =
                              formatDateToHourTime(attendance.check_in, gmt);
                          String checkOut =
                              formatDateToHourTime(attendance.check_out, gmt);

                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    Column(
                                      children: [
                                        BlocBuilder<UserBloc, UserState>(
                                          builder: (context, state) {
                                            String token = "";
                                            if (state is UserLoadSuccess) {
                                              token = state.token;
                                            }
                                            return TextButton(
                                              onPressed: () async {
                                                if (attendance.check_in == "") {
                                                  bool validate =
                                                      await validateLocation(
                                                          token);

                                                  if (validate) {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FaceDetectorView(
                                                          type: "Check In",
                                                          onClockInOut:
                                                              onClockInOut,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                "Clock In",
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                  letterSpacing: 0.5,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        attendance.check_in != ""
                                            ? Text(
                                                checkIn,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  fontSize: 16,
                                                  color: Colors.amber,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        BlocBuilder<UserBloc, UserState>(
                                          builder: (context, state) {
                                            String token = "";
                                            if (state is UserLoadSuccess) {
                                              token = state.token;
                                            }
                                            return TextButton(
                                              onPressed: () async {
                                                if (attendance.check_out ==
                                                    "") {
                                                  bool validate =
                                                      await validateLocation(
                                                          token);

                                                  if (validate) {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FaceDetectorView(
                                                          type: "Check Out",
                                                          onClockInOut:
                                                              onClockInOut,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                "Clock Out",
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                  letterSpacing: 0.5,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        attendance.check_out != ""
                                            ? Text(
                                                checkOut,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  fontSize: 16,
                                                  color: Colors.amber,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 20,
                                ),
                                width: double.infinity,
                                child: Text(
                                  attendance.date,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Text("Failed to load daily absent");
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // daftar absensi
                    GestureDetector(
                      onTap: () {
                        final attendanceLog =
                            BlocProvider.of<AttendanceLogBloc>(context);

                        if (attendanceLog.state is! AttendanceLogLoadSuccess) {
                          // context.read<UserBloc>().add(CheckAuth());
                          // final user = BlocProvider.of<UserBloc>(context);
                          // if (user.state is UserUnauthenticated) Auth().logOut(context);
                          Middleware().authenticated(context);
                          DateTime now = DateTime.now();
                          int month = now.month;

                          context.read<AttendanceLogBloc>().add(
                              GetAttendanceLog(month: month, year: now.year));
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogAttendance(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.library_books_outlined),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daftar Absensi',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 51, 51, 51),
                                ),
                              ),
                              Text(
                                'Seluruh catatan absen kamu 📊',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.keyboard_arrow_right_rounded),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // password
                    // Row(
                    //   children: [
                    //     Icon(Icons.lock_outline),
                    //     const SizedBox(
                    //       width: 12,
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Password',
                    //           style: GoogleFonts.poppins(
                    //             fontSize: 13,
                    //             fontWeight: FontWeight.bold,
                    //             color: Color.fromARGB(255, 51, 51, 51),
                    //           ),
                    //         ),
                    //         Text(
                    //           'Ubah kata sandi',
                    //           style: GoogleFonts.poppins(
                    //             fontSize: 11,
                    //             color: Colors.grey,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(0, 158, 158, 158)
                          .withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 2,
                      offset: const Offset(2, 2), // changes position of shadow
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      'Summaries',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    Text(
                      'Dari tanggal 27 hingga Sekarang',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    BlocBuilder<SummariesBloc, SummariesState>(
                      builder: (context, state) {
                        if (state is SummariesLoading) {
                          // While waiting for the result, you can show a loading indicator.
                          // return const CircularProgressIndicator();
                          return const Text('Loading...');
                        } else if (state is SummariesLoadSuccess) {
                          Summaries summaries = state.summaries;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'On time',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      summaries.onTimeCount.toString(),
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Late check in',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      summaries.lateCheckInCount.toString(),
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Early check out',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      summaries.earlyCheckOutCount.toString(),
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Absent',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      summaries.absent.toString(),
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Time off',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 51, 51, 51),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      summaries.timeOffCount.toString(),
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return const Text('Failed to load summaries ');
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> validateLocation(String token) async {
    ModalBottomSheetComponent()
        .loadingIndicator(context, "Sedang memeriksa lokasimu...");

    await AttendanceRepository().getLocation().then((value) {
      latitude = '${value.latitude}';
      longitude = '${value.longitude}';
      // latitude = '-1.249637';
      // longitude = '116.877503';
    });

    bool validate = await AttendanceRepository()
        .validateLocation(context, token, latitude, longitude);

    return validate;
  }

  Future<void> onClockInOut(InputImage inputImage, String type) async {
    String token = await Auth().getToken();
    imglib.Image compresedImage = compressImage(inputImage);
    bool attend = false;

    if (type == 'Check In') {
      attend = await AttendanceRepository().checkIn(
        context: context,
        image: compresedImage,
        latitude: latitude,
        longitude: longitude,
        token: token,
      );
    } else {
      attend = await AttendanceRepository().checkOut(
        context: context,
        image: compresedImage,
        latitude: latitude,
        longitude: longitude,
        token: token,
      );
    }

    if (attend) {
      context.read<AttendanceTodayBloc>().add(GetAttendanceToday());
      context.read<SummariesBloc>().add(GetAttendanceSummaries());
    }
  }

  imglib.Image compressImage(InputImage imageData) {
    imglib.Image image = decodeYUV420SP(imageData);

    // Resize the image to 1/4 of the original size
    imglib.Image resizedImage = imglib.copyResize(
      image,
      width: (image.width / 2).round(), // Resize to 1/2 for both dimensions
      height: (image.height / 2).round(),
    );

    return resizedImage;
  }
}
