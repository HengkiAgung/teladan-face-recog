import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/bloc/request_assigment_detail/request_assignment_detail_bloc.dart';
import 'package:teladan/bloc/request_assignment_list/request_assignment_list_bloc.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/page/request/assignment/detail_assignment_request_page.dart';
import 'package:teladan/page/request/assignment/form_assignment_request_page.dart';
import 'package:teladan/utils/helper.dart';

import '../../../utils/middleware.dart';

class AssignmentRequestPage extends StatefulWidget {
  const AssignmentRequestPage({super.key});

  @override
  State<AssignmentRequestPage> createState() => _AssignmentRequestPageState();
}

class _AssignmentRequestPageState extends State<AssignmentRequestPage> {
  List<Assignment> _userAssignmentRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<RequestAssignmentListBloc>().add(
            ScrollFetch(
              page: page,
            ),
          );
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
    final userAssignmentRequest =
        BlocProvider.of<RequestAssignmentListBloc>(context);
    if (userAssignmentRequest.state is! RequestAssignmentListLoadSuccess) {
      Middleware().authenticated(context);

      context
          .read<RequestAssignmentListBloc>()
          .add(const GetRequestAssigment());
    }

    return Scaffold(
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
                "Request Assigment",
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
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<RequestAssignmentListBloc,
                RequestAssignmentListState>(
              builder: (context, state) {
                if (state is RequestAssignmentListLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 18),
                    child: Text("loading..."),
                  );
                } else if (state is RequestAssignmentListLoadFailure) {
                  return const Text("Failed to load assigment log");
                } else if (state is RequestAssignmentListLoadSuccess) {
                  _userAssignmentRequest = state.request.cast<Assignment>();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<RequestAssignmentListBloc>()
                        .add(const GetRequestAssigment());
                    setState(() {
                      page = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _userAssignmentRequest.length > 9
                              ? _scrollController
                              : null,
                          itemCount: _userAssignmentRequest.length,
                          itemBuilder: (BuildContext context, int index) {
                            var userAssignmentRequest =
                                _userAssignmentRequest[index];
                            Color colorStatus;

                            if (userAssignmentRequest.status == "Waiting") {
                              colorStatus = Colors.amber;
                            } else if (userAssignmentRequest.status ==
                                "Approved") {
                              colorStatus = Colors.green;
                            } else {
                              colorStatus = Colors.red.shade900;
                            }

                            return Container(
                              padding: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                                top: 20,
                                bottom: 20,
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
                                onTap: () {
                                  Middleware().authenticated(context);

                                  context
                                      .read<RequestAssignmentDetailBloc>()
                                      .add(GetRequestAssigmentDetail(
                                          id: userAssignmentRequest.id));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailAssignmentRequestPage(
                                              id: userAssignmentRequest.id),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            truncateWithEllipsis(
                                                30, userAssignmentRequest.name),
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 51, 51, 51),
                                            ),
                                          ),
                                          userAssignmentRequest.start_date != ""
                                              ? Text(
                                                  "Tanggal mulai: ${userAssignmentRequest.start_date}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          userAssignmentRequest.end_date != ""
                                              ? Text(
                                                  "Sampai pada: ${userAssignmentRequest.end_date}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          const SizedBox(),
                                          Text(
                                            "Status",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            userAssignmentRequest.status,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              color: colorStatus,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.more_vert),
                                      const SizedBox(
                                        width: 12,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      (state is RequestAssignmentListFetchNew)
                          ? const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 40,
                                child: Text("Loading..."),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormAssignmentRequestPage(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Ajukan Assignment',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
