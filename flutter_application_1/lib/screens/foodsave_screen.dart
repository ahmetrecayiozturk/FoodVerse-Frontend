import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodverse_frontend/config/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foodverse_frontend/services/food_service.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';

class FoodSavePage extends StatefulWidget {
  final User user;
  const FoodSavePage({super.key, required this.user});

  @override
  State<FoodSavePage> createState() => _FoodSavePageState();
}

class _FoodSavePageState extends State<FoodSavePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _preparingController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  List<String> ingredients = [];
  String? _selectedCategory;
  String? _typeCategory;

  final List<String> categories = [
    'Kahvaltı',
    'Ana Yemek',
    'Soğuk İçecek',
    'Kahve',
    'Tatlı',
    'Sıcak İçecek'
  ];
  final List<String> types = [
    'Normal',
    'Kalori Azaltma',
    'Protein Kullanımı',
    'Beslenme Kurallarına Uygun',
    'Glutensiz',
    'Tipsiz'
  ];

  void _addIngredient() {
    setState(() {
      if (_ingredientsController.text.isNotEmpty) {
        ingredients.add(_ingredientsController.text);
        _ingredientsController.clear();
      }
    });
  }

  void saveFood() async {
    if (_selectedCategory == null) {
      // Show an alert dialog if the category is not selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select a category.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (_typeCategory == null) {
      // Show an alert dialog if the type is not selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select a type.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      String? userId = await FoodService().getUserId(widget.user.email);
      var regbody = {
        "adder": widget.user.email,
        "name": _nameController.text,
        "ingredients": ingredients,
        "preparing": _preparingController.text,
        "category": _selectedCategory,
        "type": _typeCategory
      };
      final response = await http.post(Uri.parse(BaseUrl + foodSaveApi),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(regbody));

      if (response.statusCode == 201) {
        print("Response body: ${response.body}");
        print("Food saved successfully");
        print("Response body: ${response.body}");
        // Show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Food has been added successfully'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("Failed to save food: ${response.body}");
        throw Exception('Failed to save food');
      }
    } catch (e) {
      print("Error saving food: $e");
      // Consider showing an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Food Page",
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade100, Colors.orange.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle:
                      GoogleFonts.lato(fontSize: 18, color: Colors.orange[900]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientsController,
                      decoration: InputDecoration(
                        labelText: "Ingredient",
                        labelStyle: GoogleFonts.lato(
                            fontSize: 18, color: Colors.orange[900]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.orange[900]),
                    onPressed: _addIngredient,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _preparingController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Preparing",
                  labelStyle:
                      GoogleFonts.lato(fontSize: 18, color: Colors.orange[900]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle:
                      GoogleFonts.lato(fontSize: 18, color: Colors.orange[900]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Type",
                  labelStyle:
                      GoogleFonts.lato(fontSize: 18, color: Colors.orange[900]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: _typeCategory,
                items: types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _typeCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: saveFood,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    textStyle: GoogleFonts.lato(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text("Submit"),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Ingredients:",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.orange.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        ingredients[index],
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.orange[900]),
                        onPressed: () {
                          setState(() {
                            ingredients.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}