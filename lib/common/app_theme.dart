import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "app_constants.dart";

enum ContrastLevel { normal, medium, high }

class AppTheme {
  // Singleton instance
  static final AppTheme _instance = AppTheme._internal();
  factory AppTheme() => _instance;
  AppTheme._internal();

  // Dynamic text theme with dual font support
  TextTheme _textTheme = Typography.material2021().black;
  String _bodyFont = AppConstants.fontConfig;
  String _displayFont = AppConstants.fontConfig;

  // Getters
  TextTheme get textTheme => _textTheme;
  String get bodyFont => _bodyFont;
  String get displayFont => _displayFont;

  // Initialize with fonts
  void initialize([String? bodyFont, String? displayFont]) {
    _bodyFont = bodyFont ?? AppConstants.fontConfig;
    _displayFont = displayFont ?? AppConstants.fontConfig;
    _updateTextTheme();
  }

  // Update fonts dynamically
  void updateFonts({String? bodyFont, String? displayFont}) {
    if (bodyFont != null) _bodyFont = bodyFont;
    if (displayFont != null) _displayFont = displayFont;
    _updateTextTheme();
  }

  // Update with custom text theme
  void updateTextTheme(TextTheme customTextTheme) {
    _textTheme = customTextTheme;
    _bodyFont = 'Custom';
    _displayFont = 'Custom';
  }

  // Private method to update text theme using your logic
  void _updateTextTheme() {
    // Use Typography instead of Theme.of(context) for singleton
    final baseTextTheme = Typography.material2021().black;
    final bodyTextTheme = GoogleFonts.getTextTheme(_bodyFont, baseTextTheme);
    final displayTextTheme = GoogleFonts.getTextTheme(_displayFont, baseTextTheme);
    
    _textTheme = displayTextTheme.copyWith(
      bodyLarge: bodyTextTheme.bodyLarge,
      bodyMedium: bodyTextTheme.bodyMedium,
      bodySmall: bodyTextTheme.bodySmall,
      labelLarge: bodyTextTheme.labelLarge,
      labelMedium: bodyTextTheme.labelMedium,
      labelSmall: bodyTextTheme.labelSmall,
    );
  }

  // Detect system contrast and return appropriate theme
  ThemeData get adaptiveTheme {
    final systemBrightness = WidgetsBinding.instance.platformDispatcher.views.first.platformDispatcher.platformBrightness;
    
    // Check for high contrast (this would need platform-specific implementation)
    final isHighContrast = _detectHighContrast();
    final prefersMediumContrast = _detectMediumContrast();
    
    if (systemBrightness == Brightness.light) {
      if (isHighContrast) return lightHighContrast();
      if (prefersMediumContrast) return lightMediumContrast();
      return light();
    } else {
      if (isHighContrast) return darkHighContrast();
      if (prefersMediumContrast) return darkMediumContrast();
      return dark();
    }
  }

  // Detect high contrast (platform-specific)
  bool _detectHighContrast() {
    // iOS: Check UIAccessibilityIsReduceTransparencyEnabled
    // Android: Check AccessibilityManager.isHighTextContrastEnabled
    // For now, return false - would need platform channel implementation
    return false;
  }

  // Detect medium contrast preference
  bool _detectMediumContrast() {
    // This could be stored in user preferences
    // For now, return false
    return false;
  }

  // Manual contrast override for user settings
  void setContrastLevel(ContrastLevel level) {
    // Store user preference and update theme
    // This would typically be saved to SharedPreferences
    _userContrastLevel = level;
  }

  ContrastLevel _userContrastLevel = ContrastLevel.normal;
  ContrastLevel get userContrastLevel => _userContrastLevel;

  // Get theme based on user preference
  ThemeData getThemeForContrastLevel(ContrastLevel level, Brightness brightness) {
    if (brightness == Brightness.light) {
      switch (level) {
        case ContrastLevel.medium:
          return lightMediumContrast();
        case ContrastLevel.high:
          return lightHighContrast();
        default:
          return light();
      }
    } else {
      switch (level) {
        case ContrastLevel.medium:
          return darkMediumContrast();
        case ContrastLevel.high:
          return darkHighContrast();
        default:
          return dark();
      }
    }
  }

  ThemeData light() => theme(lightScheme());
  ThemeData lightMediumContrast() => theme(lightMediumContrastScheme());
  ThemeData lightHighContrast() => theme(lightHighContrastScheme());
  ThemeData dark() => theme(darkScheme());
  ThemeData darkMediumContrast() => theme(darkMediumContrastScheme());
  ThemeData darkHighContrast() => theme(darkHighContrastScheme());

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff645f3f),
      surfaceTint: Color(0xff645f3f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xfffff7cd),
      onPrimaryContainer: Color(0xff76714f),
      secondary: Color(0xff805439),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfffdc3a1),
      onSecondaryContainer: Color(0xff794e34),
      tertiary: Color(0xff94483f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffb9b8f),
      onTertiaryContainer: Color(0xff763129),
      error: Color(0xffa33759),
      onError: Color(0xffffffff),
      errorContainer: Color(0xfff57799),
      onErrorContainer: Color(0xff6e0a32),
      surface: Color(0xfffdf9f4),
      onSurface: Color(0xff1c1b19),
      onSurfaceVariant: Color(0xff49473d),
      outline: Color(0xff7a776c),
      outlineVariant: Color(0xffcbc6b9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff32302d),
      inversePrimary: Color(0xffcec7a0),
      primaryFixed: Color(0xffebe3ba),
      onPrimaryFixed: Color(0xff1f1c03),
      primaryFixedDim: Color(0xffcec7a0),
      onPrimaryFixedVariant: Color(0xff4c4729),
      secondaryFixed: Color(0xffffdbc8),
      onSecondaryFixed: Color(0xff311301),
      secondaryFixedDim: Color(0xfff3ba99),
      onSecondaryFixedVariant: Color(0xff653d24),
      tertiaryFixed: Color(0xffffdad5),
      onTertiaryFixed: Color(0xff3d0604),
      tertiaryFixedDim: Color(0xffffb4aa),
      onTertiaryFixedVariant: Color(0xff76312a),
      surfaceDim: Color(0xffddd9d5),
      surfaceBright: Color(0xfffdf9f4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3ee),
      surfaceContainer: Color(0xfff2ede8),
      surfaceContainerHigh: Color(0xffece7e3),
      surfaceContainerHighest: Color(0xffe6e2dd),
    );
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3a371a),
      surfaceTint: Color(0xff645f3f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff736e4c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff512d15),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff906346),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff61211b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa6564c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff6d0931),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffb64667),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf9f4),
      onSurface: Color(0xff12110f),
      onSurfaceVariant: Color(0xff38362d),
      outline: Color(0xff555248),
      outlineVariant: Color(0xff706d62),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff32302d),
      inversePrimary: Color(0xffcec7a0),
      primaryFixed: Color(0xff736e4c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff5a5536),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff906346),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff754b30),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffa6564c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff883f36),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcac6c1),
      surfaceBright: Color(0xfffdf9f4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3ee),
      surfaceContainer: Color(0xffece7e3),
      surfaceContainerHigh: Color(0xffe0dcd7),
      surfaceContainerHighest: Color(0xffd5d1cc),
    );
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff302d11),
      surfaceTint: Color(0xff645f3f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4e4a2b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff45230c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff674026),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff541712),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff79332c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e0027),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff872144),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf9f4),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2e2c23),
      outlineVariant: Color(0xff4c493f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff32302d),
      inversePrimary: Color(0xffcec7a0),
      primaryFixed: Color(0xff4e4a2b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff373317),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff674026),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4d2a12),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff79332c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff5c1d18),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbcb8b4),
      surfaceBright: Color(0xfffdf9f4),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f0eb),
      surfaceContainer: Color(0xffe6e2dd),
      surfaceContainerHigh: Color(0xffd8d4cf),
      surfaceContainerHighest: Color(0xffcac6c1),
    );
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffcec7a0),
      onPrimary: Color(0xff353115),
      primaryContainer: Color(0xffebe3ba),
      onPrimaryContainer: Color(0xff6a6544),
      secondary: Color(0xffffe7da),
      onSecondary: Color(0xff4a2810),
      secondaryContainer: Color(0xfffdc3a1),
      onSecondaryContainer: Color(0xff794e34),
      tertiary: Color(0xffffc1b9),
      onTertiary: Color(0xff591b16),
      tertiaryContainer: Color(0xfffb9b8f),
      onTertiaryContainer: Color(0xff763129),
      error: Color(0xffffb1c2),
      onError: Color(0xff65022b),
      errorContainer: Color(0xfff57799),
      onErrorContainer: Color(0xff6e0a32),
      surface: Color(0xff141311),
      onSurface: Color(0xffe6e2dd),
      onSurfaceVariant: Color(0xffcbc6b9),
      outline: Color(0xff949184),
      outlineVariant: Color(0xff49473d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e2dd),
      inversePrimary: Color(0xff645f3f),
      primaryFixed: Color(0xffebe3ba),
      onPrimaryFixed: Color(0xff1f1c03),
      primaryFixedDim: Color(0xffcec7a0),
      onPrimaryFixedVariant: Color(0xff4c4729),
      secondaryFixed: Color(0xffffdbc8),
      onSecondaryFixed: Color(0xff311301),
      secondaryFixedDim: Color(0xfff3ba99),
      onSecondaryFixedVariant: Color(0xff653d24),
      tertiaryFixed: Color(0xffffdad5),
      onTertiaryFixed: Color(0xff3d0604),
      tertiaryFixedDim: Color(0xffffb4aa),
      onTertiaryFixedVariant: Color(0xff76312a),
      surfaceDim: Color(0xff141311),
      surfaceBright: Color(0xff3a3936),
      surfaceContainerLowest: Color(0xff0f0e0c),
      surfaceContainerLow: Color(0xff1c1b19),
      surfaceContainer: Color(0xff201f1d),
      surfaceContainerHigh: Color(0xff2b2a27),
      surfaceContainerHighest: Color(0xff363531),
    );
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffcec7a0),
      onPrimary: Color(0xff353115),
      primaryContainer: Color(0xffebe3ba),
      onPrimaryContainer: Color(0xff4d492a),
      secondary: Color(0xffffe7da),
      onSecondary: Color(0xff4a2810),
      secondaryContainer: Color(0xfffdc3a1),
      onSecondaryContainer: Color(0xff58331a),
      tertiary: Color(0xffffd2cc),
      onTertiary: Color(0xff4b100c),
      tertiaryContainer: Color(0xfffb9b8f),
      onTertiaryContainer: Color(0xff4f140f),
      error: Color(0xffffd1d9),
      onError: Color(0xff520021),
      errorContainer: Color(0xfff57799),
      onErrorContainer: Color(0xff300011),
      surface: Color(0xff141311),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe1dcce),
      outline: Color(0xffb6b2a5),
      outlineVariant: Color(0xff949084),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e2dd),
      inversePrimary: Color(0xff4d492a),
      primaryFixed: Color(0xffebe3ba),
      onPrimaryFixed: Color(0xff141100),
      primaryFixedDim: Color(0xffcec7a0),
      onPrimaryFixedVariant: Color(0xff3a371a),
      secondaryFixed: Color(0xffffdbc8),
      onSecondaryFixed: Color(0xff220a00),
      secondaryFixedDim: Color(0xfff3ba99),
      onSecondaryFixedVariant: Color(0xff512d15),
      tertiaryFixed: Color(0xffffdad5),
      onTertiaryFixed: Color(0xff2d0001),
      tertiaryFixedDim: Color(0xffffb4aa),
      onTertiaryFixedVariant: Color(0xff61211b),
      surfaceDim: Color(0xff141311),
      surfaceBright: Color(0xff464441),
      surfaceContainerLowest: Color(0xff080706),
      surfaceContainerLow: Color(0xff1e1d1b),
      surfaceContainer: Color(0xff292825),
      surfaceContainerHigh: Color(0xff34322f),
      surfaceContainerHighest: Color(0xff3f3d3a),
    );
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffffff),
      surfaceTint: Color(0xffcec7a0),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffebe3ba),
      onPrimaryContainer: Color(0xff2e2b0f),
      secondary: Color(0xffffece3),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xfffdc3a1),
      onSecondaryContainer: Color(0xff301301),
      tertiary: Color(0xffffece9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffaea4),
      onTertiaryContainer: Color(0xff220000),
      error: Color(0xffffebee),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffabbe),
      onErrorContainer: Color(0xff210009),
      surface: Color(0xff141311),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff5f0e2),
      outlineVariant: Color(0xffc7c2b5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e2dd),
      inversePrimary: Color(0xff4d492a),
      primaryFixed: Color(0xffebe3ba),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffcec7a0),
      onPrimaryFixedVariant: Color(0xff141100),
      secondaryFixed: Color(0xffffdbc8),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfff3ba99),
      onSecondaryFixedVariant: Color(0xff220a00),
      tertiaryFixed: Color(0xffffdad5),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb4aa),
      onTertiaryFixedVariant: Color(0xff2d0001),
      surfaceDim: Color(0xff141311),
      surfaceBright: Color(0xff52504c),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f1d),
      surfaceContainer: Color(0xff32302d),
      surfaceContainerHigh: Color(0xff3d3b38),
      surfaceContainerHighest: Color(0xff484743),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: _textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );
}

extension ThemeExtension on BuildContext {
  /// Get color scheme from current theme
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Get text theme from current theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Common color getters for convenience
  Color get primaryColor => colors.primary;
  Color get onPrimaryColor => colors.onPrimary;
  Color get secondaryColor => colors.secondary;
  Color get onSecondaryColor => colors.onSecondary;
  Color get surfaceColor => colors.surface;
  Color get onSurfaceColor => colors.onSurface;
  Color get errorColor => colors.error;
  Color get onErrorColor => colors.onError;
  Color get backgroundColor => colors.surface;
  Color get onBackgroundColor => colors.onSurface;

  /// Common text style getters
  TextStyle get headlineStyle => textTheme.headlineMedium!;
  TextStyle get titleStyle => textTheme.titleLarge!;
  TextStyle get bodyStyle => textTheme.bodyMedium!;
  TextStyle get captionStyle => textTheme.bodySmall!;
}

// Global instance for easy access
final theme = AppTheme();
