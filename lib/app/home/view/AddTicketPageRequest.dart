// add_ticket_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../controller/requests_controller.dart';

class AddTicketPage extends StatefulWidget {
  final String category;

  const AddTicketPage({Key? key, required this.category}) : super(key: key);

  @override
  State<AddTicketPage> createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _detailsCtrl = TextEditingController();
  final RequestsController _requestsController = RequestsController();

  // We'll store up to 2 file paths: doc + media
  List<String> _filePaths = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _detailsCtrl.dispose();
    super.dispose();
  }

  // Example function to map category -> type_id
  // Adjust as needed if your app has a real mapping
  // Convert your category string to the type ID used by the API
  int _mapCategoryToTypeId(String category) {
    switch (category) {
      case "Ask Doctor":
        return 3;
      case "Sessions":
        return 2;
      case "Appointment":
        return 1; // Adjust if needed
      default:
        return 0; // Fallback or handle other categories
    }
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        // We'll just store it as the first file path
        _filePaths.add(result.files.first.path!);
      });
    }
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePaths.add(result.files.first.path!);
      });
    }
  }

  Future<void> _createTicket() async {
    final title = _titleCtrl.text.trim();
    final details = _detailsCtrl.text.trim();

    if (title.isEmpty || details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final typeId = _mapCategoryToTypeId(widget.category);

      // Call createTicket in your RequestsController
      final responseJson = await _requestsController.createTicket(
        typeId: typeId,
        subject: title,
        description: details,
        filePaths: _filePaths,
      );

      // On success, the server returns { "data": { "id":..., "status":..., ... }, "status":true }
      final newTicket = responseJson['data']; // e.g. { "id":59, "status":"open", ... }

      // Return the newly created ticket data to the previous page
      Navigator.of(context).pop(newTicket);

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Same sparkly background + lotus style
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
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    if (_errorMessage != null) ...[
                      Text(
                        "Error: $_errorMessage",
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                    ],
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
                        const Text("Attach files"),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _pickDocument,
                          child: const Text("Document", style: TextStyle(color: Colors.white)),
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
                          child: const Text("Media", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    if (_filePaths.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _filePaths.map((path) {
                            final fileName = path.split('/').last;
                            return Text(
                              fileName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black54),
                            );
                          }).toList(),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
