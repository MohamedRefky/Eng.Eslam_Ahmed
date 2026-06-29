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
              return _FeedbackImageItem(imagePath: imagePath);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FeedbackImageItem extends StatefulWidget {
  final String imagePath;
  const _FeedbackImageItem({required this.imagePath});

  @override
  State<_FeedbackImageItem> createState() => _FeedbackImageItemState();
}

class _FeedbackImageItemState extends State<_FeedbackImageItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Container(
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
                if (_isHovered)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.open_in_full, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)?.translate('tap_to_zoom') ?? 'Open Image',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
