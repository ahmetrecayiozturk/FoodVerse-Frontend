import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';
import 'package:foodverse_frontend/services/food_service.dart';

class FoodDetailPage extends StatelessWidget {
  final String name;
  final List<String> ingredients;
  final String preparing;
  final String type;
  final User user;
  final List<String> selectedIngredients;

  const FoodDetailPage({
    super.key,
    required this.name,
    required this.ingredients,
    required this.preparing,
    required this.type,
    required this.user,
    required this.selectedIngredients,
  });

  Future<void> _saveFood(BuildContext context) async {
    String? userId = await FoodService().getUserId(user.email);
    await FoodService().favoriteFood(userId!, name, ingredients, preparing);

    // Favorilere eklendiğinde showDialog göster
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Food has been favorited'),
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
  }

  Future<String> _getFoodOwner() async {
    final addedusername =
        await FoodService().getAdderByFood(name, ingredients, preparing);
    return addedusername;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Ingredients:',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  bool isSelected =
                      selectedIngredients.contains(ingredients[index]);
                  return ListTile(
                    title: Text(
                      ingredients[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                    leading: Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                    onTap: () {
                      // Handle ingredient tap
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Preparation:',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.teal.shade100,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      preparing,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Type:',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              type,
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: _getFoodOwner(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    'Ekleyen: ${snapshot.data}',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _saveFood(context),
                icon: const Icon(Icons.favorite),
                label: const Text('Favori Ekle'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}