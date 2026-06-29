import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../core/widgets/section_title.dart';
import '../core/utils/app_localizations.dart';
import '../core/data/office_data.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> feedbackImages = List<String>.from(
      OfficeData.data['feedbackImages'] ?? [],
    );

    final double screenWidth = MediaQuery.of(context).size.width;
    final double carouselHeight = screenWidth > 800 ? 500 : 300;
    final double viewportFraction = screenWidth > 800 ? 0.4 : 0.85;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          SectionTitle(title: AppLocalizations.of(context)!.translate('reviews_title')),
          const SizedBox(height: 32),
          CarouselSlider(
            options: CarouselOptions(
              height: carouselHeight,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              viewportFraction: viewportFraction,
            ),
            items: feedbackImages.map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
