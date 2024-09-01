import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/text_field_component.dart';
import '../../models/Employee/User.dart';
import '../../repositories/user_repository.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

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
                "Info Personal",
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
      body: FutureBuilder<User>(
        future: UserRepository().getUserPersonalData(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator.
            // return const CircularProgressIndicator();
            return const Text('Loading');
          } else if (snapshot.hasError) {
            // Handle the error case here.
            return Text('Error: ${snapshot.error}');
          } else {
            User employData = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Informasi Pribadi",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                  ),

                  // name
                  TextFieldComponent(label: 'Name', content: employData.name,),
                  const SizedBox(
                    height: 20,
                  ),

                  // email
                  TextFieldComponent(label: 'Email', content: employData.email,),
                  const SizedBox(
                    height: 20,
                  ),

                  // phone
                  TextFieldComponent(label: 'Phone Number', content: employData.kontak,),
                  const SizedBox(
                    height: 20,
                  ),

                  // placeOfBirth
                  TextFieldComponent(label: 'Place of Birth', content: employData.userPersonalData != null ? employData.userPersonalData!.place_of_birth : "-",),
                  const SizedBox(
                    height: 20,
                  ),

                  // birthdate
                  TextFieldComponent(label: 'Birthdate', content: employData.userPersonalData != null ? employData.userPersonalData!.birthdate : "-",),
                  const SizedBox(
                    height: 20,
                  ),

                  // maritalStatus
                  TextFieldComponent(label: 'Marital Status', content: employData.userPersonalData != null ? employData.userPersonalData!.marital_status : "-",),
                  const SizedBox(
                    height: 20,
                  ),

                  // gender
                  TextFieldComponent(label: 'Gender', content: employData.userPersonalData != null ? employData.userPersonalData!.gender : "-",),
                  const SizedBox(
                    height: 20,
                  ),

                  // religion
                  TextFieldComponent(label: 'Religion', content: employData.userPersonalData != null ? employData.userPersonalData!.religion : "-",),
                  const SizedBox(
                    height: 20,
                  ),

                  // bloodType
                  TextFieldComponent(label: 'Blood Type', content: employData.userPersonalData != null ? employData.userPersonalData!.blood_type : "-",),
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
