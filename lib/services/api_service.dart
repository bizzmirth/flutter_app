import 'dart:convert';
import 'dart:io';
import 'package:bizzmirth_app/utils/failure.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const Duration _timeout = Duration(seconds: 20);

  Map<String, String> get _headers => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<Map<String, dynamic>> get(String url) async {
    return _request(() => _client.get(
          Uri.parse(url),
          headers: _headers,
        ));
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
  ) async {
    return _request(() => _client.post(
          Uri.parse(url),
          headers: _headers,
          body: jsonEncode(body),
        ));
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body,
  ) async {
    return _request(() => _client.put(
          Uri.parse(url),
          headers: _headers,
          body: jsonEncode(body),
        ));
  }

  Future<Map<String, dynamic>> delete(String url) async {
    return _request(() => _client.delete(
          Uri.parse(url),
          headers: _headers,
        ));
  }

  // 🔥 SINGLE place for all validation & decoding
  Future<Map<String, dynamic>> _request(
    Future<http.Response> Function() httpCall,
  ) async {
    try {
      final response = await httpCall().timeout(_timeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Failure('HTTP error ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Failure('Invalid JSON format');
      }

      return decoded;
    } on SocketException {
      throw Failure('No internet connection');
    } on FormatException {
      throw Failure('Invalid JSON response');
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure('Unexpected error');
    }
  }
}
