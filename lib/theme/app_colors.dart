import 'package:flutter/material.dart';

/// Palet warna pastel yang dipakai di seluruh aplikasi.
class AppColors {
  AppColors._();

  static const background = Color(0xFFFFF8F3); // krem lembut
  static const surface = Colors.white;
  static const textDark = Color(0xFF4A4458);
  static const textSoft = Color(0xFF8E889C);
  static const accent = Color(0xFFB39DDB); // ungu pastel
  static const accentDark = Color(0xFF8E75C9);
  static const star = Color(0xFFFFC46B);

  static const pink = Color(0xFFFAD4E1);
  static const peach = Color(0xFFFFDCC4);
  static const yellow = Color(0xFFFFF1B8);
  static const mint = Color(0xFFCDF0DD);
  static const sky = Color(0xFFC6E2FB);
  static const lavender = Color(0xFFDDD2F7);

  /// Warna kartu yang dipakai bergantian.
  static const cardColors = <Color>[pink, mint, sky, peach, lavender, yellow];

  static Color cardColor(int index) => cardColors[index % cardColors.length];
}
