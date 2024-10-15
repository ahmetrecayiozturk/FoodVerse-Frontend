import 'dart:convert';
import 'package:foodverse_frontend/screens/auth_screen.dart';
import 'package:http/http.dart' as http;
import 'package:foodverse_frontend/config/config.dart'; // Ensure this is correctly imported
import 'package:logging/logging.dart';

final Logger logger = Logger('AuthService');

class AuthService {
  Future<bool> registerUser(String email, String password) async {
    logger.info("Registering Process");
    var regBody = {"email": email, "password": password};
    try {
      var response = await http.post(
        Uri.parse(BaseUrl + registrationApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        logger.info("Registration Successful");
        logger.info("Status Code: ${response.statusCode}");
        logger.info("Response Body: ${response.body}");
        return true;
      } else {
        // Log error details for non-200 responses
        logger.warning("Registration Failed");
        logger.warning("Status Code: ${response.statusCode}");
        logger.warning("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      // Catch and log any exceptions during the HTTP request
      logger.severe("An error occurred during registration: $e");
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    var regBody = {"email": email, "password": password};

    try {
      var response = await http.post(
        Uri.parse(BaseUrl + loginApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 200) {
        logger.info("Login Successful");
        logger.info("Status Code: ${response.statusCode}");
        logger.info("Response Body: ${response.body}");
        return true;
      } else {
        logger.warning("Login Failed");
        logger.warning("Status Code: ${response.statusCode}");
        logger.warning("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      logger.severe("An error occurred during login: $e");
      return false;
    }
  }

  Future<String> updateEmail(String email, String newEmail) async {
    var regBody = {"email": email, "newemail": newEmail};
    final response = await http.post(
      Uri.parse('${BaseUrl}update-email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regBody),
    );
    return response.body;
  }

  Future<String> getUserId(String email) async {
    var regBody = {"email": email};
    final response = await http.post(
      Uri.parse(BaseUrl + isuserexist),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regBody),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      var userId = jsonResponse['Id'];
      return userId;
    }
    return ''; // Add this line to ensure a value is always returned
  }

  Future<String> getUserByEmail(String email) async {
    var regBody = {"email": email};
    final response = await http.post(
      Uri.parse('${BaseUrl}get-userprofiles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regBody),
    );
    return response.body;
  }
  Future<User?> getUserById(String userId) async {
    var regBody = {"userId": userId};
    final response = await http.post(
      Uri.parse('${BaseUrl}get-userbyid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regBody),
    );

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('API Response: $jsonResponse'); // Hata ayıklama için ekleyin
        return User.fromJson(jsonResponse);
      } catch (e) {
        print('JSON Parsing Error: $e'); // Hata ayıklama için ekleyin
        return null;
      }
    } else {
      print('HTTP Error: ${response.statusCode}'); // Hata ayıklama için ekleyin
      return null;
    }
  }

  Future<User?> getUserByEmaill(String email) async {
    var regBody = {"email": email};
    final response = await http.post(
      Uri.parse('${BaseUrl}get-userprofiles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regBody),
    );

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('API Response: $jsonResponse'); // Hata ayıklama için ekleyin
        return User.fromJson(jsonResponse);
      } catch (e) {
        print('JSON Parsing Error: $e'); // Hata ayıklama için ekleyin
        return null;
      }
    } else {
      print('HTTP Error: ${response.statusCode}'); // Hata ayıklama için ekleyin
      return null;
    }
  }
}