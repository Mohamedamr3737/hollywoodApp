// requests_flow.dart
import 'package:flutter/material.dart';

/// --------------------------------------------------------------
/// 1) SelectCategoryPage
/// --------------------------------------------------------------
/// Shows three categories in orange cards. Tapping "VIEW" goes to MyRequestsPage(category: ...)
class SelectCategoryPage extends StatelessWidget {
  const SelectCategoryPage({Key? key}) : super(key: key);

  final List<String> categories = const [
    "Ask Doctor",
    "Sessions",
    "special inquiry",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // (A) Background sparkly image
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
          // (B) Circle lotus icon
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
                  )
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
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                "Select Category",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // (D) Content: The category cards
          Positioned.fill(
            top: 240,
            child: ListView.builder(
              itemCount: categories.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (ctx, index) {
                final catName = categories[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      catName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to MyRequestsPage, passing the category
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MyRequestsPage(category: catName),
                          ),
                        );
                      },
                      child: const Text(
                        "VIEW",
                        style: TextStyle(color: Colors.white),
                      ),
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

/// --------------------------------------------------------------
/// A simple data model for a Ticket
/// --------------------------------------------------------------
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

/// --------------------------------------------------------------
/// 2) MyRequestsPage
/// --------------------------------------------------------------
/// Has four tabs: open, Resolved, Closed, Closed by cu
/// Each tab holds a list of tickets. Tapping a ticket => TicketDetailsPage
/// You can also add a new ticket => AddTicketPage
class MyRequestsPage extends StatefulWidget {
  final String category;

  const MyRequestsPage({Key? key, required this.category}) : super(key: key);

  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // We'll store tickets in these lists (just for UI demo)
  // In a real app, you'd fetch from a server
  final List<Ticket> openTickets = [];
  final List<Ticket> resolvedTickets = [];
  final List<Ticket> closedTickets = [];
  final List<Ticket> closedByCustomerTickets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Optional: add sample ticket
    // openTickets.add(Ticket(
    //   id: "1",
    //   category: widget.category,
    //   title: "test",
    //   details: "Test",
    //   filePath: "33.file",
    //   date: "2025-02-19 03:04 PM",
    //   status: "open",
    // ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Called when user taps "Add new ticket"
  void _goToAddTicket() async {
    final newTicket = await Navigator.of(context).push<Ticket>(
      MaterialPageRoute(
        builder: (_) => AddTicketPage(category: widget.category),
      ),
    );
    if (newTicket != null) {
      // newTicket.status is "open" by default in AddTicketPage
      setState(() {
        openTickets.add(newTicket);
      });
    }
  }

  // Called when user taps on a ticket -> see details. May get an updated ticket or status changes
  void _goToTicketDetails(Ticket ticket) async {
    final updatedTicket = await Navigator.of(context).push<Ticket>(
      MaterialPageRoute(
        builder: (_) => TicketDetailsPage(ticket: ticket),
      ),
    );
    // If user updated/closed the ticket, reflect it in our lists
    if (updatedTicket != null) {
      // We'll remove from the old list and add to the new list based on updatedTicket.status
      setState(() {
        // Remove from old
        openTickets.removeWhere((t) => t.id == updatedTicket.id);
        resolvedTickets.removeWhere((t) => t.id == updatedTicket.id);
        closedTickets.removeWhere((t) => t.id == updatedTicket.id);
        closedByCustomerTickets.removeWhere((t) => t.id == updatedTicket.id);

        // Add to new
        if (updatedTicket.status == "open") {
          openTickets.add(updatedTicket);
        } else if (updatedTicket.status == "Resolved") {
          resolvedTickets.add(updatedTicket);
        } else if (updatedTicket.status == "Closed") {
          closedTickets.add(updatedTicket);
        } else if (updatedTicket.status == "Closed by cu") {
          closedByCustomerTickets.add(updatedTicket);
        }
      });
    }
  }

  // Builds a card for each ticket
  Widget _buildTicketCard(Ticket ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.orange[300],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _goToTicketDetails(ticket),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Title",
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              ticket.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Details
            const Text(
              "Details",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              ticket.details,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // File & date
            if (ticket.filePath != null && ticket.filePath!.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.insert_drive_file, size: 18),
                  const SizedBox(width: 4),
                  Text(ticket.filePath!),
                ],
              ),
              const SizedBox(height: 8),
            ],
            const Text(
              "Date",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              ticket.date,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsList(List<Ticket> tickets) {
    if (tickets.isEmpty) {
      return const Center(
        child: Text(
          "Empty Tickets!",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final t = tickets[index];
        return _buildTicketCard(t);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // (1) Sparkly background
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
          // (2) Lotus icon
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
                padding: const EdgeInsets.all(20),
                child: Image.network(
                  'https://cdn3.iconfinder.com/data/icons/zen-2/100/Lotus_5-512.png',
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // (3) AppBar
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
                "My Requests",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // (4) Tabs
          Positioned.fill(
            top: 240,
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF000610),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.orangeAccent,
                    labelColor: Colors.orangeAccent,
                    unselectedLabelColor: Colors.white70,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: "open"),
                      Tab(text: "Resolved"),
                      Tab(text: "Closed"),
                      Tab(text: "Closed by cu"),
                    ],
                  ),
                ),
                // TabBarView
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTicketsList(openTickets),
                      _buildTicketsList(resolvedTickets),
                      _buildTicketsList(closedTickets),
                      _buildTicketsList(closedByCustomerTickets),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: _goToAddTicket,
        label: const Text(
          "Add new ticket",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// --------------------------------------------------------------
/// 3) AddTicketPage
/// --------------------------------------------------------------
/// A page for creating a new ticket (title, details, file attach).
/// On "Add new ticket," it returns a Ticket object to MyRequestsPage.
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

/// --------------------------------------------------------------
/// 4) TicketDetailsPage
/// --------------------------------------------------------------
/// Shows a single ticket's details (title, details, file, date),
/// a "Comments" list, plus "New comment" and "Close Ticket" buttons.
class TicketDetailsPage extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailsPage({Key? key, required this.ticket}) : super(key: key);

  @override
  State<TicketDetailsPage> createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  late Ticket ticket;

  @override
  void initState() {
    super.initState();
    // We'll store a local copy of the ticket so we can update it
    ticket = widget.ticket;
  }

  // Called when user taps "New comment"
  void _goToAddComment() async {
    final newComment = await Navigator.of(context).push<Comment>(
      MaterialPageRoute(builder: (_) => AddCommentPage()),
    );
    if (newComment != null) {
      // Add to ticket's comments
      setState(() {
        ticket.comments.add(newComment);
      });
    }
  }

  void _closeTicket() {
    // For demo, let's just set status to "Closed"
    setState(() {
      ticket.status = "Closed";
    });
    // Then pop back with the updated ticket
    Navigator.of(context).pop(ticket);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background style
      body: Stack(
        children: [
          // sparkly background
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
          // lotus circle
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
                  )
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
                onPressed: () => Navigator.of(context).pop(ticket),
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
          // Content
          Positioned.fill(
            top: 240,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text("Title", style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(ticket.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  // Details
                  const Text("Details", style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(ticket.details, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),

                  // File
                  if (ticket.filePath != null && ticket.filePath!.isNotEmpty) ...[
                    Container(
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
                          Text(ticket.filePath!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Date
                  const Text("Date", style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(ticket.date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Divider(),

                  // Comments
                  const Text("Comments", style: TextStyle(fontSize: 18, color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ticket.comments.isEmpty
                      ? const Text("No Comments!", style: TextStyle(fontSize: 16, color: Colors.black54))
                      : Expanded(
                    child: ListView.builder(
                      itemCount: ticket.comments.length,
                      itemBuilder: (ctx, idx) {
                        final c = ticket.comments[idx];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.message,
                                style: const TextStyle(fontSize: 16),
                              ),
                              if (c.filePath != null && c.filePath!.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(Icons.insert_drive_file, size: 18),
                                    const SizedBox(width: 4),
                                    Text(c.filePath!),
                                  ],
                                ),
                              const SizedBox(height: 4),
                              Text(
                                c.date,
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
          // Buttons at bottom
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

/// --------------------------------------------------------------
/// 5) AddCommentPage
/// --------------------------------------------------------------
/// A page to add a comment (message + optional file) to a ticket
class AddCommentPage extends StatefulWidget {
  const AddCommentPage({Key? key}) : super(key: key);

  @override
  State<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends State<AddCommentPage> {
  final TextEditingController _messageCtrl = TextEditingController();
  String? attachedFile;

  @override
  void dispose() {
    _messageCtrl.dispose();
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

  void _addComment() {
    if (_messageCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a message")),
      );
      return;
    }
    final now = DateTime.now();
    final dateString = "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} "
        "${_twoDigits(now.hour)}:${_twoDigits(now.minute)} ${now.hour < 12 ? 'AM' : 'PM'}";

    final comment = Comment(
      message: _messageCtrl.text.trim(),
      filePath: attachedFile,
      date: dateString,
    );
    Navigator.of(context).pop(comment);
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Same top background + lotus style
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
          // (B) Lotus
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
                  )
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
          // (C) AppBar
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
                "Add Comment",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          // (D) Form
          Positioned.fill(
            top: 240,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Message
                  TextFormField(
                    controller: _messageCtrl,
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: "Message",
                      hintText: "Enter your comment",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Attached file
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
                  if (attachedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        attachedFile!,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Add Comment
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Add Comment",
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
