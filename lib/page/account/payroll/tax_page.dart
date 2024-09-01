import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/text_field_component.dart';
import '../../../models/Employee/UserTax.dart';
import '../../../repositories/user_repository.dart';

class TaxPage extends StatelessWidget {
  const TaxPage({super.key});

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
                "Info Tax",
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
      body: FutureBuilder<UserTax>(
        future: UserRepository().getUserTax(),
        builder: (BuildContext context, AsyncSnapshot<UserTax> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the result, you can show a loading indicator.
            // return const CircularProgressIndicator();
            return const Text('Loading');
          } else if (snapshot.hasError) {
            // Handle the error case here.
            return Text('Error: ${snapshot.error}');
          } else {
            final UserTax employTax = snapshot.data!;

            return Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Informasi Tagihan",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                  ),

                  TextFieldComponent(label: 'NPWP', content: employTax.npwp,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'PTKP Status', content: employTax.ptkp_status,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Tax Method', content: employTax.tax_method,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Tax Salary', content: employTax.tax_salary,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Taxable Date', content: employTax.taxable_date,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Employment TAX Status', content: employTax.taxStatus.name,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'Beginning Netto', content: employTax.beginning_netto,),
                  SizedBox(
                    height: 20,
                  ),

                  TextFieldComponent(label: 'PPH21 Paid', content: employTax.pph21_paid,),
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