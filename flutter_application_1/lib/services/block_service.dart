import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodverse_frontend/config/config.dart'; // Ensure this is correctly imported
import 'package:logging/logging.dart';

final logger = Logger('BlockService');

class Block {
  String blocker;
  String blocked;

  Block({
    required this.blocker,
    required this.blocked,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      blocker: json['blocker'] ?? '',
      blocked: json['blocked'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blocker': blocker,
      'blocked': blocked,
    };
  }
}

class BlockService {
  // BLOKLANAN KULLANICI OLUŞTURULUYOR
  Future<Block?> createBlock(String blocker, String blocked) async {
    final url = Uri.parse('${BaseUrl}block-user');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'blocker': blocker, 'blocked': blocked}),
      );

      if (response.statusCode == 200) {
        return Block.fromJson(jsonDecode(response.body));
      } else {
        logger.severe('Failed to create block: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.severe('Error creating block: $e');
      return null;
    }
  }

  // BLOKLANAN KULLANICI KONTROL EDİLİYOR
  Future<Block?> checkBlock(String blocker, String blocked) async {
    final url = Uri.parse('${BaseUrl}check-blocked');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'blocker': blocker, 'blocked': blocked}),
      );

      if (response.statusCode == 200) {
        return Block.fromJson(jsonDecode(response.body));
      } else {
        logger.severe('Failed to get block: ${response.body}');
        return null;
      }
    } catch (e) {
      logger.severe('Error getting block: $e');
      return null;
    }
  }

  // BLOKLANAN TÜM KULLANICILAR DÖNDÜRÜLÜYOR
  Future<List<Block>> getAllBlocks(String blocker) async {
    final url = Uri.parse('${BaseUrl}get-blocked-users');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'blocker': blocker}),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['blockedusers'];
        logger.info('Blocked users data: $data');
        List<Block> blocks = data.map((json) => Block.fromJson(json)).toList();
        logger.info('Parsed blocked users: $blocks');
        return blocks;
      } else {
        logger.severe('Failed to get blocks: ${response.body}');
        return [];
      }
    } catch (e) {
      logger.severe('Error getting blocks: $e');
      return [];
    }
  }

  // BLOKLANAN KULLANICI UNBLOCK EDİLİYOR
  Future<bool> deleteBlock(String blocker, String blocked) async {
    final url = Uri.parse('${BaseUrl}unblock-user');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'blocker': blocker, 'blocked': blocked}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        logger.severe('Failed to delete block: ${response.body}');
        return false;
      }
    } catch (e) {
      logger.severe('Error deleting block: $e');
      return false;
    }
  }
}
