import 'package:flutter/material.dart';

class Ticket {
  String id;
  String category; // "Ask Doctor", etc.
  String title;
  String details;
  String? filePath; // e.g. "Document.pdf" or null
  String date; // e.g. "2025-02-19 03:04 PM"
  String status; // "open", "Resolved", "Closed", "Closed by cu"
  List<Comment> comments = [];

  Ticket({
    required this.id,
    required this.category,
    required this.title,
    required this.details,
    this.filePath,
    required this.date,
    required this.status,
  });
}

class Comment {
  String message;
  String? filePath; // e.g. "Photo.png"
  String date; // e.g. "2025-02-19 03:06 PM"

  Comment({
    required this.message,
    this.filePath,
    required this.date,
  });
}

class AddTicketPage extends StatefulWidget {
  final String category;

  const AddTicketPage({Key? key, required this.category}) : super(key: key);

  @override
  State<AddTicketPage> createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _detailsCtrl = TextEditingController();
  String? attachedFile;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _detailsCtrl.dispose();
    super.dispose();
  }

  void _pickDocument() {
    setState(() {
      attachedFile = "document.pdf";
    });
  }

  void _pickMedia() {
    setState(() {
      attachedFile = "photo.png";
    });
  }

  void _createTicket() {
    if (_titleCtrl.text.isEmpty || _detailsCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Build a new Ticket
    final now = DateTime.now();
    final dateString = "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} "
        "${_twoDigits(now.hour)}:${_twoDigits(now.minute)} ${now.hour < 12 ? 'AM' : 'PM'}";

    final newTicket = Ticket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: widget.category,
      title: _titleCtrl.text.trim(),
      details: _detailsCtrl.text.trim(),
      filePath: attachedFile,
      date: dateString,
      status: "open",
    );

    Navigator.of(context).pop(newTicket);
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sparkly background
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
          // Lotus
          Positioned(
            top: 100,
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
                "Add Ticket",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // Form
          Positioned.fill(
            top: 240,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(
                      labelText: "Title",
                      hintText: "Enter title",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Details
                  TextFormField(
                    controller: _detailsCtrl,
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Details",
                      hintText: "Enter details",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Attach file
                  Row(
                    children: [
                      const Text("Attached file"),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _pickDocument,
                        child: const Text("Document",
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _pickMedia,
                        child: const Text("Media",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  if (attachedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        attachedFile!,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createTicket,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Add new ticket",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}