import 'package:flutter/material.dart';
import 'package:foodverse_frontend/screens/addedfooddetail_screen.dart';
import 'package:foodverse_frontend/services/food_service.dart';

class AddedFoodsPage extends StatelessWidget {
  final List<Food> foods;

  const AddedFoodsPage({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        title: const Text(
          'Added Foods',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.orange.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                color: Colors.orange[900],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  food.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  food.ingredients.join(', '),
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowAddedFoodDetailPage(
                        name: food.name,
                        ingredients: food.ingredients,
                        preparing: food.preparing ?? '',
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}