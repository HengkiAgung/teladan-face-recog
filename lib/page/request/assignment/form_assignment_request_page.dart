// ignore_for_file: prefer_final_fields, non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/bloc/request_assignment_list/request_assignment_list_bloc.dart';
import 'package:teladan/components/modal_bottom_sheet_component.dart';
import 'package:teladan/models/Employee/User.dart';
import 'package:teladan/repositories/request_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class FormAssignmentRequestPage extends StatefulWidget {
  const FormAssignmentRequestPage({super.key});

  @override
  State<FormAssignmentRequestPage> createState() =>
      _FormAssignmentRequestPageState();
}

class _FormAssignmentRequestPageState extends State<FormAssignmentRequestPage> {
  List<User>? signedBy;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  String? _signedById;
  double lat = -1.2497202;
  double long = 116.8772024;
  List work_schedule = [];

  final TextEditingController _nameAssignmetController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  bool onSubmit = true;

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
                "Request Assignment",
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
      bottomNavigationBar: Container(
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
        child: InkWell(
          onTap: () async {
            if (_signedById == null) {
              ModalBottomSheetComponent()
                  .errorIndicator(context, "Signed By wajib diisi!");
            } else {
              bool request = await RequestRepository().makeAssignmentRequest(
                context: context,
                signed_by: _signedById!,
                start_date: _startDate,
                end_date: _endDate,
                override_holiday: "1",
                name: _nameAssignmetController.text,
                location: _locationController.text,
                latitude: lat.toString(),
                longitude: long.toString(),
                working_start: "00:02",
                working_end: "23:58",
                radius: "1000",
                purpose: _purposeController.text,
                work_schedule: work_schedule,
              );

              if (request) {
                Navigator.pop(context);
                context
                    .read<RequestAssignmentListBloc>()
                    .add(const GetRequestAssigment());
                showModalBottomSheet<void>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 14, left: 14, bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "Surat Tugas berhasil diajukan",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Kirim',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
          future: RequestRepository().getCreateDataAssignment(),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the result, you can show a loading indicator.
              // return const CircularProgressIndicator();
              return Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 36,
                  bottom: 36,
                ),
                child: const Text('Loading'),
              );
            } else if (snapshot.hasError) {
              // Handle the error case here.
              return Text('Error: ${snapshot.error}');
            } else {
              signedBy = (snapshot.data![0] as List<dynamic>).map((e) {
                var user = User.fromJson(e);
                return user;
              }).toList();

              work_schedule = snapshot.data![1];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Form Pengajuan Surat Tugas",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 51, 51, 51),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(Icons.assignment,
                            color: Color.fromARGB(255, 109, 109, 109)),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _nameAssignmetController,
                              obscureText: false,
                              decoration: const InputDecoration(
                                labelText: 'Nama Penugasan',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(Icons.calendar_month,
                            color: Color.fromARGB(255, 109, 109, 109)),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                              );

                              if (newDate == null) return;
                              setState(() => _startDate = newDate);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.5,
                                    color: Color.fromARGB(160, 158, 158, 158),
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal Mulai",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${_startDate.year}/${_startDate.month}/${_startDate.day}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(Icons.calendar_month,
                            color: Color.fromARGB(255, 109, 109, 109)),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2025),
                              );

                              if (newDate == null) return;
                              setState(() => _endDate = newDate);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 0.5,
                                    color: Color.fromARGB(160, 158, 158, 158),
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tanggal Selesai",
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${_endDate.year}/${_endDate.month}/${_endDate.day}",
                                    // '',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(Icons.location_on_outlined,
                            color: Color.fromARGB(255, 109, 109, 109)),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Color.fromARGB(160, 158, 158, 158),
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: _locationController,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    labelText: 'Lokasi',
                                  ),
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     ElevatedButton(
                              //       style: ButtonStyle(
                              //         backgroundColor:
                              //             MaterialStateProperty.all<Color>(
                              //                 Colors.amber),
                              //       ),
                              //       onPressed: () async {},
                              //       child: Text(
                              //         "Pick Coordinate",
                              //         style: GoogleFonts.poppins(
                              //           fontSize: 15,
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //     ),
                              //     const SizedBox(
                              //       width: 10,
                              //     ),
                              //     Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         Text("latitude: $lat"),
                              //         Text("longitude: $long"),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.approval_outlined,
                          color: Color.fromARGB(255, 109, 109, 109),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _signedById,
                            hint: const Text("Signed By"),
                            isExpanded: true,
                            underline: Container(
                              height: 2,
                              color: Colors.amber,
                            ),
                            onChanged: (value) {
                              // This is called when the user selects an item.
                              setState(() {
                                _signedById = value!;
                              });
                            },
                            items: signedBy!
                                .map<DropdownMenuItem<String>>((User value) {
                              return DropdownMenuItem<String>(
                                value: value.id.toString(),
                                child: Text(value.name),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(Icons.signpost,
                            color: Color.fromARGB(255, 109, 109, 109)),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                  color: Color.fromARGB(160, 158, 158, 158),
                                ),
                              ),
                            ),
                            child: TextField(
                              controller: _purposeController,
                              obscureText: false,
                              decoration: const InputDecoration(
                                labelText: 'Tujuan',
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "latitude: $lat",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "longitude: $long",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 500,
                      width: double.infinity,
                      child: OpenStreetMapSearchAndPick(
                        zoomOutIcon: Icons.zoom_out,
                        zoomInIcon: Icons.zoom_in,
                        onPicked: (onpicked) {
                          setState(() {
                            lat = onpicked.latLong.latitude;
                            long = onpicked.latLong.longitude;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
