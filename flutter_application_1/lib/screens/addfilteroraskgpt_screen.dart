import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodverse_frontend/screens/category_screen.dart';
import 'package:foodverse_frontend/screens/foodsave_screen.dart';
import 'package:foodverse_frontend/gpt/screens/gpt_queryscreen.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';

class AddorFilterPage extends StatefulWidget {
  final User user;
  const AddorFilterPage({super.key, required this.user});

  @override
  State<AddorFilterPage> createState() => _AddorFilterPageState();
}

class _AddorFilterPageState extends State<AddorFilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FOODVERSE",
          style: GoogleFonts.lato(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.orange.shade300,
              Colors.orange.shade500,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "  Yemek Ekle, Filtrele veya GPT'ye Sor",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildOptionButton(
                        context,
                        label: 'Add Food',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodSavePage(
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildOptionButton(
                        context,
                        label: 'Filter Food',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                user: widget.user,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildOptionButton(
                        context,
                        label: 'Ask GPT',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GptQueryPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required String label,
    required void Function() onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        textStyle: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
