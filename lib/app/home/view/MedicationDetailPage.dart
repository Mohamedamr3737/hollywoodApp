import 'package:flutter/material.dart';

class MedicationDetailPage extends StatefulWidget {
  // The entire prescription object, e.g.:
  // {
  //   "id": 5,
  //   "created_at": "2019-10-21T15:28:39.000000Z",
  //   "doctor": {"id": 2, "name": "Dr Ahmed Nassar"},
  //   "medications": [
  //     {
  //       "product_id": 2,
  //       "medication_name": "Regimax",
  //       "times": "3",
  //       "form": "Cap",
  //       "comment": "قبل الاكل"
  //     },
  //     ...
  //   ]
  // }
  final Map<String, dynamic> prescription;

  const MedicationDetailPage({
    Key? key,
    required this.prescription,
  }) : super(key: key);

  @override
  State<MedicationDetailPage> createState() => _MedicationDetailPageState();
}

class _MedicationDetailPageState extends State<MedicationDetailPage> {
  // "Set a reminder" => show a time picker
  void _setReminder() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reminder set at ${time.format(context)}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract data from the prescription map
    final docName = widget.prescription['doctor']?['name'] ?? 'Unknown Doctor';
    final medications = widget.prescription['medications'] as List<dynamic>? ?? [];

    return Scaffold(
      // Same background style
      body: Stack(
        children: [
          // top background
          Column(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: Image.network(
                  'https://images.unsplash.com/photo-1601984845798-44b10f90c361?ixlib=rb-4.0.3&w=1400&q=80',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          // lotus icon
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.network(
                  'https://cdn3.iconfinder.com/data/icons/zen-2/100/Lotus_5-512.png',
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // custom appbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                docName, // show the doctor's name in the title
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.lock, color: Colors.orangeAccent),
                  onPressed: () {
                    // maybe "lock" the prescription? Just a sample icon
                  },
                )
              ],
            ),
          ),
          // content
          Positioned.fill(
            top: 240,
            child: medications.isEmpty
                ? const Center(
              child: Text(
                "No Medication Found!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: medications.length,
              itemBuilder: (ctx, i) {
                final medItem = medications[i];
                final medName = medItem['medication_name'] ?? '';
                final times = medItem['times']?.toString() ?? '';
                final form = medItem['form'] ?? '';
                final comment = medItem['comment'] ?? '';

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medication
                        Text(
                          "Medication\n$medName",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Times, Form
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Times\n$times"),
                            Text("Form\n$form"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Comment
                        Text(
                          "Comment\n$comment",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        // "Set A Reminder" button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _setReminder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              "Set A Reminder",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
