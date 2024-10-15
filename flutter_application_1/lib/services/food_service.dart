import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodverse_frontend/config/config.dart'; // Ensure this is correctly imported
import 'package:logging/logging.dart';

final Logger logger = Logger('FoodService');

class Food {
  String id;
  String adder;
  String name;
  List<String> ingredients;
  String preparing;
  String category;
  String type;

  Food({
    required this.id,
    required this.adder,
    required this.name,
    required this.ingredients,
    required this.preparing,
    required this.category,
    required this.type,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['Id'] ?? '',
      adder: json['adder'] ?? 'sistem',
      name: json['name'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((item) => item as String)
              .toList() ??
          [],
      preparing: json['preparing'] ?? '',
      category: json['category'] ?? '',
      type: json['type'] ?? 'Tipsiz',
    );
  }
}

class FoodService {
  static Future<List<Food>> getFoodsByIngredients(
      List<String> ingredients, String category) async {
    final response = await http.post(
      Uri.parse(BaseUrl + foodSearchApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ingredients': ingredients,
        'category': category,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Food> foods = data.map((json) => Food.fromJson(json)).toList();
      return foods;
    } else {
      logger.warning(
          "Failed to load foods with status code: ${response.statusCode}");
      throw Exception('Failed to load foods');
    }
  }

  Future<void> favoriteFood(String userId, String name,
      List<String> ingredients, String preparing) async {
    if (userId.isNotEmpty) {
      var regBody = {
        "Id": userId,
        "name": name,
        "ingredients": ingredients,
        "preparing": preparing
      };
      final response = await http.post(
        Uri.parse(BaseUrl + savedFood),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(regBody),
      );

      if (response.statusCode == 201) {
        logger.info("Food Saved Successfully");
      } else {
        logger.warning("Food Not Saved Successfully. User ID: $userId");
      }
    } else {
      logger.warning("userId is not found");
    }
  }

  Future<List<Food>> fetchFavoriteFoods(String userId) async {
    var regbody = {"Id": userId};
    final response = await http.post(
      Uri.parse(BaseUrl + getsavedfood),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regbody),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((food) => Food.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load saved foods');
    }
  }

  Future<String?> getUserId(String email) async {
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
    return null;
  }

  Future<Food?> addFood(String adder, String name, List<String> ingredients,
      String preparing, String category, String? type) async {
    final response = await http.post(
      Uri.parse(BaseUrl + foodSaveApi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'adder': adder,
        'name': name,
        'ingredients': ingredients,
        'preparing': preparing,
        'category': category,
        'type': type ?? 'Yemek Tipi Belirtilmemiş',
      }),
    );

    if (response.statusCode == 201) {
      print('Response body: ${response.body}');
      return Food.fromJson(jsonDecode(response.body));
    } else {
      logger.warning(
          'Failed to add food. Status code: ${response.statusCode}. Response body: ${response.body}');
      throw Exception(
          'Failed to add food. Status code: ${response.statusCode}');
    }
  }

  Future<List<Food>> fetchAddedFoods(String name) async {
    var regbody = {"adder": name};
    final response = await http.post(
      Uri.parse(BaseUrl + getaddedfoods),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regbody),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((food) => Food.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load saved foods');
    }
  }

  Future<String> getAdderByFood(
      String name, List<String> ingredients, String preparing) async {
    var regbody = {
      "name": name,
      "ingredients": ingredients,
      "preparing": preparing
    };
    final response = await http.post(
      Uri.parse(BaseUrl + getadderbyfood),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(regbody),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      var adder = jsonResponse['adder'];
      return adder ?? "sistem";
    } else {
      return "sistem";
    }
  }

  static Future<List<Food>> getFoodsByOnlyIngredients(
      List<String> ingredients) async {
    print('çalışıyor hocamm');
    final response = await http.post(
      Uri.parse(BaseUrl + finfoodbyonlyingredient),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'ingredients': ingredients,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Food> foods = data.map((json) => Food.fromJson(json)).toList();
      return foods;
    } else {
      logger.warning(
          "Failed to load foods with status code: ${response.statusCode}");
      throw Exception('Failed to load foods');
    }
  }

  Future<List<Food>> showAllFoodsByCategory(String category) async {
    var regbody = {"category": category};
    final response = await http.post(
      Uri.parse('${BaseUrl}get-all-food-by-category'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(regbody),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((food) => Food.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load foods');
    }
  }

  Future<List<Food>> showAllFoods() async {
    final response = await http.post(
      Uri.parse('${BaseUrl}get-all-foods'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      print('Response data: $jsonResponse'); // Debugging ifadesi
      return jsonResponse.map((food) => Food.fromJson(food)).toList();
    } else {
      print('Failed to load foods: ${response.body}'); // Debugging ifadesi
      throw Exception('Failed to load foods');
    }
  }
}
