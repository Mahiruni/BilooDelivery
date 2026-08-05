import 'package:biloo_ui/biloo_ui.dart';
import 'package:flutter/material.dart';

class NetworkFoodImage extends StatelessWidget {
  const NetworkFoodImage({
    required this.url,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? progress,
      ) {
        if (progress == null) {
          return child;
        }
        return const ColoredBox(
          color: BilooColors.skyBlue,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return const ColoredBox(
          color: BilooColors.amberSoft,
          child: Center(
            child: Icon(
              Icons.restaurant_rounded,
              color: BilooColors.royalBlue,
              size: 38,
            ),
          ),
        );
      },
    );
  }
}
