import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/AppointmentsController.dart';

class RequestAppointmentPage extends StatefulWidget {
  final Function(Map<String, String>) onAppointmentAdded;

  const RequestAppointmentPage({
    Key? key,
    required this.onAppointmentAdded,
  }) : super(key: key);

  @override
  State<RequestAppointmentPage> createState() => _RequestAppointmentPageState();
}

class _RequestAppointmentPageState extends State<RequestAppointmentPage> {
  final TextEditingController _appointmentNameCtrl = TextEditingController();
  final TextEditingController _dateCtrl = TextEditingController();

  // Selected values.
  String? selectedDate;
  String? selectedDepartment;
  String? selectedDoctor;
  String? selectedService;
  String? selectedTime;
  String? selectedBranch;

  // Static branch options and mapping.
  final List<String> branchOptions = ["Heliopolis", "Branch X", "Branch Y"];
  final Map<String, int> branchMap = {
    "Heliopolis": 1,
    "Branch X": 2,
    "Branch Y": 3,
  };

  // Instantiate the AppointmentsController.
  final AppointmentsController settingController = Get.put(AppointmentsController());

  @override
  void dispose() {
    _appointmentNameCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  // Helper to format a two-digit integer.
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Return available time strings based on the selected department and doctor.
  List<String> getAvailableTimes() {
    if (selectedDepartment == null || selectedDoctor == null) return [];
    final department = settingController.settings.firstWhere(
          (dept) => dept['title'] == selectedDepartment,
      orElse: () => {},
    );
    if (department.isEmpty) return [];
    final doctors = List<Map<String, dynamic>>.from(department['doctor'] ?? []);
    final doctor = doctors.firstWhere(
          (doc) => doc['name'] == selectedDoctor,
      orElse: () => {},
    );
    if (doctor.isEmpty) return [];
    final times = List<Map<String, dynamic>>.from(doctor['times'] ?? []);
    return times.map((t) => t['value'].toString()).toList();
  }

  /// Return available doctor names for the selected department.
  List<String> getAvailableDoctors() {
    if (selectedDepartment == null) return [];
    final department = settingController.settings.firstWhere(
          (dept) => dept['title'] == selectedDepartment,
      orElse: () => {},
    );
    if (department.isEmpty) return [];
    final doctors = List<Map<String, dynamic>>.from(department['doctor'] ?? []);
    return doctors.map((doc) => doc['name'].toString()).toList();
  }

  /// Return available service titles for the selected department.
  List<String> getAvailableServices() {
    if (selectedDepartment == null) return [];
    final department = settingController.settings.firstWhere(
          (dept) => dept['title'] == selectedDepartment,
      orElse: () => {},
    );
    if (department.isEmpty) return [];
    final services = List<Map<String, dynamic>>.from(department['service'] ?? []);
    return services.map((s) => s['title'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            // Appointment Name.
            TextFormField(
              controller: _appointmentNameCtrl,
              decoration: InputDecoration(
                labelText: "Appointment Name",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Date Field.
            _buildDateField(
              label: "Date",
              controller: _dateCtrl,
              onSelected: (val) async {
                setState(() {
                  selectedDate = val;
                  _dateCtrl.text = val;
                  selectedDepartment = null;
                  selectedDoctor = null;
                  selectedService = null;
                  selectedTime = null;
                });
                await settingController.fetchSettings(val);
              },
            ),
            const SizedBox(height: 16),
            // Department Dropdown.
            Obx(() {
              final dummy = settingController.settings.length;
              final deptOptions = settingController.settings
                  .map((dept) => dept['title'].toString())
                  .toList();
              final isEnabled = selectedDate != null && deptOptions.isNotEmpty;
              return _buildDropdownField(
                label: "Department",
                options: deptOptions,
                value: selectedDepartment,
                enabled: isEnabled,
                onChanged: (val) {
                  setState(() {
                    selectedDepartment = val;
                    selectedDoctor = null;
                    selectedService = null;
                    selectedTime = null;
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            // Doctor Dropdown.
            Obx(() {
              final dummy = settingController.settings.length;
              final doctorOptions = selectedDepartment != null
                  ? getAvailableDoctors()
                  : <String>[];
              final isEnabled = selectedDepartment != null &&
                  doctorOptions.isNotEmpty;
              return _buildDropdownField(
                label: "Doctor",
                options: doctorOptions,
                value: selectedDoctor,
                enabled: isEnabled,
                onChanged: (val) {
                  setState(() {
                    selectedDoctor = val;
                    selectedTime = null;
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            // Service Dropdown.
            Obx(() {
              final dummy = settingController.settings.length;
              final serviceOptions = selectedDepartment != null
                  ? getAvailableServices()
                  : <String>[];
              final isEnabled = selectedDepartment != null &&
                  serviceOptions.isNotEmpty;
              return _buildDropdownField(
                label: "Service",
                options: serviceOptions,
                value: selectedService,
                enabled: isEnabled,
                onChanged: (val) {
                  setState(() {
                    selectedService = val;
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            // Time Dropdown.
            Obx(() {
              final dummy = settingController.settings.length;
              final timeOptions = selectedDoctor != null
                  ? getAvailableTimes()
                  : <String>[];
              final isEnabled = selectedDoctor != null && timeOptions.isNotEmpty;
              return _buildDropdownField(
                label: "Time",
                options: timeOptions,
                value: selectedTime,
                enabled: isEnabled,
                onChanged: (val) {
                  setState(() {
                    selectedTime = val;
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            // Branch Dropdown.
            _buildDropdownField(
              label: "Branch",
              options: branchOptions,
              value: selectedBranch,
              enabled: true,
              onChanged: (val) {
                setState(() {
                  selectedBranch = val;
                });
              },
            ),
            const SizedBox(height: 24),
            // Confirm Appointment Button.
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                if (_appointmentNameCtrl.text.isEmpty ||
                    selectedBranch == null ||
                    selectedDepartment == null ||
                    selectedService == null ||
                    selectedDoctor == null ||
                    selectedDate == null ||
                    selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all fields")),
                  );
                  return;
                }
                try {
                  final department = settingController.settings.firstWhere(
                          (dept) => dept['title'] == selectedDepartment);
                  final deptId = department['id'];
                  final doctor = (department['doctor'] as List)
                      .firstWhere((doc) => doc['name'] == selectedDoctor);
                  final doctorId = doctor['id'];
                  final service = (department['service'] as List)
                      .firstWhere((serv) => serv['title'] == selectedService);
                  final serviceId = service['id'];
                  final branchId = branchMap[selectedBranch!] ?? 1;

                  final success = await settingController.storeAppointment(
                    date: selectedDate!,
                    time: selectedTime!,
                    doctorId: doctorId,
                    serviceId: serviceId,
                    deptId: deptId,
                    branchId: branchId,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Appointment saved successfully")),
                    );
                    // Signal parent to refresh appointments.
                    widget.onAppointmentAdded({
                      'appointmentName': _appointmentNameCtrl.text.trim(),
                      'branch': selectedBranch!,
                      'department': selectedDepartment!,
                      'service': selectedService!,
                      'doctor': selectedDoctor!,
                      'date': selectedDate!,
                      'time': selectedTime!,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                          Text(settingController.errorMessage.value)),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              },
              child: const Text(
                "Confirm Appointment",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> options,
    String? value,
    required bool enabled,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: value,
      items: options
          .map((val) => DropdownMenuItem(
        value: val,
        child: Text(val),
      ))
          .toList(),
      onChanged: enabled ? onChanged : null,
      disabledHint: Text(value ?? "Select $label"),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onSelected,
  }) {
    return TextFormField(
      controller: controller,
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
        final now = DateTime.now();
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: DateTime(now.year - 3),
          lastDate: DateTime(now.year + 3),
        );
        if (pickedDate != null) {
          final y = pickedDate.year;
          final m = _twoDigits(pickedDate.month);
          final d = _twoDigits(pickedDate.day);
          onSelected("$y-$m-$d");
        }
      },
    );
  }
}
