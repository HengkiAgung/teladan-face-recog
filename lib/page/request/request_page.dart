import 'package:teladan/page/request/assignment/assignment_request_page.dart';
import 'package:teladan/page/request/attendance/attendance_request_page.dart';
import 'package:teladan/page/request/shift/shift_request_page.dart';
import 'package:teladan/page/request/time_off/time_off_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 30, left: 12),
            margin: const EdgeInsetsDirectional.only(top: 20),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "Pengajuan",
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Cuti
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimeOffRequestPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendanceRequestPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShiftRequestPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AssignmentRequestPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                        const SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
