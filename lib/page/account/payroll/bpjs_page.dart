import 'package:teladan/models/Employee/UserBPJS.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/text_field_component.dart';
import '../../../repositories/user_repository.dart';

class BpjsPage extends StatelessWidget {
  const BpjsPage({super.key});

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
                "Info BPJS",
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
      body: FutureBuilder<UserBpjs>(
        future: UserRepository().getUserBpjs(),
        builder: (BuildContext context, AsyncSnapshot<UserBpjs> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator.
            // return const CircularProgressIndicator();
            return const Text('Loading');
          } else if (snapshot.hasError) {
            // Handle the error case here.
            return Text('Error: ${snapshot.error}');
          } else {
            final UserBpjs employBpjs = snapshot.data!;

            return Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Informasi Salary",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                  ),

                  TextFieldComponent(label: 'BPJS Ketenagakerjaan Number', content: employBpjs.ketenagakerjaan_number,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'NPP BPJS Ketenagakerjaan', content: employBpjs.ketenagakerjaan_npp,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'BPJS Ketenagakerjaan Date', content: employBpjs.ketenagakerjaan_date,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'BPJS Kesehatan Number', content: employBpjs.kesehatan_number,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'BPJS Kesehatan Family', content: employBpjs.kesehatan_family,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'BPJS Tanggal Kesehatan', content: employBpjs.kesehatan_date,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'BPJS Kesehatan Cost', content: employBpjs.kesehatan_cost,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'JHT Cost', content: employBpjs.jht_cost,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Jaminan Pensiun Cost', content: employBpjs.jaminan_pensiun_cost,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Jaminan Pensiun Date', content: employBpjs.jaminan_pensiun_date,),
                  SizedBox(
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