import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teladan/bloc/leave_history/leave_history_bloc.dart';
import 'package:teladan/models/Leave/UserLeaveHistory.dart';
import 'package:teladan/utils/middleware.dart';

class LeaveHistoryPage extends StatefulWidget {
  const LeaveHistoryPage({super.key});

  @override
  State<LeaveHistoryPage> createState() => _LeaveHistoryPageState();
}

class _LeaveHistoryPageState extends State<LeaveHistoryPage> {
    List<UserLeaveHistory> _userLeaveHistory = [];

  late ScrollController _scrollController;
  int page = 1;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
          page = page + 1;
      context.read<LeaveHistoryBloc>().add(
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
    final leaveHistory = BlocProvider.of<LeaveHistoryBloc>(context);
    if (leaveHistory.state is! LeaveHistoryLoadSuccess) {
      Middleware().authenticated(context);

      context.read<LeaveHistoryBloc>().add(GetLeaveHistory());
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
                "Histori Kuota Cuti",
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
      body: BlocBuilder<LeaveHistoryBloc, LeaveHistoryState>(
        builder: (context, state) {
          if (state is LeaveHistoryLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 18.0, left: 18),
              child: Text("loading..."),
            );
          } else if (state is LeaveHistoryLoadFailure) {
            return const Text("Failed to load history quota");
          } else if (state is LeaveHistoryLoadSuccess) {
            _userLeaveHistory = state.userLeaveHistory;
          }

          return RefreshIndicator(
            onRefresh: () async {
              Middleware().authenticated(context);

              context.read<LeaveHistoryBloc>().add(GetLeaveHistory());
              setState(() {
                page = 1;
              });
            },
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _userLeaveHistory.length > 9 ? _scrollController : null,
                    itemCount: _userLeaveHistory.length,
                    itemBuilder: (BuildContext context, int index) {
                      var leaveHistory = _userLeaveHistory[index];
                      var taken = "";
                      var color = Colors.white;
                      if (leaveHistory.type == "plus") {
                        taken = "+ ${leaveHistory.quota_change} days";
                        color = Colors.green;
                      } else {
                        taken = "- ${leaveHistory.quota_change} days";
                        color = Colors.red;
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          top: 10,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(color: color),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 2,
                                offset:
                                    const Offset(0, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  leaveHistory.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  leaveHistory.date,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  taken,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                (state is LeaveHistoryFetchNew)
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
    );
  }
}