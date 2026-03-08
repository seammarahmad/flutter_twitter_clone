import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarousalImage extends StatefulWidget {
  final List<String> imageslinks;

  const CarousalImage({super.key, required this.imageslinks});

  @override
  State<CarousalImage> createState() => _CarousalImageState();
}

class _CarousalImageState extends State<CarousalImage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageslinks.map((file) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Image.network(file, fit: BoxFit.contain),
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                height: 400,
                enableInfiniteScroll: false,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageslinks.asMap().entries.map((toElement) {
                return Container(
                  width: 08,
                  height: 08,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == toElement.key
                        ? Colors.white
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
