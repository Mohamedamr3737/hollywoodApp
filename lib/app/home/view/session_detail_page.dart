import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../general/consts/consts.dart';
import '../controller/session_controller.dart';
import 'get_prepared_page.dart';

class SessionDetailPage extends StatefulWidget {
  final Map<String, dynamic> session;

  const SessionDetailPage({super.key, required this.session});

  @override
  State<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  late Map<String, dynamic> _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  void showSetTimeDialog(BuildContext context, int sessionId) {
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController roomIdController = TextEditingController();

    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Set Session Time"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Select Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                    dateController.text =
                    pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: "Select Time",
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    selectedTime = pickedTime;
                    timeController.text =
                    "${pickedTime.hourOfPeriod}:${pickedTime.minute.toString().padLeft(2, '0')} "
                        "${pickedTime.period == DayPeriod.am ? "AM" : "PM"}";
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: roomIdController,
                decoration: const InputDecoration(
                  labelText: "Room ID",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (dateController.text.isEmpty ||
                    timeController.text.isEmpty ||
                    roomIdController.text.isEmpty) {
                  VxToast.show(context, msg: "All fields are required!");
                  return;
                }

                int roomId = int.tryParse(roomIdController.text) ?? 0;
                if (roomId == 0) {
                  VxToast.show(context, msg: "Invalid Room ID");
                  return;
                }

                SessionController sessionController = Get.find();
                bool ok= await sessionController.setSessionTime(
                  sessionId: sessionId,
                  date: dateController.text,
                  time: timeController.text,
                  roomId: roomId,
                  context: context,
                );

                // Update local session state after setting time
                if(ok) {
                  setState(() {
                    _session['date'] = dateController.text;
                    _session['time'] = timeController.text;
                  });
                }

                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = _session["complete"] == "Yes";
    String sessionTitle = _session["title"] ?? "Unknown Session";
    String sessionDate = _session["date"];
    String sessionTime = _session["time"];
    String doctorName = _session["doctor"] ?? "";
    String sessionStatus = _session["status"] ?? "Unknown";
    bool isUnused = _session["complete"] == "No";
    String noteBefore = _session["note_before"] ?? "<p>No preparation notes available.</p>";
    String noteAfter = _session["note_after"] ?? "<p>No after session notes available.</p>";
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Full Body",
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Image.network(
                'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRElHzS7DF6u04X-Y0OPLE2YkIIcaI6XjbB5K5atLN_ZCPg_Un9',
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: -50,
                child: Container(
                  width: screenWidth * 0.35,
                  height: screenWidth * 0.35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSEa7ew_3UY_z3gT_InqdQmimzJ6jC3n2WgRpMUN9yekVsUxGIg',
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- SESSION HEADER ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.grey : Colors.orange,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Session',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sessionTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              isUnused ? "unused" : "used",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "$sessionDate ${_getDayOfWeek(sessionDate)}    $sessionTime",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --- SESSION INFO ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isCompleted) ...[
                          const Text(
                            "Status",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            sessionStatus,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ] else ...[
                          const Text(
                            "Doctor",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            doctorName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- BUTTONS ---
                  if (isCompleted)
                  // If session is done, show "After Session Notes" only
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GetPreparedPage(
                              htmlContent: noteAfter,
                              header: 'After session notes',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "After Session Notes",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                  // Session is NOT completed
                    Column(
                      children: [
                        // --- SET or RESET TIME ---
                        ElevatedButton(
                          onPressed: () async {
                            final SessionController sessionController = Get.find();

                            // If there's no time or it's on hold, we set time
                            if (_session["time"].toString() == 'No time provided' ||
                                _session["time"].toString().isEmpty ||
                                _session["date"].toString() == 'No date provided' ||
                                _session["date"].toString().isEmpty ||
                                _session["status"] == "Hold") {
                              showSetTimeDialog(context, _session['id']);
                            } else {

                                final SessionController sessionController = Get.find();

                                // Wait for the method to return
                                bool isSuccess = await sessionController.cancelSessionTime(
                                  sessionId: _session['id'],
                                  context: context,
                                );

                                // Only update local state if the API call was successful
                                if (isSuccess) {
                                  setState(() {
                                    _session["date"] = "No date provided";
                                    _session["time"] = "No time provided";
                                  });
                                }

                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            (_session["time"] == 'No time provided' ||
                                _session["time"].toString().isEmpty ||
                                _session["date"] == 'No date provided' ||
                                _session["date"].toString().isEmpty ||
                                _session["status"] == "Hold")
                                ? "Set Time"
                                : "Reset Time",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // --- CANCEL SESSION ---
                        ElevatedButton(
                          onPressed: () async {
                            final SessionController sessionController = Get.find();

                            // Wait for the method to return
                            bool isSuccess = await sessionController.cancelSessionTime(
                              sessionId: _session['id'],
                              context: context,
                            );

                            print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                            print(isSuccess);

                            // Only update local state if the API call was successful
                            if (isSuccess) {
                              setState(() {
                                _session["date"] = "No date provided";
                                _session["time"] = "No time provided";
                              });
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel Session",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // --- GET PREPARED ---
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GetPreparedPage(
                                  htmlContent: noteBefore,
                                  header: 'Preparation notes',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Get Prepared",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayOfWeek(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);

      // In Dart, Sunday = 7, Monday = 1, ... so let's map properly:
      List<String> days = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      ];
      return days[parsedDate.weekday - 1];
    } catch (_) {
      return "";
    }
  }
}
