import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/widgets.dart';

extension DeviceExtension on BuildContext {
  double get pixelsPerInch => Platform.isAndroid || Platform.isIOS? 150 : 96;

  /// Returns same as MediaQuery.of(context)
  MediaQueryData get mq => MediaQuery.of(this);

  /// Returns if Orientation is landscape
  bool get isLandscape => mq.orientation == Orientation.landscape;

  /// Returns same as MediaQuery.of(context).size
  Size get sizePx => mq.size;

  /// Returns same as MediaQuery.of(context).size.width
  double get widthPx => sizePx.width;

  /// Returns same as MediaQuery.of(context).height
  double get heightPx => sizePx.height;

  /// Returns same as MediaQuery.of(context).
  double get aspect => sizePx.aspectRatio;

  /// Returns same as MediaQuery.of(context).devicePixelRatio
  double get density => mq.devicePixelRatio;

  /// Returns diagonal screen pixels
  double get diagonalPx {
    final Size s = sizePx;
    return sqrt((s.width * s.width) + (s.height * s.height));
  }

  /// Returns pixel size in Inches
  Size get sizeInches {
    final Size pxSize = sizePx;
    return Size(pxSize.width / pixelsPerInch, pxSize.height / pixelsPerInch);
  }

  /// Returns screen width in Inches
  double get widthInches => sizeInches.width;

  /// Returns screen height in Inches
  double get heightInches => sizeInches.height;

  /// Returns screen diagonal in Inches
  double get diagonalInches => diagonalPx / pixelsPerInch;

  /// Returns fraction (0-1) of screen width in pixels
  double widthPct(double fraction) => fraction * widthPx;

  /// Returns fraction (0-1) of screen height in pixels
  double heightPct(double fraction) => fraction * heightPx;

  // ignore: deprecated_member_use
  double get textScale => mq.textScaler.textScaleFactor;

  double get scaleText {
    const designWidth = 1024.0;
    const baseHintSize = 10.0;
    final scaleFactor = sizePx.width / designWidth;
    return baseHintSize * scaleFactor;
  }
}