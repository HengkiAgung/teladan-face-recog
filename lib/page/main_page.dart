// ignore_for_file: no_logic_in_create_state

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/bloc/notification_badge/notification_badge_bloc.dart';
import 'package:teladan/page/account/account_page.dart';
import 'package:teladan/page/employee/employee_page.dart';
import 'package:teladan/page/inbox/inbox_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/user/user_bloc.dart';
import 'home_page.dart';
import 'request/request_page.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  final int index;
  bool error;
  MainPage({required this.index, this.error = false, super.key});

  @override
  State<MainPage> createState() =>
      _MainPageState(bottomNavIndex: index, error: error);
}

class _MainPageState extends State<MainPage> {
  int bottomNavIndex = 0;
  String token = "";
  bool error;
  late BuildContext context;

  _MainPageState({required this.error, required this.bottomNavIndex});

  final List<Widget> _listWidget = [
    const HomePage(),
    const EmployeePage(),
    const RequestPage(),
    const InboxPage(),
    const AccountPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Karyawan',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.insert_drive_file),
      label: 'Pengajuan',
    ),
    BottomNavigationBarItem(
      icon: Stack(
        children: <Widget>[
          const Icon(Icons.move_to_inbox),
          BlocBuilder<NotificationBadgeBloc, NotificationBadgeState>(
            builder: (context, state) {
              if (state is NotificationBadgeLoading) {
                return const SizedBox();
              } else if (state is NotificationBadgeLoadSuccess) {
                var counter = state.total;

                return counter > 0
                    ? Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            counter < 10 ? '$counter' : '9+',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      label: 'Inbox',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'Account',
    ),
  ];

  void _onBottomNavBarTapped(int index) {
    setState(() {
      bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.read<UserBloc>().add(CheckAuth());
    // final user = BlocProvider.of<UserBloc>(context);

    // if (user.state is UserUnauthenticated) Auth().logOut(context);

    this.context = context;
    return Scaffold(
      body: error
          ? Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Image.asset(
                      'assets/logo-comtel-nig.png', // Replace with your logo asset path
                      width: 100.0, // Adjust the width as needed
                      height: 100.0, // Adjust the height as needed
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Teladan by Comtelindo',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Connection failed please try again',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 15.0,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          error = false;
                          // ignore: use_build_context_synchronously
                          context.read<UserBloc>().add(GetUser());
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : _listWidget[bottomNavIndex],
      bottomNavigationBar: error
          ? const SizedBox()
          : BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return const SizedBox();
                } else if (state is UserLoadSuccess) {
                  token = state.token;

                  return BottomNavigationBar(
                    backgroundColor: Colors.white,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: bottomNavIndex,
                    items: _bottomNavBarItems,
                    onTap: _onBottomNavBarTapped,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
    );
  }
}
