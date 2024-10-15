import 'package:flutter/material.dart';

class GptQueryPage extends StatefulWidget {
  const GptQueryPage({super.key});

  @override
  _GptQueryPageState createState() => _GptQueryPageState();
}

class _GptQueryPageState extends State<GptQueryPage> {
  final TextEditingController _inputController = TextEditingController();
  String _response = '';
  String _error = '';
  bool _isLoading = false;

  void _getGptResponse() async {
    setState(() {
      _isLoading = true;
      _response = '';
      _error = '';
    });

    try {
      String userInput = _inputController.text;
      setState(() {
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPT-3.5 Query'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _inputController,
              decoration: const InputDecoration(
                labelText: 'Enter your query',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _getGptResponse,
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text('Get Response'),
            ),
            const SizedBox(height: 20),
            if (_response.isNotEmpty)
              const Text(
                'Response:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            if (_response.isNotEmpty)
              Text(
                _response,
                style: const TextStyle(fontSize: 16),
              ),
            if (_error.isNotEmpty)
              const Text(
                'Error:',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}