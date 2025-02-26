import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/notifications_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsController _controller = NotificationsController();
  late Future<List<NotificationItem>> _futureNotifications;

  @override
  void initState() {
    super.initState();
    _futureNotifications = _controller.fetchNotifications();
  }

  /// Helper method to mark a notification as read and then refetch
  Future<void> _onNotificationTap(NotificationItem notification) async {
    try {
      // 1) Mark the notification as read via API
      await _controller.markAsRead(notification.id);

      // 2) Refetch the entire list to update the UI
      setState(() {
        _futureNotifications = _controller.fetchNotifications();
        _controller.fetchUnreadCount();

      });
    } catch (e) {
      // Show an error, or handle it as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NotificationItem>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 1) LOADING
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 2) ERROR
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // 3) EMPTY DATA
            return const Center(child: Text("No notifications available."));
          } else {
            // 4) SUCCESS
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                // Check if readAt is null => unread
                final bool isUnread = notification.readAt == null;

                // Parse & format the date/time from "createdAt"
                DateTime? dateTime;
                try {
                  dateTime = DateTime.parse(notification.createdAt);
                } catch (_) {
                  // If parsing fails, keep it null
                }

                String formattedDate = '';
                String formattedTime = '';
                if (dateTime != null) {
                  formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  formattedTime = DateFormat('hh:mm a').format(dateTime);
                }

                // If unread, let's invert text color to remain visible on orange background
                final Color cardColor = isUnread ? Colors.orangeAccent : Colors.white;
                final Color textColor = isUnread ? Colors.white : Colors.black;
                final Color subtitleColor = isUnread ? Colors.white70 : Colors.black87;
                final Color dateColor = isUnread ? Colors.white70 : Colors.grey;
                final Color iconColor = isUnread ? Colors.white : Colors.orangeAccent;

                return InkWell(
                  onTap: () => _onNotificationTap(notification),
                  child: Card(
                    // 1) If read_at is null => orangeAccent; else white
                    color: cardColor,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification icon
                          Icon(
                            Icons.notifications,
                            color: iconColor,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          // Title & message expand to fill space
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title (wider, can wrap multiple lines)
                                Text(
                                  notification.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Message
                                Text(
                                  notification.content,
                                  style: TextStyle(color: subtitleColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Date & time on the right side
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(fontSize: 12, color: dateColor),
                              ),
                              Text(
                                formattedTime,
                                style: TextStyle(fontSize: 12, color: dateColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
