import 'package:flutter/material.dart';
import 'package:foodverse_frontend/screens/addedfooddetail_screen.dart';
import 'package:foodverse_frontend/services/food_service.dart';

class ShowAllFoods extends StatefulWidget {
  const ShowAllFoods({super.key});

  @override
  _ShowAllFoodsState createState() => _ShowAllFoodsState();
}

class _ShowAllFoodsState extends State<ShowAllFoods> {
  late Future<List<Food>> foods;
  List<Food> filteredFoods = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    foods = FoodService().showAllFoods();
    foods.then((foodList) {
      setState(() {
        filteredFoods = foodList..sort((a, b) => a.name.compareTo(b.name));
      });
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredFoods = filteredFoods
          .where(
              (food) => food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Foods by Category',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange[900],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by food name',
                fillColor: Colors.white,
                filled: true,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
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
        child: FutureBuilder<List<Food>>(
          future: foods,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No foods found'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredFoods.length,
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
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
              );
            }
          },
        ),
      ),
    );
  }
}
