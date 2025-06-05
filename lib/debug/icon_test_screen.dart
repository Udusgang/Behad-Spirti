import 'package:flutter/material.dart';
import 'dart:io';

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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
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
                        Text('Test Icons'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _testInternetConnection(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi),
                        SizedBox(width: 8),
                        Text('Test Internet'),
                      ],
                    ),
                  ),
                ),
              ],
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

  Future<void> _testInternetConnection(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Testing internet connection...'),
          ],
        ),
      ),
    );

    try {
      // Test basic connectivity
      final result = await InternetAddress.lookup('google.com');
      Navigator.pop(context); // Close loading dialog

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Test YouTube specifically
        try {
          final youtubeResult = await InternetAddress.lookup('youtube.com');
          if (youtubeResult.isNotEmpty) {
            _showConnectionResult(
              context,
              '✅ Internet Connection: SUCCESS\n'
              '✅ Google Access: Available\n'
              '✅ YouTube Access: Available\n'
              '🎬 Ready for video streaming!',
              true,
            );
          }
        } catch (e) {
          _showConnectionResult(
            context,
            '✅ Internet Connection: SUCCESS\n'
            '✅ Google Access: Available\n'
            '❌ YouTube Access: BLOCKED\n'
            '⚠️ YouTube may be restricted',
            false,
          );
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showConnectionResult(
        context,
        '❌ Internet Connection: FAILED\n'
        '❌ No network access detected\n'
        '📱 Check your WiFi/Mobile data\n'
        '🔧 Verify app permissions',
        false,
      );
    }
  }

  void _showConnectionResult(BuildContext context, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(isSuccess ? 'Connection Test' : 'Connection Issue'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
