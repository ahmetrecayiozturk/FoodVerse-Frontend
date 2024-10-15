import 'package:flutter/material.dart';
import 'package:foodverse_frontend/services/food_service.dart';
import 'package:foodverse_frontend/screens/fooddetail_screen.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';

class ShowAllFoodsByCategory extends StatefulWidget {
  final String? category;
  final String? type;
  final User user;

  const ShowAllFoodsByCategory(
      {super.key, this.category, this.type, required this.user});

  @override
  _ShowAllFoodsByCategoryState createState() => _ShowAllFoodsByCategoryState();
}

class _ShowAllFoodsByCategoryState extends State<ShowAllFoodsByCategory> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> _foods = [];
  List<Food> _filteredFoods = [];

  @override
  void initState() {
    super.initState();
    _fetchFoods();
  }

  void _fetchFoods() async {
    List<Food> foods = await FoodService().showAllFoods();
    setState(() {
      _foods = foods;
      _filteredFoods = _applyFilters(foods);
    });
  }

  List<Food> _applyFilters(List<Food> foods) {
    return foods.where((food) {
      bool matchesCategory =
          widget.category == null || food.category == widget.category;
      bool matchesType = widget.type == null || food.type == widget.type;
      bool matchesSearch = _searchController.text.isEmpty ||
          food.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesType && matchesSearch;
    }).toList();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredFoods = _applyFilters(_foods);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foods'),
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
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  fillColor: Colors.white70,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => _onSearchChanged(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredFoods.length,
                  itemBuilder: (context, index) {
                    Food food = _filteredFoods[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(food.name),
                        subtitle: Text(food.ingredients.join(', ')),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailPage(
                                name: food.name,
                                ingredients: food.ingredients,
                                preparing: food.preparing ?? '',
                                user: widget.user,
                                selectedIngredients: const [],
                                type: food.type,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}