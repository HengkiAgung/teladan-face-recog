import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teladan/bloc/leave_quota/leave_quota_bloc.dart';
import 'package:teladan/page/request/time_off/detail_time_off_request_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/page/request/time_off/leave/leave_history_page.dart';

import '../../../bloc/request_detail/request_detail_bloc.dart';
import '../../../bloc/request_leavel_list/request_leave_list_bloc.dart';
import '../../../models/Attendance/UserLeaveRequest.dart';
import '../../../utils/middleware.dart';
import 'form_time_off_request_page.dart';

class TimeOffRequestPage extends StatefulWidget {
  const TimeOffRequestPage({super.key});

  @override
  State<TimeOffRequestPage> createState() => _TimeOffRequestPageState();
}

class _TimeOffRequestPageState extends State<TimeOffRequestPage> {
  List<UserLeaveRequest> _userLeaveRequest = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;
      context.read<RequestLeaveListBloc>().add(
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
    final attendanceRequest = BlocProvider.of<RequestLeaveListBloc>(context);
    if (attendanceRequest.state is! RequestLeaveListLoadSuccess) {
      Middleware().authenticated(context);

      context.read<LeaveQuotaBloc>().add(GetLeaveQuota());
      context.read<RequestLeaveListBloc>().add(const GetRequestList());
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
                "Request Time Off",
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
            child: BlocBuilder<RequestLeaveListBloc, RequestLeaveListState>(
              builder: (context, state) {
                if (state is RequestLeaveListLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 18.0, left: 18),
                    child: Text("loading..."),
                  );
                } else if (state is RequestLeaveListLoadFailure) {
                  return const Text("Failed to load time off log");
                } else if (state is RequestLeaveListLoadSuccess) {
                  _userLeaveRequest = state.request.cast<UserLeaveRequest>();
                }

                return Column(
                  children: [
                    // Show quota time off left
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LeaveHistoryPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(
                            color: const Color.fromARGB(160, 158, 158, 158),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sisa Quota Cuti",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 51, 51, 51),
                                  ),
                                ),
                                BlocBuilder<LeaveQuotaBloc, LeaveQuotaState>(
                                  builder: (context, state) {
                                    if (state is LeaveQuotaLoadSuccess) {
                                      int quota = state.quota;

                                      return Text(
                                        "$quota days",
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      );
                                    } else if (state is LeaveQuotaLoadFailure) {
                                      return Text(
                                        state.error,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.black,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_right_rounded),
                            const SizedBox(
                              width: 12,
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          Middleware().authenticated(context);

                          context
                              .read<RequestLeaveListBloc>()
                              .add(const GetRequestList());
                          setState(() {
                            page = 1;
                          });
                        },
                        child: ListView.builder(
                          controller: _userLeaveRequest.length > 9
                              ? _scrollController
                              : null,
                          itemCount: _userLeaveRequest.length,
                          itemBuilder: (BuildContext context, int index) {
                            var leaveRequest = _userLeaveRequest[index];
                            Color colorStatus;

                            if (leaveRequest.status == "Waiting") {
                              colorStatus = Colors.amber;
                            } else if (leaveRequest.status == "Approved") {
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

                                  context.read<RequestDetailBloc>().add(
                                      GetRequestDetail(
                                          id: leaveRequest.id.toString(),
                                          type: "time-off",
                                          model: UserLeaveRequest()));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailTimeOffRequestPage(
                                              id: leaveRequest.id),
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
                                            "${leaveRequest.leaveRequestCategory!.name}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(
                                                  255, 51, 51, 51),
                                            ),
                                          ),
                                          leaveRequest.approvalLine!.name != ""
                                              ? Text(
                                                  "Approved by: ${leaveRequest.approvalLine!.name}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Text(
                                            "Status",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            leaveRequest.status,
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
                    ),
                    (state is RequestLeaveListFetchNew)
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormTimeOffRequestPage(),
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
                'Ajukan Time Off',
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
