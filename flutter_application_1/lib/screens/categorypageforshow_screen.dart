import 'package:flutter/material.dart';
import 'package:foodverse_frontend/screens/showfoodbycategory_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';

class CategoryPageForShow extends StatefulWidget {
  final User user;
  const CategoryPageForShow({super.key, required this.user});

  @override
  State<CategoryPageForShow> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPageForShow> {
  String? selectedCategory;
  String? selectedType;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Category Page',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade50,
              Colors.teal.shade200,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Category",
                  fillColor: Colors.white70,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Type",
                  fillColor: Colors.white70,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedType,
                items: types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAllFoodsByCategory(
                        category: selectedCategory,
                        type: selectedType,
                        user: widget.user,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  textStyle: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Seçili Yemekleri Getir'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAllFoodsByCategory(
                        category: null,
                        type: null,
                        user: widget.user,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  textStyle: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(' Tüm Yemekleri Getir '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}