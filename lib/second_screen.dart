import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

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
      appBar: AppBar(title: const Text('Horizontal Image Scroll')),
      body: Center(
        child: SizedBox(
          height: 300, // Image container height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            itemCount: allImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: allImages[index].startsWith('assets/')
                      ? Image.asset(allImages[index], fit: BoxFit.cover)
                      : Image.network(allImages[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
