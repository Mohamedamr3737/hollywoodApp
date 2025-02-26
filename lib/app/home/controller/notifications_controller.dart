// notifications_controller.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/controller/token_controller.dart';

class NotificationItem {
  final int id;
  final String title;
  final String content;
  final String type;
  final int typeId;
  final String? readAt;
  final String link;
  final bool require;
  final String createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.typeId,
    this.readAt,
    required this.link,
    required this.require,
    required this.createdAt,
  });
}

class NotificationsController {
  // 1) Fetch notifications as before
  Future<List<NotificationItem>> fetchNotifications() async {
    final String? bearerToken = await refreshAccessToken();
    const String url = 'https://portal.ahmed-hussain.com/api/patient/notifications/list';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      if (jsonBody['status'] == true) {
        final List<dynamic> dataList = jsonBody['data'];
        return dataList.map((notif) {
          return NotificationItem(
            id: notif['id'] ?? 0,
            title: notif['title'] ?? '',
            content: notif['content'] ?? '',
            type: notif['type'] ?? '',
            typeId: notif['type_id'] ?? 0,
            readAt: notif['read_at'],
            link: notif['link'] ?? '',
            require: notif['require'] ?? false,
            createdAt: notif['created_at'] ?? '',
          );
        }).toList();
      } else {
        throw Exception('API Error: ${jsonBody['message']}');
      }
    } else {
      throw Exception(
        'Failed to load notifications. Status code: ${response.statusCode}',
      );
    }
  }

  // 2) Mark a single notification as read
  Future<void> markAsRead(int notificationId) async {
    print(notificationId);
    final String? bearerToken = await refreshAccessToken();
    final String url =
        'https://portal.ahmed-hussain.com/api/patient/notifications/read?notification_id=$notificationId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      if (jsonBody['status'] == true) {
        // Successfully marked as read, nothing else needed
      } else {
        throw Exception('API Error: ${jsonBody['message']}');
      }
    } else {
      throw Exception(
        'Failed to mark notification as read. Status code: ${response.statusCode}',
      );
    }
  }

  Future<int> fetchUnreadCount() async {
    print("function called");
    final String? bearerToken = await getAccessToken();
    const String url = 'https://portal.ahmed-hussain.com/api/patient/notifications/unread-count';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      int jsonBody =  int.parse(response.body);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaa");
      print(jsonBody);

        // The "data" field should be the integer count
        return jsonBody?? 0;

    } else {
      throw Exception(
        'Failed to load unread count. Status code: ${response.statusCode}',
      );
    }
  }
}
