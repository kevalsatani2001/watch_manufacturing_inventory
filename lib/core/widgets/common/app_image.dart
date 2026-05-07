import 'dart:typed_data';

import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.filterQuality = FilterQuality.medium,
    this.color,
    this.colorBlendMode,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.opacity,
    this.errorBuilder,
    this.frameBuilder,
    this.loadingBuilder,
  });

  factory AppImage.asset(
    String assetName, {
    Key? key,
    AssetBundle? bundle,
    String? package,
    double? scale,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    FilterQuality filterQuality = FilterQuality.medium,
    Color? color,
    BlendMode? colorBlendMode,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    Animation<double>? opacity,
    ImageErrorWidgetBuilder? errorBuilder,
    ImageFrameBuilder? frameBuilder,
  }) {
    return AppImage(
      key: key,
      image: AssetImage(assetName, bundle: bundle, package: package),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      errorBuilder: errorBuilder,
      frameBuilder: frameBuilder,
    );
  }

  factory AppImage.network(
    String src, {
    Key? key,
    Map<String, String>? headers,
    double scale = 1.0,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    FilterQuality filterQuality = FilterQuality.medium,
    Color? color,
    BlendMode? colorBlendMode,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    Animation<double>? opacity,
    ImageErrorWidgetBuilder? errorBuilder,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
  }) {
    return AppImage(
      key: key,
      image: NetworkImage(src, scale: scale, headers: headers),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      errorBuilder: errorBuilder,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
    );
  }

  factory AppImage.memory(
    Uint8List bytes, {
    Key? key,
    double scale = 1.0,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    bool matchTextDirection = false,
    FilterQuality filterQuality = FilterQuality.medium,
    Color? color,
    BlendMode? colorBlendMode,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    Animation<double>? opacity,
    ImageErrorWidgetBuilder? errorBuilder,
    ImageFrameBuilder? frameBuilder,
  }) {
    return AppImage(
      key: key,
      image: MemoryImage(bytes, scale: scale),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      errorBuilder: errorBuilder,
      frameBuilder: frameBuilder,
    );
  }

  final ImageProvider image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final FilterQuality filterQuality;
  final Color? color;
  final BlendMode? colorBlendMode;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final Animation<double>? opacity;
  final ImageErrorWidgetBuilder? errorBuilder;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      opacity: opacity,
      errorBuilder: errorBuilder,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
    );
  }
}
