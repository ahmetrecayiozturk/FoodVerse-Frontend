import 'package:flutter/material.dart';
import 'package:foodverse_frontend/screens/searchedprofile.dart';
import 'package:foodverse_frontend/screens/userprofile_screen.dart';
import 'package:foodverse_frontend/services/auth_service.dart';
import 'package:foodverse_frontend/services/block_service.dart';
import '../screens/auth_screen.dart';

class SearchProfileScreen extends StatefulWidget {
  final User user;

  const SearchProfileScreen({super.key, required this.user});
  @override
  _SearchProfileScreenState createState() => _SearchProfileScreenState();
}

class _SearchProfileScreenState extends State<SearchProfileScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();
  final BlockService _blockService = BlockService();
  List<Block> blockedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  void _loadBlockedUsers() async {
    try {
      List<Block> blocks = await _blockService.getAllBlocks(widget.user.email);
      setState(() {
        blockedUsers = blocks;
      });
    } catch (e) {
      print('Failed to load blocked users: $e');
    }
  }

  bool isBlocked(String userEmail) {
    return blockedUsers.any((block) => block.blocked == userEmail);
  }

  Future<void> _searchProfile() async {
    String email = _searchController.text;
    String? user = await _authService.getUserByEmail(email);
    print(
        "------------------------------------------------------------------------");
    print("Searching for user with email: $email");
    print("User: $user");
    print(
        "------------------------------------------------------------------------");
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user found with that email.')),
      );
      return;
    }

    if (isBlocked(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You are blocked from searching this user.')),
      );
      return;
    }

    List<Block> blocks = await _blockService.getAllBlocks(email);
    bool isBlockedByUser =
        blocks.any((block) => block.blocked == widget.user.email);
    if (isBlockedByUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are blocked by this user.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchedUserProfile(
          currentuser: widget.user,
          searchedUser: user,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: widget.user),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.teal.shade400,
        appBar: AppBar(
          title: const Text(
            'Search Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal[700],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Enter email to search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _searchProfile,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}