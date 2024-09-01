import 'package:teladan/page/account/payroll/bank_page.dart';
import 'package:teladan/page/account/payroll/bpjs_page.dart';
import 'package:teladan/page/account/payroll/salary_page.dart';
import 'package:teladan/page/account/payroll/tax_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

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
                "Info Payroll",
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
      body: Container(
        height: (MediaQuery.of(context).size.height) - 190,
        child: ListView(
          children: [
            // Salary
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SalaryPage(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
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
                    const Icon(Icons.payments_rounded),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Salary",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_right_rounded),
                    const SizedBox(
                      width: 12,
                    )
                  ],
                ),
              ),
            ),

            // Bank Account
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BankPage(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
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
                    const Icon(Icons.credit_card),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Bank Account",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_right_rounded),
                    const SizedBox(
                      width: 12,
                    )
                  ],
                ),
              ),
            ),

            // Tax Configuration
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaxPage(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
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
                    const Icon(Icons.list_rounded),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Tax Configuration",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_right_rounded),
                    const SizedBox(
                      width: 12,
                    )
                  ],
                ),
              ),
            ),

            // BPJS Configuration
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BpjsPage(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
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
                    const Icon(Icons.health_and_safety_outlined),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      "BPJS Configuration",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_right_rounded),
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
    );
  }
}
