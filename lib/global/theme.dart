import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class MaterialTheme {
  BuildContext context;
  static final TextTheme textTheme = GoogleFonts.acmeTextTheme().copyWith(
    displayLarge: GoogleFonts.racingSansOne(),
    displayMedium: GoogleFonts.gluten(),
    displaySmall: GoogleFonts.brunoAce(),
    headlineLarge: GoogleFonts.plusJakartaSans(),
    headlineMedium: GoogleFonts.plusJakartaSans(),
    headlineSmall: GoogleFonts.plusJakartaSans(),
    titleLarge: GoogleFonts.andika(),
    titleMedium: GoogleFonts.acme(),
    titleSmall: GoogleFonts.acme(),
    bodyLarge: GoogleFonts.acme(),
    bodyMedium: GoogleFonts.acme(),
    bodySmall: GoogleFonts.plusJakartaSans(),
    labelLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    labelMedium: GoogleFonts.poppins(),
    labelSmall: GoogleFonts.iceland(),
  );

  MaterialTheme(this.context);

  TextTheme getTextTheme() {
    return GoogleFonts.acmeTextTheme().copyWith(
      displayLarge: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(fontStyle: GoogleFonts.racingSansOne().fontStyle),
      displayMedium: Theme.of(context)
          .textTheme
          .displayMedium!
          .copyWith(fontStyle: GoogleFonts.gluten().fontStyle),
      displaySmall: Theme.of(context)
          .textTheme
          .displaySmall!
          .copyWith(fontStyle: GoogleFonts.abrilFatface().fontStyle),
      headlineLarge: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(fontStyle: GoogleFonts.ballet().fontStyle),
      headlineMedium: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(fontStyle: GoogleFonts.plusJakartaSans().fontStyle),
      headlineSmall: Theme.of(context)
          .textTheme
          .headlineSmall!
          .copyWith(fontStyle: GoogleFonts.amiriQuran().fontStyle),
      titleLarge: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(fontStyle: GoogleFonts.andika().fontStyle),
      titleMedium: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontStyle: GoogleFonts.moonDance().fontStyle),
      titleSmall: Theme.of(context)
          .textTheme
          .titleSmall!
          .copyWith(fontStyle: GoogleFonts.acme().fontStyle),
      bodyLarge: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontStyle: GoogleFonts.oregano().fontStyle),
      bodyMedium: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(fontStyle: GoogleFonts.piazzolla().fontStyle),
      bodySmall: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontStyle: GoogleFonts.brunoAce().fontStyle),
      labelLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
          fontStyle: GoogleFonts.poppins().fontStyle,
          fontWeight: FontWeight.w600),
      labelMedium: Theme.of(context)
          .textTheme
          .labelMedium!
          .copyWith(fontStyle: GoogleFonts.iceland().fontStyle),
      labelSmall: Theme.of(context)
          .textTheme
          .labelSmall!
          .copyWith(fontStyle: GoogleFonts.cherish().fontStyle),
    );
  }

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff65558f),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffe9ddff),
      onPrimaryContainer: Color(0xff201047),
      secondary: Color(0xff65558f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe9ddff),
      onSecondaryContainer: Color(0xff210f47),
      tertiary: Color(0xff68548e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffebdcff),
      onTertiaryContainer: Color(0xff230f46),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffdf7ff),
      onBackground: Color(0xff1d1b20),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff1d1b20),
      surfaceVariant: Color(0xffe7e0eb),
      onSurfaceVariant: Color(0xff49454e),
      outline: Color(0xff7a757f),
      outlineVariant: Color(0xffcac4cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inverseOnSurface: Color(0xfff5eff7),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff201047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4d3d75),
      secondaryFixed: Color(0xffe9ddff),
      onSecondaryFixed: Color(0xff210f47),
      secondaryFixedDim: Color(0xffd0bcfe),
      onSecondaryFixedVariant: Color(0xff4d3d75),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff230f46),
      tertiaryFixedDim: Color(0xffd3bcfd),
      onTertiaryFixedVariant: Color(0xff503c74),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e0e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff493971),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff7b6ba7),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff493971),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7c6ba6),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4c3970),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7f6aa5),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffdf7ff),
      onBackground: Color(0xff1d1b20),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff1d1b20),
      surfaceVariant: Color(0xffe7e0eb),
      onSurfaceVariant: Color(0xff45414a),
      outline: Color(0xff615d67),
      outlineVariant: Color(0xff7d7983),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inverseOnSurface: Color(0xfff5eff7),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xff7b6ba7),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff62538c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7c6ba6),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff63538c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7f6aa5),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff66528b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e0e9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff27174e),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff493971),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff28174e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff493971),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2a164d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4c3970),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffdf7ff),
      onBackground: Color(0xff1d1b20),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xffe7e0eb),
      onSurfaceVariant: Color(0xff25232b),
      outline: Color(0xff45414a),
      outlineVariant: Color(0xff45414a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xfff1e8ff),
      primaryFixed: Color(0xff493971),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff322359),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff493971),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff322259),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4c3970),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff352258),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffded8e0),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2fa),
      surfaceContainer: Color(0xfff2ecf4),
      surfaceContainerHigh: Color(0xffece6ee),
      surfaceContainerHighest: Color(0xffe6e0e9),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcfbdfe),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff36275d),
      primaryContainer: Color(0xff4d3d75),
      onPrimaryContainer: Color(0xffe9ddff),
      secondary: Color(0xffd0bcfe),
      onSecondary: Color(0xff36265d),
      secondaryContainer: Color(0xff4d3d75),
      onSecondaryContainer: Color(0xffe9ddff),
      tertiary: Color(0xffd3bcfd),
      onTertiary: Color(0xff39265c),
      tertiaryContainer: Color(0xff503c74),
      onTertiaryContainer: Color(0xffebdcff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff141218),
      onBackground: Color(0xffe6e0e9),
      surface: Color(0xff141218),
      onSurface: Color(0xffe6e0e9),
      surfaceVariant: Color(0xff49454e),
      onSurfaceVariant: Color(0xffcac4cf),
      outline: Color(0xff948f99),
      outlineVariant: Color(0xff49454e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e0e9),
      inverseOnSurface: Color(0xff322f35),
      inversePrimary: Color(0xff65558f),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff201047),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff4d3d75),
      secondaryFixed: Color(0xffe9ddff),
      onSecondaryFixed: Color(0xff210f47),
      secondaryFixedDim: Color(0xffd0bcfe),
      onSecondaryFixedVariant: Color(0xff4d3d75),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff230f46),
      tertiaryFixedDim: Color(0xffd3bcfd),
      onTertiaryFixedVariant: Color(0xff503c74),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff0f0d13),
      surfaceContainerLow: Color(0xff1d1b20),
      surfaceContainer: Color(0xff211f24),
      surfaceContainerHigh: Color(0xff2b292f),
      surfaceContainerHighest: Color(0xff36343a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd3c1ff),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff1b0942),
      primaryContainer: Color(0xff9887c5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd4c1ff),
      onSecondary: Color(0xff1b0941),
      secondaryContainer: Color(0xff9987c5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd7c0ff),
      onTertiary: Color(0xff1e0840),
      tertiaryContainer: Color(0xff9c86c3),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff141218),
      onBackground: Color(0xffe6e0e9),
      surface: Color(0xff141218),
      onSurface: Color(0xfffff9ff),
      surfaceVariant: Color(0xff49454e),
      onSurfaceVariant: Color(0xffcec8d4),
      outline: Color(0xffa6a1ab),
      outlineVariant: Color(0xff86818b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e0e9),
      inverseOnSurface: Color(0xff2b292f),
      inversePrimary: Color(0xff4e3f77),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff16033d),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff3c2d63),
      secondaryFixed: Color(0xffe9ddff),
      onSecondaryFixed: Color(0xff16033c),
      secondaryFixedDim: Color(0xffd0bcfe),
      onSecondaryFixedVariant: Color(0xff3c2c63),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff18023b),
      tertiaryFixedDim: Color(0xffd3bcfd),
      onTertiaryFixedVariant: Color(0xff3f2c62),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff0f0d13),
      surfaceContainerLow: Color(0xff1d1b20),
      surfaceContainer: Color(0xff211f24),
      surfaceContainerHigh: Color(0xff2b292f),
      surfaceContainerHighest: Color(0xff36343a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9ff),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffd3c1ff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd4c1ff),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9fe),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd7c0ff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff141218),
      onBackground: Color(0xffe6e0e9),
      surface: Color(0xff141218),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff49454e),
      onSurfaceVariant: Color(0xfffff9ff),
      outline: Color(0xffcec8d4),
      outlineVariant: Color(0xffcec8d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e0e9),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff2f2056),
      primaryFixed: Color(0xffede2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffd3c1ff),
      onPrimaryFixedVariant: Color(0xff1b0942),
      secondaryFixed: Color(0xffede2ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd4c1ff),
      onSecondaryFixedVariant: Color(0xff1b0941),
      tertiaryFixed: Color(0xffeee2ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffd7c0ff),
      onTertiaryFixedVariant: Color(0xff1e0840),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff0f0d13),
      surfaceContainerLow: Color(0xff1d1b20),
      surfaceContainer: Color(0xff211f24),
      surfaceContainerHigh: Color(0xff2b292f),
      surfaceContainerHighest: Color(0xff36343a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xff07bfc1),
    value: Color(0xff07bfc1),
    light: ColorFamily(
      color: Color(0xff00696b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff9cf1f2),
      onColorContainer: Color(0xff002020),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff00696b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff9cf1f2),
      onColorContainer: Color(0xff002020),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff00696b),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff9cf1f2),
      onColorContainer: Color(0xff002020),
    ),
    dark: ColorFamily(
      color: Color(0xff80d4d5),
      onColor: Color(0xff003737),
      colorContainer: Color(0xff004f50),
      onColorContainer: Color(0xff9cf1f2),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff80d4d5),
      onColor: Color(0xff003737),
      colorContainer: Color(0xff004f50),
      onColorContainer: Color(0xff9cf1f2),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff80d4d5),
      onColor: Color(0xff003737),
      colorContainer: Color(0xff004f50),
      onColorContainer: Color(0xff9cf1f2),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        customColor1,
      ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
