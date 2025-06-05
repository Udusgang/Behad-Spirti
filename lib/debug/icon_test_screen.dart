import 'package:flutter/material.dart';

class IconTestScreen extends StatelessWidget {
  const IconTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Test'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Testing Material Icons:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Test basic icons
            _buildIconRow('Home', Icons.home),
            _buildIconRow('Play Arrow', Icons.play_arrow),
            _buildIconRow('Pause', Icons.pause),
            _buildIconRow('Settings', Icons.settings),
            _buildIconRow('Person', Icons.person),
            _buildIconRow('Star', Icons.star),
            _buildIconRow('Favorite', Icons.favorite),
            _buildIconRow('Search', Icons.search),
            _buildIconRow('Menu', Icons.menu),
            _buildIconRow('Close', Icons.close),
            
            const SizedBox(height: 20),
            const Text(
              'If you see squares instead of icons, Material Icons are not loading.',
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Icons test completed'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle),
                  SizedBox(width: 8),
                  Text('Test Button'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRow(String name, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.blue,
          ),
          const SizedBox(width: 16),
          Text(name),
          const Spacer(),
          Text(
            'Code: ${icon.codePoint.toRadixString(16)}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
