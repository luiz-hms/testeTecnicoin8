import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/theme_cubit.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/white_label_data.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<HomeCarousel> createState() => _HomeCarouselState();
}

class _HomeCarouselState extends State<HomeCarousel> {
  final CarouselSliderController _controller = CarouselSliderController();
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final defaultBannerImages = const [
          "https://picsum.photos/seed/banner1/1200/500",
          "https://picsum.photos/seed/banner2/1200/500",
          "https://picsum.photos/seed/banner3/1200/500",
          "https://picsum.photos/seed/banner4/1200/500",
        ];

        final primaryColor = (state is ThemeLoaded)
            ? state.theme.primaryColor
            : const Color(0xFF1976D2);

        return FutureBuilder(
          future: WhiteLabelData.getBanners(),
          builder: (context, snapshot) {
            final customBanners = snapshot.data ?? [];
            final hasCustomBanners = customBanners.isNotEmpty;

            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 280,
                  child: CarouselSlider.builder(
                    carouselController: _controller,
                    itemCount: hasCustomBanners
                        ? customBanners.length
                        : defaultBannerImages.length,
                    itemBuilder: (context, index, realIndex) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: hasCustomBanners
                            ? Image.memory(
                                customBanners[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.network(
                                defaultBannerImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                    options: CarouselOptions(
                      height: 280,
                      autoPlay: true,
                      enlargeCenterPage: false,
                      viewportFraction: 1.0,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Indicador animado suave
                AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: hasCustomBanners
                      ? customBanners.length
                      : defaultBannerImages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: primaryColor,
                    dotColor: Colors.grey.shade300,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                    spacing: 8,
                  ),
                  onDotClicked: (index) => _controller.animateToPage(index),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
