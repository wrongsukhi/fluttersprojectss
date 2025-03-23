import 'package:flutter/material.dart';
import 'second_screen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  final List<String> assetImages = const [
    'assets/image1.jpeg',
    'assets/image2.jpeg',
    'assets/image3.jpeg',
    'assets/image4.jpeg',
  ];

  final List<String> networkImages = const [
    'https://picsum.photos/id/237/400/300',
    'https://picsum.photos/id/238/400/300',
    'https://picsum.photos/id/239/400/300',
    'https://picsum.photos/id/240/400/300',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> allImages = [...assetImages, ...networkImages];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200], // Light background
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: allImages.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: allImages[index].startsWith('assets/')
                        ? Image.asset(
                            allImages[index],
                            width: 250, // Adjusted width
                            height: 180, // Adjusted height
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            allImages[index],
                            width: 250, 
                            height: 180, 
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Beautiful Image",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SecondScreen()),
          );
        },
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
