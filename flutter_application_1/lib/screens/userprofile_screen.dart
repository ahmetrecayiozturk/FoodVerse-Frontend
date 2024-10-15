import 'package:flutter/material.dart';
import 'package:foodverse_frontend/components/drawer.dart';
import 'package:foodverse_frontend/components/my_text_box.dart';
import 'package:foodverse_frontend/gpt/screens/gpt_queryscreen.dart';
import 'package:foodverse_frontend/screens/categorypageforshow_screen.dart';
import 'package:foodverse_frontend/screens/foodfilter_screen.dart';
import 'package:foodverse_frontend/screens/foodsave_screen.dart';
import 'package:foodverse_frontend/screens/searchprofilescreen.dart';
import 'package:foodverse_frontend/screens/showaddedfoods.dart';
import 'package:foodverse_frontend/screens/showsavedfoods.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';
import 'package:foodverse_frontend/services/food_service.dart';
import 'package:foodverse_frontend/services/bio_service.dart'; // BioService import edildi

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String bio = 'empty bio';

  @override
  void initState() {
    super.initState();
    _loadBio();
  }

  Future<void> _loadBio() async {
    BioService bioService = BioService();
    Bio? fetchedBio = await bioService.getBio(widget.user.email);
    if (fetchedBio != null) {
      setState(() {
        bio = fetchedBio.bio;
      });
    }
  }

  Future<void> editField(String field) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Bio'),
          content: const Text('Would you like to add or edit your bio?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showBioInputDialog('Add Bio', '');
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showBioInputDialog('Edit Bio', bio);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBioInputDialog(String title, String currentBio) async {
    String? newBio =
        await _showInputDialog(context, title, 'Enter your bio', currentBio);
    if (newBio != null && newBio.isNotEmpty) {
      BioService bioService = BioService();
      Bio bioData = Bio(bio: newBio, user: widget.user.email);
      if (title == 'Add Bio') {
        await bioService.createBio(bioData);
      } else {
        await bioService.updateBio(widget.user.email, newBio);
      }
      setState(() {
        bio = newBio;
      });
    }
  }

  Future<String?> _showInputDialog(BuildContext context, String title,
      String hint, String initialValue) async {
    String? value = initialValue;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: TextEditingController(text: initialValue),
            onChanged: (val) {
              value = val;
            },
            decoration: InputDecoration(hintText: hint),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(value);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFullBio() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bio'),
          content: SingleChildScrollView(
            child: Text(bio),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page
            },
          ),
        ],
      ),
      drawer: MyDrawer(
        GoToGptPage: () async {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GptQueryPage(),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        GoToHomePage: () async {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfileScreen(user: widget.user),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        GoToAddedFoods: () async {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodSavePage(user: widget.user),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        GoToSavedFoods: () async {
          try {
            String? userId = await FoodService().getUserId(widget.user.email);
            if (userId != null) {
              List<Food> savedFoods =
                  await FoodService().fetchFavoriteFoods(userId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedFoodsPage(foods: savedFoods),
                ),
              );
            }
          } catch (e) {
            print(e);
          }
        },
        GoToFilterFoods: () async {
          try {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodFilterPage(
                  user: widget.user,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        LogOut: () {
          try {
            Navigator.pop(context); // Drawer'ı kapatmak için
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const AuthScreen()));
          } catch (e) {
            print(e);
          }
        },
        Search: () {
          try {
            Navigator.pop(context); // Drawer'ı kapatmak için
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SearchProfileScreen(user: widget.user)));
          } catch (e) {
            print(e);
          }
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight, // Ekranın tamamını kapla
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.teal.shade400,
                Colors.teal.shade700,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                CircleAvatar(
                  radius: screenWidth * 0.10,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: screenWidth * 0.16,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Text(
                    widget.user.email,
                    style: GoogleFonts.lato(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(height: screenHeight * 0.01),
                MyTextBox(
                    text: 'mitchikko',
                    sectionName: widget.user.email,
                    onpressed: () =>
                        {} //updateEmail(widget.user.email), bunu kaldırıyorum
                    ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: MyTextBox(
                        text: bio,
                        sectionName: 'Bio',
                        onpressed: () => editField('bio'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.white),
                      onPressed: _showFullBio,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.04),
                Column(
                  children: [
                    _buildCardButton(
                      context,
                      label: 'Food Filter',
                      icon: Icons.filter_list,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodFilterPage(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildCardButton(
                      context,
                      label: 'Show Foods',
                      icon: Icons.fastfood,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoryPageForShow(user: widget.user),
                          ),
                        );
                      },
                    ),
                    _buildCardButton(
                      context,
                      label: 'Show Saved Foods',
                      icon: Icons.bookmark,
                      onTap: () async {
                        try {
                          String? userId =
                              await FoodService().getUserId(widget.user.email);
                          if (userId != null) {
                            List<Food> savedFoods =
                                await FoodService().fetchFavoriteFoods(userId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SavedFoodsPage(foods: savedFoods),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    _buildCardButton(
                      context,
                      label: 'Show Added Foods',
                      icon: Icons.add,
                      onTap: () async {
                        try {
                          List<Food> addedFoods = await FoodService()
                              .fetchAddedFoods(widget.user.email);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddedFoodsPage(foods: addedFoods),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal[700],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

