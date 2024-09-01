import 'package:teladan/models/Employee/UserEmployment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/text_field_component.dart';
import '../../repositories/user_repository.dart';

class EmploymentPage extends StatelessWidget {
  const EmploymentPage({super.key});

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
                "Info Pekerjaan",
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
      body: FutureBuilder<UserEmployment>(
        future: UserRepository().getUserEmploymentData(),
        builder: (BuildContext context, AsyncSnapshot<UserEmployment> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator.
            // return const CircularProgressIndicator();
            return const Text('Loading');
          } else if (snapshot.hasError) {
            // Handle the error case here.
            return Text('Error: ${snapshot.error}');
          } else {
            final UserEmployment employData = snapshot.data!;

            return Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Informasi Pekerjaan",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                  ),

                  TextFieldComponent(label: 'Employee ID', content: employData.employee_id,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Employment Status', content: employData.employmentStatus.name,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Join Date', content: employData.join_date,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'End Status Date', content: employData.end_date,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Team', content: employData.user!.team != null ? employData.user!.team!.team_name: "",),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Branch', content: employData.subBranch.name,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Organization', content: employData.user!.department!.department_name,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Job Position', content: employData.user!.division!.divisi_name,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Job Level', content: employData.user!.roles![0].name,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Schedule', content: employData.workingSchedule.name),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Approval Line', content: employData.approvalLine.name,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Barcode', content: employData.barcode,),
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