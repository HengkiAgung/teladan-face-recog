import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/bloc/approval_assignment_detail/approval_assignment_detail_bloc.dart';
import 'package:teladan/bloc/approval_assignment_list/approval_assignment_list_bloc.dart';
import 'package:teladan/bloc/notification_badge/notification_badge_bloc.dart';
import 'package:teladan/config.dart';
import 'package:teladan/models/Assignment/Assignment.dart';
import 'package:teladan/page/inbox/approval/assignment/detail_assignment_approval_page.dart';
import 'package:teladan/utils/middleware.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:teladan/utils/helper.dart';

class AssignmentApprovalPage extends StatefulWidget {
  const AssignmentApprovalPage({super.key});

  @override
  State<AssignmentApprovalPage> createState() => _AssignmentApprovalPageState();
}

class _AssignmentApprovalPageState extends State<AssignmentApprovalPage> {
  List<Assignment> _userAssignmentApproval = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<ApprovalAssignmentListBloc>().add(
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
    final userAssignmentApproval =
        BlocProvider.of<ApprovalAssignmentListBloc>(context);
    if (userAssignmentApproval.state is! ApprovalAssignmentListLoadSuccess) {
      Middleware().authenticated(context);

      context
          .read<ApprovalAssignmentListBloc>()
          .add(const GetApprovalAssigment());
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
            child: BlocBuilder<ApprovalAssignmentListBloc,
                ApprovalAssignmentListState>(
              builder: (context, state) {
                if (state is ApprovalAssignmentListLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 18),
                    child: Text("loading..."),
                  );
                } else if (state is ApprovalAssignmentListLoadFailure) {
                  return const Text("Failed to load attendance log");
                } else if (state is ApprovalAssignmentListLoadSuccess) {
                  _userAssignmentApproval = state.request.cast<Assignment>();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<ApprovalAssignmentListBloc>()
                        .add(const GetApprovalAssigment());
                    context
                        .read<NotificationBadgeBloc>()
                        .add(UpdateAssignmetNotification());
                    setState(() {
                      page = 1;
                    });
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _userAssignmentApproval.length > 9
                              ? _scrollController
                              : null,
                          itemCount: _userAssignmentApproval.length,
                          itemBuilder: (BuildContext context, int index) {
                            var userAssignmentApproval =
                                _userAssignmentApproval[index];
                            Color colorStatus;

                            if (userAssignmentApproval.status == "Waiting") {
                              colorStatus = Colors.amber;
                            } else if (userAssignmentApproval.status ==
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
                                      .read<ApprovalAssignmentDetailBloc>()
                                      .add(GetRequestAssigmentDetail(
                                          id: userAssignmentApproval.id));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailAssignmentApprovalPage(
                                              id: userAssignmentApproval.id),
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
                                            truncateWithEllipsis(30,
                                                userAssignmentApproval.name),
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 51, 51, 51),
                                            ),
                                          ),
                                          userAssignmentApproval.start_date !=
                                                  ""
                                              ? Text(
                                                  "Tanggal mulai: ${userAssignmentApproval.start_date}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          userAssignmentApproval.end_date != ""
                                              ? Text(
                                                  "Sampai pada: ${userAssignmentApproval.end_date}",
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
                                            userAssignmentApproval.status,
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
                      (state is ApprovalAssignmentListFetchNew)
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
            onTap: () async {
              final Uri url =
                  Uri.parse('${Config.url}/operation/assignment/create');
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
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
                'Create Assignment',
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
