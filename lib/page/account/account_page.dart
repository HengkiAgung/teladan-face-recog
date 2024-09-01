// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/page/account/employment_page.dart';
import 'package:teladan/utils/auth.dart';
import 'package:teladan/utils/middleware.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/user/user_bloc.dart';
import '../../components/avatar_profile_component.dart';
import 'personal_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final account = BlocProvider.of<UserBloc>(context);

    if (account.state is! UserLoadSuccess) {
      Middleware().authenticated(context);
    }
    return ListView(
      children: [
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Text('Loading...');
            } else if (state is UserLoadSuccess) {
                return AvatarProfileComponent(
                  user: state.user,
                );
            }
            return const Text('Failed to load user data');
          },
        ),

        // Info Saya
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Info Saya",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 51, 51, 51),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Info Personal
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.account_circle),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info Personal',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                        Text(
                          'Informasi pribadi',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Info Pekerjaan
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmploymentPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.perm_contact_cal_rounded),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Info Pekerjaan',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 51, 51, 51),
                          ),
                        ),
                        Text(
                          'Informasi terkait pekerjaan atau kantor',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Info payroll
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const PayrollPage(),
              //       ),
              //     );
              //   },
              //   child: Row(
              //     children: [
              //       Icon(Icons.payments_rounded),
              //       const SizedBox(
              //         width: 12,
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Info payroll',
              //             style: GoogleFonts.poppins(
              //               fontSize: 13,
              //               fontWeight: FontWeight.bold,
              //               color: Color.fromARGB(255, 51, 51, 51),
              //             ),
              //           ),
              //           Text(
              //             'Dafter anggota keluarga karyawan',
              //             style: GoogleFonts.poppins(
              //               fontSize: 11,
              //               color: Colors.grey,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        // kujungi web
        GestureDetector(
          onTap: () {
            launch("https://erp.comtelindo.com/");
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.web_asset),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Kunjungi website',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        // Privacy Policy
        GestureDetector(
          onTap: () => launch("https://erp.comtelindo.com/privacy"),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.privacy_tip_outlined),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Privacy Policy',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),

        // Log Out
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Auth().logOut(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Log Out',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 51, 51),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
