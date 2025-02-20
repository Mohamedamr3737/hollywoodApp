// prescription_flow.dart
import 'package:flutter/material.dart';

// --------------------------------------------------------------
// 1) PrescriptionPage (Main) - has a tab bar: "Diet" & "Medication"
// --------------------------------------------------------------
class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 2 tabs: Diet & Medication
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // We'll replicate your background + AppBar + 2 tabs style
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // (A) Background image at top
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Image.network(
                  'https://images.unsplash.com/photo-1601984845798-44b10f90c361?ixlib=rb-4.0.3&w=1400&q=80',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          // (B) AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.6),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                "My Prescriptions",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // (C) Circular lotus icon
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
          // (D) Tab bar (Diet, Medication) with tab views
          Positioned.fill(
            top: 240,
            child: Column(
              children: [
                _buildCustomTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      DietTab(),        // shows diet prescriptions
                      MedicationTab(),  // shows medication prescriptions
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // A custom tab bar that matches your style
  Widget _buildCustomTabBar() {
    return Container(
      color: const Color(0xFF000610),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.index = 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: _tabController.index == 0 ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Diet",
                  style: TextStyle(
                    color: _tabController.index == 0 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _tabController.index = 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: _tabController.index == 1 ? Colors.orange : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Medication",
                  style: TextStyle(
                    color: _tabController.index == 1 ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------------
// 2) DietTab: lists some diet prescriptions. Tapping opens Day list
// --------------------------------------------------------------
class DietTab extends StatelessWidget {
  // Example data
  final List<Map<String, String>> diets = [
    {
      "doctor": "Dr Ahmed Nassar",
      "date": "2024-10-20",
    },
  ];

  DietTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (diets.isEmpty) {
      return const Center(
        child: Text(
          "No Diet Prescriptions",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diets.length,
      itemBuilder: (ctx, index) {
        final diet = diets[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              "Doctor\n${diet['doctor']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              "Date\n${diet['date']}",
              style: const TextStyle(fontSize: 14),
            ),
            onTap: () {
              // Navigate to DietDaysPage
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DietDaysPage(diet),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------
// 3) DietDaysPage: shows Day 1..6. Tapping => MyMealsPage
// --------------------------------------------------------------
class DietDaysPage extends StatelessWidget {
  final Map<String, String> diet;
  const DietDaysPage(this.diet, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = [1, 2, 3, 4, 5, 6]; // example

    return Scaffold(
      // We'll replicate the same style: background + top bar
      body: Stack(
        children: [
          // Top background
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
          // Lotus icon
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
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  'https://cdn3.iconfinder.com/data/icons/zen-2/100/Lotus_5-512.png',
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // AppBar
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
              title: const Text(
                "My Prescriptions",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // Content
          Positioned.fill(
            top: 240,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: days.length,
              itemBuilder: (ctx, idx) {
                final dayNum = days[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text("Day $dayNum",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    onTap: () {
                      // go to MyMealsPage
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MyMealsPage(dayNum),
                        ),
                      );
                    },
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

// --------------------------------------------------------------
// 4) MyMealsPage: has sub tab bar (Breakfast, Breakfast snack, Lunch, Lunch snack, Dinner)
// --------------------------------------------------------------
class MyMealsPage extends StatefulWidget {
  final int dayNum;
  const MyMealsPage(this.dayNum, {Key? key}) : super(key: key);

  @override
  State<MyMealsPage> createState() => _MyMealsPageState();
}

class _MyMealsPageState extends State<MyMealsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Example data structure: sub-tabs
  final List<String> mealTabs = [
    "Breakfast",
    "Breakfast snack",
    "Lunch",
    "Lunch snack",
    "Dinner"
  ];
  // Example meal data for each sub-tab
  final Map<String, List<Map<String, dynamic>>> mealsData = {
    "Breakfast": [
      {"desc": "100 جم باذنجان مشوي", "cal": 30.0},
    ],
    "Breakfast snack": [
      {"desc": "تفاحة", "cal": 55.0},
    ],
    "Lunch": [
      {"desc": "1 صدر فرخة و خضار سوتيه", "cal": 298.0},
    ],
    "Lunch snack": [
      {"desc": "كوب شاي أخضر بدون سكر", "cal": 50.0},
    ],
    "Dinner": [
      {"desc": "زبادي لايت", "cal": 50.0},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: mealTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // For "Set A Reminder" we just show a demo time picker
  void _setReminder() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reminder set at ${pickedTime.format(context)}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // lotus
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
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  'https://cdn3.iconfinder.com/data/icons/zen-2/100/Lotus_5-512.png',
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // appBar
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
              title: const Text(
                "My Meals",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // content
          Positioned.fill(
            top: 240,
            child: Column(
              children: [
                _buildMealsTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: mealTabs.map((tabName) {
                      // For each sub-tab, show the meal cards
                      final meals = mealsData[tabName] ?? [];
                      if (meals.isEmpty) {
                        return Center(child: Text("No meals for $tabName."));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: meals.length,
                        itemBuilder: (ctx, idx) {
                          final meal = meals[idx];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text(
                                meal["desc"]?.toString() ?? "",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Calories\n${meal['cal']}",
                                  style: const TextStyle(fontSize: 14)),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                // "Set A Reminder" button at bottom
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: _setReminder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Set A Reminder",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sub-tab bar for MyMeals (Breakfast, Breakfast snack, Lunch, etc.)
  Widget _buildMealsTabBar() {
    return Container(
      color: const Color(0xFF000610),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.orangeAccent,
        labelColor: Colors.orangeAccent,
        unselectedLabelColor: Colors.white70,
        isScrollable: true,
        tabs: mealTabs.map((name) => Tab(text: name)).toList(),
      ),
    );
  }
}

// --------------------------------------------------------------
// 5) MedicationTab: lists medication prescriptions. Tapping => MedicationDetailPage
// --------------------------------------------------------------
class MedicationTab extends StatelessWidget {
  // Example medication data
  final List<Map<String, String>> meds = [
    {
      "doctor": "Dr Ahmed Nassar",
      "id": "med1",
    },
  ];

  MedicationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (meds.isEmpty) {
      return const Center(
        child: Text(
          "No Medication Prescriptions",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: meds.length,
      itemBuilder: (ctx, index) {
        final medItem = meds[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.orange[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              "Doctor\n${medItem['doctor']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            onTap: () {
              // go to medication detail
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => MedicationDetailPage(doctor: medItem['doctor']!),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------
// 6) MedicationDetailPage: shows the medication items, each with a "Set A Reminder"
// --------------------------------------------------------------
class MedicationDetailPage extends StatefulWidget {
  final String doctor;

  const MedicationDetailPage({Key? key, required this.doctor}) : super(key: key);

  @override
  State<MedicationDetailPage> createState() => _MedicationDetailPageState();
}

class _MedicationDetailPageState extends State<MedicationDetailPage> {
  // Example medication items
  final List<Map<String, String>> medsList = [
    {
      "medication": "vichy normaderm phytosolution",
      "times": "3",
      "form": "Amp",
      "comment": "test",
    },
    {
      "medication": "la rouch - posay anthelios 50 +",
      "times": "2",
      "form": "Amp",
      "comment": "test",
    }
  ];

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
    return Scaffold(
      // background style
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
                widget.doctor,
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
            child: medsList.isEmpty
                ? const Center(
              child: Text(
                "No Medication Found!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: medsList.length,
              itemBuilder: (ctx, i) {
                final item = medsList[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medication
                        Text(
                          "Medication\n${item['medication']}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        // Times, Form
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Times\n${item['times']}"),
                            Text("Form\n${item['form']}"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Comment
                        Text("Comment\n${item['comment']}",
                            style: const TextStyle(fontSize: 14)),
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
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
