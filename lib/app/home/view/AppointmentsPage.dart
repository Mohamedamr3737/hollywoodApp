// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // List to store appointments
  List<Map<String, String>> appointments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with AppBar overlay
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcRElHzS7DF6u04X-Y0OPLE2YkIIcaI6XjbB5K5atLN_ZCPg_Un9',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 100), // Space for circular profile image
            ],
          ),
          // Positioned Circular Image
          Positioned(
            top: 140,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSEa7ew_3UY_z3gT_InqdQmimzJ6jC3n2WgRpMUN9yekVsUxGIg', // Replace with actual profile image URL
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            top: 280,
            child: Column(
              children: [
                // Tabs Header
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.orangeAccent,
                  labelColor: Colors.orangeAccent,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "My Appointments"),
                    Tab(text: "Request Appointment"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      MyAppointmentsPage(appointments: appointments),
                      RequestAppointmentPage(onAppointmentAdded: (appointment) {
                        setState(() {
                          appointments.add(appointment);
                        });
                        _tabController
                            .animateTo(0); // Navigate to My Appointments
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Custom AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.6),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text(
                "Appointments",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
        ],
      ),
    );
  }
}

// My Appointments Page
class MyAppointmentsPage extends StatelessWidget {
  final List<Map<String, String>> appointments;

  const MyAppointmentsPage({Key? key, required this.appointments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return appointments.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Icon(
                  Icons.event_note,
                  size: 150,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Empty Appointments!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text("Service: ${appointment['service']}"),
                  subtitle: Text(
                      "Doctor: ${appointment['doctor']}\nDate: ${appointment['date']}"),
                  trailing: Text("Time: ${appointment['time']}"),
                ),
              );
            },
          );
  }
}

// Request Appointment Page
class RequestAppointmentPage extends StatefulWidget {
  final Function(Map<String, String>) onAppointmentAdded;

  const RequestAppointmentPage({Key? key, required this.onAppointmentAdded})
      : super(key: key);

  @override
  State<RequestAppointmentPage> createState() => _RequestAppointmentPageState();
}

class _RequestAppointmentPageState extends State<RequestAppointmentPage> {
  String? selectedBranch;
  String? selectedDepartment;
  String? selectedService;
  String? selectedDoctor;
  String? selectedDate;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildDropdownField("Branch", ["Heliopolis"],
              (value) => setState(() => selectedBranch = value)),
          const SizedBox(height: 16),
          _buildDropdownField(
              "Department",
              ["Skin Care", "Slimming", "Beauty", "Nutrition"],
              (value) => setState(() => selectedDepartment = value)),
          const SizedBox(height: 16),
          _buildDropdownField(
              "Service",
              ["First Nutrition", "Nutrition follow up"],
              (value) => setState(() => selectedService = value)),
          const SizedBox(height: 16),
          _buildDropdownField("Doctor", [""],
              (value) => setState(() => selectedDoctor = value)),
          const SizedBox(height: 16),
          _buildDateField(
              context, "Date", (value) => setState(() => selectedDate = value)),
          const SizedBox(height: 16),
          _buildTimeField(
              context, "Time", (value) => setState(() => selectedTime = value)),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              if (selectedBranch != null &&
                  selectedDepartment != null &&
                  selectedService != null &&
                  selectedDoctor != null &&
                  selectedDate != null &&
                  selectedTime != null) {
                widget.onAppointmentAdded({
                  'branch': selectedBranch!,
                  'department': selectedDepartment!,
                  'service': selectedService!,
                  'doctor': selectedDoctor!,
                  'date': selectedDate!,
                  'time': selectedTime!,
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Appointment Confirmed Successfully")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all fields")));
              }
            },
            child: const Text(
              "Confirm Appointment",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> options, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, ValueChanged<String> onSelected) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          onSelected(pickedDate.toIso8601String().split('T').first);
        }
      },
    );
  }

  Widget _buildTimeField(
      BuildContext context, String label, ValueChanged<String> onSelected) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          onSelected("${pickedTime.hour}:${pickedTime.minute}");
        }
      },
    );
  }
}
