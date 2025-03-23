import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  final List<String> allImages = const [
    'assets/image1.jpeg',
    'assets/image2.jpeg',
    'assets/image3.jpeg',
    'assets/image4.jpeg',
    'https://picsum.photos/id/237/400/300',
    'https://picsum.photos/id/238/400/300',
    'https://picsum.photos/id/239/400/300',
    'https://picsum.photos/id/240/400/300',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vertical PageView Images')),
      body: PageView.builder(
        scrollDirection: Axis.vertical, // ✅ Scrolls Vertically
        itemCount: allImages.length,
        itemBuilder: (context, index) {
          return Center( // ✅ Centers the image
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // ✅ 80% of screen width
              height: MediaQuery.of(context).size.height * 0.6, // ✅ 60% of screen height
              margin: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: allImages[index].startsWith('assets/')
                    ? Image.asset(allImages[index], fit: BoxFit.cover)
                    : Image.network(allImages[index], fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}
