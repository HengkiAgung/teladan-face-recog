import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locale_plus/locale_plus.dart';
import 'package:teladan/components/text_field_component.dart';
import 'package:teladan/models/Employee/WorkingShift.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/utils/helper.dart';

import '../../../bloc/request_shift_list/request_shift_list_bloc.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../repositories/request_repository.dart';

class FormShiftRequestPage extends StatefulWidget {
  final WorkingShift currentShift;

  FormShiftRequestPage({required this.currentShift});

  @override
  State<FormShiftRequestPage> createState() =>
      _FormShiftRequestPageState(currentShift: currentShift);
}

class _FormShiftRequestPageState extends State<FormShiftRequestPage> {
  final WorkingShift currentShift;
  _FormShiftRequestPageState({required this.currentShift});

  DateTime date = DateTime.now();
  String? working_shift_id;
  bool onSubmit = true;

  final TextEditingController _reasonController = TextEditingController();

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
                "Request Shift",
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
            if (onSubmit) {
              onSubmit = false;
              bool makeRequest = await RequestRepository().makeShiftRequest(
                context,
                date,
                working_shift_id!,
                _reasonController.text,
              );

              if (makeRequest) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                // ignore: use_build_context_synchronously
                context.read<RequestShiftListBloc>().add(GetRequestList());

                // ignore: use_build_context_synchronously
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
                                    "Shift berhasil diajukan",
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
            } else {
              onSubmit = true;
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
      body: FutureBuilder<List<WorkingShift>>(
        future: RequestRepository().getAllWorkingShift(),
        builder:
            (BuildContext context, AsyncSnapshot<List<WorkingShift>> snapshot) {
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
            
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Form Pengajuan Shift Baru",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
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
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            );

                            if (selectedDate == null) return;
                            setState(() => date = selectedDate);
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
                                  "Pilih Tanggal",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "${date.year}/${date.month}/${date.day}",
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
                      const Icon(
                        Icons.cases_outlined,
                        color: Color.fromARGB(255, 109, 109, 109),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            String token = "";
                            if (state is UserLoadSuccess) {
                              token = state.token;
                            }
                            return FutureBuilder<WorkingShift>(
                              future: RequestRepository().getCurrentShift(token: token),
                              builder: (BuildContext context, AsyncSnapshot<WorkingShift> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Text('Loading');
                                } else if (snapshot.hasError) {
                                  // Handle the error case here.
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return TextFieldComponent(
                                    label: "Current Shift",
                                    content: "${snapshot.data!.name}, ${formatHourTime(snapshot.data!.working_start, gmt)} - ${formatHourTime(snapshot.data!.working_end, gmt)}",
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
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
                        Icons.cases_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: DropdownButton<String>(
                          value: working_shift_id,
                          hint: Text("Pilih shift baru"),
                          isExpanded: true,
                          underline: Container(
                            height: 2,
                            color: Colors.amber,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              working_shift_id = value!;
                            });
                          },
                          items: snapshot.data!.map<DropdownMenuItem<String>>(
                              (WorkingShift value) {
                            return DropdownMenuItem<String>(
                              value: value.id.toString(),
                              child: Text("${value.name}, ${formatHourTime(value.working_start, gmt)} - ${formatHourTime(value.working_end, gmt)}"),
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
                      const Icon(Icons.text_snippet_outlined,
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
                            controller: _reasonController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              labelText: 'Alasan',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
