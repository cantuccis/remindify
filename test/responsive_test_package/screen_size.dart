import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

final responsiveVariant = ValueVariant<ScreenSize>({
    iPhone8,
    iPhone13ProMax,
    desktop,
});

class ScreenSize {
    const ScreenSize(this.name, this.width, this.height, this.pixelDensity);
    final String name;
    final double width, height, pixelDensity;
}

const iPhone8 = ScreenSize('iPhone_8', 414, 736, 3);
const iPhone13ProMax = ScreenSize('iPhone_13_Pro_Max', 414, 896, 3);
const desktop = ScreenSize('Desktop', 1920, 1080, 1);

extension ScreenSizeManager on WidgetTester {
  Future<void> setScreenSize(ScreenSize screenSize) async {
    return _setScreenSize(
      width: screenSize.width,
      height: screenSize.height,
      pixelDensity: screenSize.pixelDensity,
    );
  }

  Future<void> _setScreenSize({
        required double width,
        required double height,
        required double pixelDensity,
  }) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }
}

@isTest
void testResponsiveWidgets(
  String description,
  WidgetTesterCallback callback, {
  Future<void> Function(String sizeName, WidgetTester tester)? goldenCallback,
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  ValueVariant<ScreenSize>? breakpoints,
  dynamic tags,
}) {
  final variant = breakpoints ?? responsiveVariant;
  testWidgets(
    description,
    (tester) async {
      await tester.setScreenSize(variant.currentValue!);
      await callback(tester);
      if (goldenCallback != null) {
        await goldenCallback(variant.currentValue!.name, tester);
      }
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}