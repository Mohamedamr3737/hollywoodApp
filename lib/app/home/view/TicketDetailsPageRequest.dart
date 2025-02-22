import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AddCommentPageRequest.dart'; // <-- Make sure this points to your actual AddCommentPage file
import '../controller/requests_controller.dart';
class TicketDetailsPage extends StatefulWidget {
  // Pass the entire request as a Map<String, dynamic>
  final Map<String, dynamic> request;

  const TicketDetailsPage({Key? key, required this.request}) : super(key: key);

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  late Map<String, dynamic> _request;

  @override
  void initState() {
    super.initState();
    // Copy the request so we can modify it (e.g., status changes or adding comments)
    _request = Map.from(widget.request);
  }

  final RequestsController _requestsController = RequestsController();

  // Navigate to AddCommentPage, passing the ticket's ID
  // If a new comment is returned, add it to the local comments list
  Future<void> _goToAddComment() async {
    final ticketId = _request['id']?.toString() ?? '';
    if (ticketId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No valid ticket ID")),
      );
      return;
    }

    final newComment = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => AddCommentPage(ticketId: ticketId),
      ),
    );

    // If the user successfully added a comment and we got back a Map
    // that looks like { "id": 72, "comment": "...", "files": [...], "by": "...", "created_at": "..." }
    if (newComment != null) {
      // EITHER re-fetch from server or just append locally

      // 1) Re-fetch from server (if you have a fetchSingleTicket API):
      await _requestsController.fetchMyRequests(int.tryParse(ticketId.toString()) ?? 0);

      // 2) OR just append the new comment to the local list:
      final commentsList = _request['comments'] as List<dynamic>;
      commentsList.add(newComment);
      setState(() {});
    }
    }


  // Example: "Close Ticket"
  // In a real app, you'd call an API to close it, then pop with updated data
  void _closeTicket() {
    setState(() {
      _request['status'] = 'Closed';
    });
    // Pop back with the updated request
    Navigator.of(context).pop(_request);
  }

  @override
  Widget build(BuildContext context) {
    // Extract fields from the request map
    final subject = _request['subject'] ?? 'No Title';
    final description = _request['description'] ?? 'No Details';
    final createdAt = _request['created_at'] ?? '';
    final status = _request['status'] ?? '';
    final files = _request['files'] as List<dynamic>? ?? [];
    final comments = _request['comments'] as List<dynamic>? ?? [];

    return Scaffold(
      body: Stack(
        children: [
          // (A) Sparkly background
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
          // (B) Lotus circle icon
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
          // (C) Custom AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.7),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.orangeAccent),
                // Return updated map if changed
                onPressed: () => Navigator.of(context).pop(_request),
              ),
              title: const Text(
                "Ticket Details",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // (D) Main content
          Positioned.fill(
            top: 240,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "Title",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    subject,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Details
                  const Text(
                    "Details",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Files (if any)
                  if (files.isNotEmpty) ...[
                    const Text(
                      "Files",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    // Display each file link with a shortened name
                    ...files.map((f) {
                      final link = f['link']?.toString() ?? '';
                      return FileItem(fileLink: link);
                    }).toList(),
                    const SizedBox(height: 8),
                  ],

                  // Date
                  const Text("Date", style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(
                    createdAt,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Status
                  const Text("Status", style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(
                    status,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  // Comments
                  const Text(
                    "Comments",
                    style: TextStyle(fontSize: 18, color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  comments.isEmpty
                      ? const Text(
                    "No Comments!",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  )
                      : Expanded(
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (ctx, idx) {
                        final c = comments[idx] as Map<String, dynamic>;
                        final commentText = c['comment'] ?? '';
                        final commentFiles = c['files'] as List<dynamic>? ?? [];
                        final commentBy = c['by'] ?? '';
                        final commentDate = c['created_at'] ?? '';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // The comment text
                              Text(
                                commentText,
                                style: const TextStyle(fontSize: 16),
                              ),
                              // The comment files, if any
                              if (commentFiles.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: commentFiles.map((cf) {
                                    final fileLink = cf['link']?.toString() ?? '';
                                    return SizedBox(
                                      width: 120,
                                      child: FileItem(fileLink: fileLink),
                                    );
                                  }).toList(),
                                ),
                              ],
                              const SizedBox(height: 4),
                              // Who posted it & when
                              Text(
                                "By: $commentBy on $commentDate",
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // (E) Bottom buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // "New comment" button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _goToAddComment,
                      child: const Text(
                        "New comment",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // "Close Ticket" button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _closeTicket,
                      child: const Text(
                        "Close Ticket",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

// Displays a file link with a shortened name and opens on tap
class FileItem extends StatelessWidget {
  final String fileLink;

  const FileItem({Key? key, required this.fileLink}) : super(key: key);

  Future<void> _openFile() async {
    final uri = Uri.parse(fileLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $fileLink");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract just the file name from the URL
    final fileName = fileLink.split('/').last;

    return GestureDetector(
      onTap: _openFile,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file, size: 18),
            const SizedBox(width: 4),
            // Use a ConstrainedBox + ellipsis to shorten the name
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 80),
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
