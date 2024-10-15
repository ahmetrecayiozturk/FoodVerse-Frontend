import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodverse_frontend/config/config.dart'; // Ensure this is correctly imported
import 'package:logging/logging.dart';

final Logger logger = Logger('BioService');

class Bio {
  String bio;
  String user;

  Bio({
    required this.bio,
    required this.user,
  });

  factory Bio.fromJson(Map<String, dynamic> json) {
    return Bio(
      bio: json['bio'] ?? '',
      user: json['user'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'user': user,
    };
  }
}

class BioService {
  Future<Bio?> createBio(Bio bio) async {
    final url = Uri.parse('${BaseUrl}save-bio');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bio.toJson()),
      );

      if (response.statusCode == 200) {
        return Bio.fromJson(jsonDecode(response.body));
      } else {
        logger.severe('Failed to create bio: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.severe('Error creating bio: $e');
      return null;
    }
  }

  Future<Bio?> getBio(String user) async {
    final url = Uri.parse('${BaseUrl}get-bio');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user': user}),
      );

      if (response.statusCode == 200) {
        return Bio.fromJson(jsonDecode(response.body));
      } else {
        logger.severe('Failed to get bio: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.severe('Error getting bio: $e');
      return null;
    }
  }

  Future<Bio?> updateBio(String user, String bio) async {
    final url = Uri.parse('${BaseUrl}update-bio');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user': user, 'bio': bio}),
      );

      if (response.statusCode == 200) {
        return Bio.fromJson(jsonDecode(response.body));
      } else {
        logger.severe('Failed to update bio: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.severe('Error updating bio: $e');
      return null;
    }
  }
}
