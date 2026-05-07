import 'package:flutter/material.dart';

enum ScreenPreset {
  compact,
  comfortable,
  spacious,
}

class PresetTokens {
  const PresetTokens({
    required this.maxContentWidth,
    required this.padding,
    required this.mobileGridCount,
    required this.tabletGridCount,
    required this.desktopGridCount,
    required this.spacing,
  });

  final double maxContentWidth;
  final EdgeInsets padding;
  final int mobileGridCount;
  final int tabletGridCount;
  final int desktopGridCount;
  final double spacing;

  static PresetTokens fromPreset(ScreenPreset preset) {
    switch (preset) {
      case ScreenPreset.compact:
        return const PresetTokens(
          maxContentWidth: 960,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          mobileGridCount: 1,
          tabletGridCount: 2,
          desktopGridCount: 3,
          spacing: 10,
        );
      case ScreenPreset.comfortable:
        return const PresetTokens(
          maxContentWidth: 1200,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          mobileGridCount: 2,
          tabletGridCount: 3,
          desktopGridCount: 4,
          spacing: 12,
        );
      case ScreenPreset.spacious:
        return const PresetTokens(
          maxContentWidth: 1400,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          mobileGridCount: 2,
          tabletGridCount: 4,
          desktopGridCount: 5,
          spacing: 16,
        );
    }
  }
}
