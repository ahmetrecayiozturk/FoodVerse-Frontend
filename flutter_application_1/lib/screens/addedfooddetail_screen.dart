import 'package:flutter/material.dart';
import 'package:foodverse_frontend/services/food_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowAddedFoodDetailPage extends StatelessWidget {
  final String name;
  final List<String> ingredients;
  final String preparing;

  const ShowAddedFoodDetailPage({
    super.key,
    required this.name,
    required this.ingredients,
    required this.preparing,
  });

  Future<String> _getFoodOwner() async {
    final addedusername =
        await FoodService().getAdderByFood(name, ingredients, preparing);
    return addedusername;
    }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: GoogleFonts.lato(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange[900],
      ),
      body: Container(
        height: screenHeight, // Ekranın tamamını kapla
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.orange.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Ingredients',
                style: GoogleFonts.lato(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade200,
                      blurRadius: 10.0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        ingredients[index],
                        style: GoogleFonts.lato(
                          fontSize: screenWidth * 0.045,
                          color: Colors.black87,
                        ),
                      ),
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: Colors.orange[900],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Preparation',
                style: GoogleFonts.lato(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Card(
                color: Colors.orange.shade50,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Text(
                    preparing,
                    style: GoogleFonts.lato(
                      fontSize: screenWidth * 0.045,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              FutureBuilder<String>(
                future: _getFoodOwner(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Center(
                      child: Text(
                        'Added by: ${snapshot.data}',
                        style: GoogleFonts.lato(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange[900],
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.02),
                    textStyle: GoogleFonts.lato(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // Handle button press
                  },
                  child: const Text('Start Cooking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
