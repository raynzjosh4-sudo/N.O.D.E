import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:node_app/core/utils/responsive_size.dart';

/// The [NodeImage] widget is the core asset optimization component.
/// It automatically appends Cloudflare Edge parameters to URLs to
/// perform on-the-fly resizing and WebP conversion for Ugandan mobile users.
class NodeImage extends StatelessWidget {
  final String path; // e.g., 'products/conical_net_01.jpg'
  final double? width;
  final double? height;
  final BoxFit fit;
  final int quality;
  final Widget? placeholder;
  final Widget? errorWidget;

  NodeImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.quality = 75,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['R2_PUBLIC_URL'] ?? '';

    // 🚀 THE MAGIC: Append Cloudflare transform parameters.
    // On web, we skip optimization to avoid potential CORS issues with the resizing proxy.
    final optimizedUrl = kIsWeb
        ? "$baseUrl/$path"
        : "$baseUrl/$path?w=${(width ?? 800).toInt()}&q=$quality&format=auto";

    if (kIsWeb) {
      return Image.network(
        optimizedUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            errorWidget ?? _buildDefaultError(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildDefaultPlaceholder();
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: optimizedUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _buildDefaultError(),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}
