import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/project_model.dart';

class ApiService {
  static const String baseUrl = "https://695eb0f22556fd22f679226c.mockapi.io";

  /* =======================
     PROJECT
  ======================== */

  // GET Projects
  static Future<List<Project>> fetchProjects() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/projects"));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Project.fromJson(e)).toList();
      } else {
        throw Exception("Gagal mengambil data proyek");
      }
    } catch (e) {
      throw Exception("Kesalahan koneksi: $e");
    }
  }

  /* =======================
     DONATION
  ======================== */

  // POST Donation
  static Future<bool> postDonation(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/donations"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  /* =======================
     GENERIC CRUD (OPSIONAL)
  ======================== */

  // GET generic
  static Future<List<dynamic>> getData(String endpoint) async {
    final response = await http.get(Uri.parse("$baseUrl/$endpoint"));
    return jsonDecode(response.body);
  }

  // POST generic
  static Future<void> postData(
      String endpoint, Map<String, dynamic> data) async {
    await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  // PUT generic
  static Future<bool> putData(
      String endpoint, String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$endpoint/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response.statusCode == 200;
  }

  // DELETE generic
  static Future<void> deleteData(String endpoint, String id) async {
    await http.delete(
      Uri.parse("$baseUrl/$endpoint/$id"),
    );
  }
}
