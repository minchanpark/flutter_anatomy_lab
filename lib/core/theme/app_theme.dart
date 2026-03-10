import 'package:flutter/material.dart';

class AppTheme {
  static const Color _background = Color(0xFFF5F7FB);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _surfaceSubtle = Color(0xFFF0F4FA);
  static const Color _border = Color(0xFFD9E2EF);
  static const Color _accent = Color(0xFF1C5ED6);
  static const Color _textPrimary = Color(0xFF162033);
  static const Color _textSecondary = Color(0xFF5B677B);
  static const Color _success = Color(0xFF18794E);
  static const Color _warning = Color(0xFF9A6700);
  static const Color _danger = Color(0xFFB42318);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _accent,
      brightness: Brightness.light,
    ).copyWith(
      primary: _accent,
      secondary: const Color(0xFF3A7CFF),
      surface: _surface,
      surfaceContainerHighest: _surfaceSubtle,
      outline: _border,
      onSurface: _textPrimary,
      onSurfaceVariant: _textSecondary,
      error: _danger,
    );

    final baseTextTheme = ThemeData.light().textTheme;
    final textTheme = baseTextTheme.copyWith(
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: _textPrimary,
        height: 1.1,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: _textPrimary,
        height: 1.2,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: _textPrimary,
        height: 1.2,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: _textPrimary,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: _textPrimary,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        color: _textPrimary,
        height: 1.6,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        color: _textPrimary,
        height: 1.6,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        color: _textSecondary,
        height: 1.5,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        color: _textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _background,
      textTheme: textTheme,
      dividerColor: _border,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: _textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _border),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: const BorderSide(color: _border),
        backgroundColor: _surfaceSubtle,
        selectedColor: _surface,
        labelStyle: textTheme.labelSmall ?? const TextStyle(),
      ),
      dividerTheme: const DividerThemeData(
        color: _border,
        thickness: 1,
        space: 1,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textPrimary,
          side: const BorderSide(color: _border),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _accent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
      extensions: const [
        AppThemeTokens(
          background: _background,
          surface: _surface,
          surfaceSubtle: _surfaceSubtle,
          border: _border,
          accent: _accent,
          textPrimary: _textPrimary,
          textSecondary: _textSecondary,
          success: _success,
          warning: _warning,
          danger: _danger,
        ),
      ],
    );
  }
}

@immutable
class AppThemeTokens extends ThemeExtension<AppThemeTokens> {
  const AppThemeTokens({
    required this.background,
    required this.surface,
    required this.surfaceSubtle,
    required this.border,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.danger,
  });

  final Color background;
  final Color surface;
  final Color surfaceSubtle;
  final Color border;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color danger;

  static const AppThemeTokens fallback = AppThemeTokens(
    background: Color(0xFFF5F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceSubtle: Color(0xFFF0F4FA),
    border: Color(0xFFD9E2EF),
    accent: Color(0xFF1C5ED6),
    textPrimary: Color(0xFF162033),
    textSecondary: Color(0xFF5B677B),
    success: Color(0xFF18794E),
    warning: Color(0xFF9A6700),
    danger: Color(0xFFB42318),
  );

  static AppThemeTokens of(BuildContext context) {
    return Theme.of(context).extension<AppThemeTokens>() ?? fallback;
  }

  @override
  AppThemeTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceSubtle,
    Color? border,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? danger,
  }) {
    return AppThemeTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceSubtle: surfaceSubtle ?? this.surfaceSubtle,
      border: border ?? this.border,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
    );
  }

  @override
  ThemeExtension<AppThemeTokens> lerp(
    covariant ThemeExtension<AppThemeTokens>? other,
    double t,
  ) {
    if (other is! AppThemeTokens) {
      return this;
    }

    return AppThemeTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSubtle: Color.lerp(surfaceSubtle, other.surfaceSubtle, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
    );
  }
}
