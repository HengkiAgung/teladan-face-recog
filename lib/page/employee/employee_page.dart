// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/bloc/employee_detail/employee_detail_bloc.dart';
import 'package:teladan/models/Employee/User.dart';
import 'package:teladan/page/employee/detail_employee_page.dart';
import 'package:teladan/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/employee/employee_bloc.dart';
import '../../utils/middleware.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  List<User> _userEmployment = [];
  Timer? _debounce;
  String search = "";

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<EmployeeBloc>().add(ScrollFetch(page: page, name: search));
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final employee = BlocProvider.of<EmployeeBloc>(context);

    if (employee.state is! EmployeeLoadSuccess) {
      Middleware().authenticated(context);

      context.read<EmployeeBloc>().add(GetEmployee(name: search));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Daftar Karyawan",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // input search
          Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
              top: 10,
              bottom: 10,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(134, 226, 226, 226),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari nama karyawan",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    setState(() {
                      search = value;
                    });
                    context.read<EmployeeBloc>().add(GetEmployee(name: value));
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 18),
                    child: Text("loading..."),
                  );
                } else if (state is EmployeeLoadFailure) {
                  return const Text("Failed to load employee");
                } else if (state is EmployeeLoadSuccess) {
                  _userEmployment = state.employee;
                }

                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          Middleware().authenticated(context);

                          context
                              .read<EmployeeBloc>()
                              .add(GetEmployee(name: search));
                          setState(() {
                            page = 1;
                          });
                        },
                        child: ListView.builder(
                          controller: _userEmployment.length > 9
                              ? _scrollController
                              : null,
                          itemCount: _userEmployment.length,
                          itemBuilder: (BuildContext context, int index) {
                            var user = _userEmployment[index];
                            if (user.name != "Super Admin") {
                              return Container(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                  left: 10,
                                  top: 5,
                                  bottom: 5,
                                ),
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Color.fromARGB(160, 158, 158, 158),
                                    ),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Middleware().authenticated(context);

                                            context
                                                .read<EmployeeDetailBloc>()
                                                .add(GetEmployeeDetail(
                                                    id: user.id.toString()));

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DetailEmployeePage(),
                                              ),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              user.foto_file != ""
                                                  ? CircleAvatar(
                                                      radius:
                                                          25, // Image radius
                                                      backgroundImage: NetworkImage(
                                                          "https://erp.comtelindo.com/storage/personal/avatar/${user.foto_file}"))
                                                  : const CircleAvatar(
                                                      radius:
                                                          25, // Image radius
                                                      backgroundImage: AssetImage(
                                                          "assets/profile_placeholder.jpg"),
                                                    ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    truncateWithEllipsis(
                                                        20, user.name),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 51, 51, 51),
                                                    ),
                                                  ),
                                                  Text(
                                                    user.department != null
                                                        ? user.department!
                                                            .department_name
                                                        : "",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Text(
                                                    user.division != null
                                                        ? user.division!
                                                            .divisi_name
                                                        : "",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () =>
                                              launch("tel:0${user.kontak}"),
                                          child: const Icon(Icons.phone),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              launch("mailto:${user.email}"),
                                          child: const Icon(Icons.mail_outline,
                                              size: 25, color: Colors.red),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () => launch(
                                              "https://wa.me/+62${user.kontak}"),
                                          child: const Image(
                                            height: 23,
                                            image: AssetImage(
                                                "assets/whatsapp.png"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                    (state is EmployeeFetchNew)
                        ? const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 40,
                              child: Text("Loading..."),
                            ),
                          )
                        : const SizedBox(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
