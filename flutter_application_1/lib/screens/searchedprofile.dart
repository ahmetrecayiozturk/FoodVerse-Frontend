import 'package:flutter/material.dart';
import 'package:foodverse_frontend/screens/auth_screen.dart';
import 'package:foodverse_frontend/screens/showaddedfoods.dart';
import 'package:foodverse_frontend/screens/showsavedfoods.dart';
import 'package:foodverse_frontend/services/auth_service.dart';
import 'package:foodverse_frontend/services/bio_service.dart';
import 'dart:convert';
import 'package:foodverse_frontend/services/food_service.dart';

class SearchedUserProfile extends StatefulWidget {
  final User currentuser;
  final String searchedUser;

  const SearchedUserProfile({
    super.key,
    required this.currentuser,
    required this.searchedUser,
  });

  @override
  _SearchedUserProfileState createState() => _SearchedUserProfileState();
}

class _SearchedUserProfileState extends State<SearchedUserProfile> {
  final AuthService _authService = AuthService();
  final BioService _bioService = BioService();
  User? searchedUser;
  bool isLoading = true;
  Bio? userBio;
  String bio = '';
  String bioo = '';

  @override
  void initState() {
    super.initState();
    _initializeSearchedUser();
    _loadBio();
  }

  Future<void> _loadBio() async {
    BioService bioServicee = BioService();
    Bio? fetchedBio = await bioServicee.getBio(searchedUser!.email);
    if (fetchedBio != null) {
      print('heyyyyyy${fetchedBio.bio}');
      setState(() {
        print(bio);
        bio = fetchedBio.bio;
      });
    } else {
      print('Bio is null');
    }
  }

  void _initializeSearchedUser() async {
    try {
      final Map<String, dynamic> userMap = jsonDecode(widget.searchedUser);
      searchedUser = User.fromJson(userMap);
      userBio = await _bioService.getBio(searchedUser!.email);
      setState(() {
        bio = userBio?.bio ?? 'No bio available';
        isLoading = false;
      });
      print('Searched User Email: ${searchedUser!.email}');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error initializing searched user: $e');
    }
  }

  Future<void> _sendMessage(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Send message functionality is not implemented yet.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchedUser == null
              ? const Center(child: Text('User not found.'))
              : Container(
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
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const SizedBox(height: 20),
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Email: ${searchedUser!.email}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Bio: $bio',
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading:
                              const Icon(Icons.favorite, color: Colors.blue),
                          title: const Text(
                            'Show Saved Foods',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          onTap: () async {
                            try {
                              String? userId = await FoodService()
                                  .getUserId(searchedUser!.email);
                              if (userId != null) {
                                List<Food> savedFoods = await FoodService()
                                    .fetchFavoriteFoods(userId);
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
                      ),
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.add, color: Colors.blue),
                          title: const Text(
                            'Show Added Foods',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          onTap: () async {
                            try {
                              List<Food> addedFoods = await FoodService()
                                  .fetchAddedFoods(searchedUser!.email);
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
                      ),
                    ],
                  ),
                ),
    );
  }
}

