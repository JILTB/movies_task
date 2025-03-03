import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({
    super.key,
    this.title,
    required this.imageUrl,
    required this.imdbRating,
    required this.userRating,
    required this.onTap,
  });

  final String? title;
  final String? imageUrl;
  final double? imdbRating;
  final double userRating;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: onTap,
        child: Column(
          children: [
            Text(title ?? 'No Title', style: TextStyle(fontSize: 28)),
            SizedBox(height: 8),
            imageUrl != null
                ? SizedBox(
                  height: 300,
                  width: 300,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    errorWidget:
                        (context, url, error) => Icon(Symbols.no_photography),
                    progressIndicatorBuilder:
                        (context, url, progress) =>
                            CircularProgressIndicator.adaptive(),
                  ),
                )
                : Icon(Symbols.no_photography),
            SizedBox(height: 8),
            if (imdbRating != null)
              Text('IMBD rating: $imdbRating', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              'user rating : ${userRating.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
