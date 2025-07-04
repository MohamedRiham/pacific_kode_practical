import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> getRequest({required String url}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Accept": "application/json"})
          .timeout(const Duration(seconds: 60));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Server error");
      }
    } on TimeoutException {
      throw Exception("Request Timeout: The server took too long to respond.");
    } on http.ClientException catch (e) {
      throw Exception("Client Exception: ${e.message}");
    } catch (error) {
      throw Exception("An unexpected error occurred: $error");
    }
  }
}
