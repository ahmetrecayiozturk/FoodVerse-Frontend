import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';
import 'package:foodverse_frontend/screens/filterfoodbyingredients.dart';
import 'package:foodverse_frontend/screens/foodfilter_screen.dart';

class CategoryPage extends StatefulWidget {
  final User user;
  const CategoryPage({super.key, required this.user});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildCategoryButton(
              context,
              label: "Kahvaltı",
              category: "Kahvaltı",
            ),
            _buildCategoryButton(
              context,
              label: "Ana Yemek",
              category: "Ana Yemek",
            ),
            _buildCategoryButton(
              context,
              label: "Soğuk İçecek",
              category: "Soğuk İçecek",
            ),
            _buildCategoryButton(
              context,
              label: "Kahve",
              category: "Kahve",
            ),
            _buildCategoryButton(
              context,
              label: "Tatlı",
              category: "Tatlı",
            ),
            _buildCategoryButton(
              context,
              label: "Sıcak İçecek",
              category: "Sıcak İçecek",
            ),
            _buildGeneralButton(
              context,
              label: "Genel",
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context,
      {required String label, required String category}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodFilterPage(
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
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          textStyle: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildGeneralButton(BuildContext context, {required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterFoodByOnlyIngredientPage(
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
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          textStyle: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildSimpleButton(
      {required String label, required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          textStyle: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}