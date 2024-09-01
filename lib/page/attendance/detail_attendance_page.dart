import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:teladan/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/attendance_detail/attendance_detail_bloc.dart';
import '../../models/Attendance.dart';

class DetailAttendance extends StatefulWidget {
  const DetailAttendance({super.key});

  @override
  State<DetailAttendance> createState() => _DetailAttendanceState();
}

class _DetailAttendanceState extends State<DetailAttendance> {
  int gmt = 0;

  getGMT() async {
    final secondsFromGMT = await LocalePlus().getSecondsFromGMT();

    setState(() {
      gmt = ((secondsFromGMT ?? 0) / 3600).round() - 8;
    });
  }

  @override
  void initState() {
    super.initState();
    getGMT();
  }

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
                "Detail Attendance",
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
      body: BlocBuilder<AttendanceDetailBloc, AttendanceDetailState>(
        builder: (context, state) {
          if (state is AttendanceDetailLoading) {
            // While waiting for the result, you can show a loading indicator.
            // return const CircularProgressIndicator();
            return Text(
              'Loading',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            );
          } else if (state is AttendanceDetailLoadSuccess) {
            Attendance attendance = state.attendance;
            return attendance.check_in != "" || attendance.check_out != ""
                ? ListView(
                    children: [
                      attendance.check_in != ""
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 25),
                                  child: Center(
                                    child: Text(
                                      "Check-In",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: FlutterMap(
                                          options: MapOptions(
                                            center: LatLng(
                                              attendance.check_in_latitude,
                                              attendance.check_in_longitude,
                                            ),
                                            zoom: 14,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName:
                                                  'com.comtelindo.app',
                                            ),
                                            attendance.check_in_latitude != 0
                                                ? MarkerLayer(
                                                    markers: [
                                                      Marker(
                                                        child: const Icon(Icons
                                                            .location_on_outlined),
                                                        point: LatLng(
                                                            attendance
                                                                .check_in_latitude,
                                                            attendance
                                                                .check_in_longitude),
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              "assets/loading.gif"),
                                          image: NetworkImage(attendance
                                                      .check_in_file !=
                                                  ""
                                              ? attendance.check_in_file
                                              : "https://erp.comtelindo.com/sense/media/avatars/blank.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  width: double.maxFinite,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Waktu Clock In",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          attendance.check_in != ""
                                              ? formatDateToHourTime(
                                                  attendance.check_in, gmt)
                                              : "-",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  width: double.maxFinite,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Shift",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          attendance.shift_name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Jadwal Shift",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          attendance.date,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  width: double.maxFinite,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Lokasi",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launch(
                                                "https://www.google.com/maps/search/?api=1&query=${attendance.check_in_latitude},${attendance.check_in_longitude}");
                                          },
                                          child: Text(
                                            "Lihat Lokasi",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 25),
                              child: Center(
                                child: Text(
                                  "Belum Check-In nih.. 💼",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                      attendance.check_out != ""
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, top: 25),
                                  child: Center(
                                    child: Text(
                                      "Check-Out",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: FlutterMap(
                                          options: MapOptions(
                                            center: LatLng(
                                              attendance.check_out_latitude,
                                              attendance.check_out_longitude,
                                            ),
                                            zoom: 14,
                                          ),
                                          children: [
                                            TileLayer(
                                              urlTemplate:
                                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                              userAgentPackageName:
                                                  'com.comtelindo.app',
                                            ),
                                            attendance.check_out_latitude != 0
                                                ? MarkerLayer(
                                                    markers: [
                                                      Marker(
                                                        child: const Icon(Icons
                                                            .location_on_outlined),
                                                        point: LatLng(
                                                            attendance
                                                                .check_out_latitude,
                                                            attendance
                                                                .check_out_longitude),
                                                        width: 20,
                                                        height: 20,
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              "assets/loading.gif"),
                                          image: NetworkImage(attendance
                                                      .check_out_file !=
                                                  ""
                                              ? attendance.check_out_file
                                              : "https://erp.comtelindo.com/sense/media/avatars/blank.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  width: double.maxFinite,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Waktu Clock Out",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          attendance.check_out != ""
                                              ? formatDateToHourTime(
                                                  attendance.check_out, gmt)
                                              : "-",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  width: double.maxFinite,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Shift",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          attendance.shift_name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Jadwal Shift",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          attendance.date,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 10,
                                    left: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  width: double.maxFinite,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Lokasi",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            launch(
                                                "https://www.google.com/maps/search/?api=1&query=${attendance.check_out_latitude},${attendance.check_out_longitude}");
                                          },
                                          child: Text(
                                            "Lihat Lokasi",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 25),
                              child: Center(
                                child: Text(
                                  "Belum Check-Out nih.. 💼",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 25),
                    child: Center(
                      child: Text(
                        "Tidak ada catatan kehadiran",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
          } else {
            return Text('Error to load attendance');
          }
        },
      ),
    );
  }
}
