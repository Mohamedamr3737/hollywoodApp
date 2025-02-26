import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/controller/token_controller.dart';

class SpecialOffersController {
  /// Fetches the special offers HTML content from the API.
  Future<String> fetchOffers() async {
    String? bearerToken= await refreshAccessToken();
    const String url = 'https://portal.ahmed-hussain.com/api/patient/offers';
    final response = await http.get(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        // Return the HTML content from the 'data' key.
        return jsonResponse['data'].toString();
      } else {
        throw Exception('API Error: ${jsonResponse['message']}');
      }
    } else {
      throw Exception(
          'Failed to load offers. Status code: ${response.statusCode}');
    }
  }
}
