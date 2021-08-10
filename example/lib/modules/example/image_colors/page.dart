import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

import 'controller.dart';

class ImageColorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ImageColorsController controller = Get.put(ImageColorsController());

    void _onImagePickerClicked() async {
      final selected = await showBaseModalBottomSheet<int>(
        context: context,
        builder: (context) => BaseActionSheet(
          actions: <Widget>[
            BaseActionSheetAction(
              child: BaseText('拍照'),
              onPressed: () {
                back(0);
              },
            ),
            BaseActionSheetAction(
              child: BaseText('从相册选择'),
              onPressed: () {
                back(1);
              },
            ),
          ],
          cancelButton: BaseActionSheetAction(
            child: BaseText('取消'),
            isDestructiveAction: true,
            onPressed: () {
              back();
            },
          ),
        ),
      );

      final ImagePicker _picker = ImagePicker();
      String? path;
      if (selected == 0) {
        // 调用相机
        path = (await _picker.getImage(source: ImageSource.camera))?.path;
      } else if (selected == 1) {
        // 调用相册
        path = (await _picker.getImage(source: ImageSource.gallery))?.path;
      }
      if (path != null) {
        controller.updateFile(File(path));
      }
    }

    return BaseScaffold(
      appBar: BaseAppBar(
        title:
            BaseText(S.of(context).example_ExtractProminentColorsFromAnImage),
        actions: [
          BaseButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _onImagePickerClicked();
            },
          ),
        ],
      ),
      body: GetX<ImageColorsController>(
        builder: (controller) {
          if (controller.imagePath.isNotEmpty &&
              controller.paletteGenerator != null) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.file(
                    File(controller.imagePath.value),
                    width: screenWidthDp,
                  ),
                  Container(
                      margin: EdgeInsets.all(15),
                      child: PaletteSwatches(
                          generator: controller.paletteGenerator!.value)),
                ],
              ),
            );
          } else {
            return Center(child: BaseText("Selected Image"));
          }
        },
      ),
    );
  }
}

/// use the PaletteGenerator Dart class in your code. To see how this is done, check out the image_colors example app.
/// https://github.com/flutter/packages/tree/master/packages/palette_generator/example

const Color _kBackgroundColor = Color(0xffa0a0a0);
const Color _kPlaceholderColor = Color(0x80404040);

/// A widget that draws the swatches for the [PaletteGenerator] it is given,
/// and shows the selected target colors.
class PaletteSwatches extends StatelessWidget {
  /// Create a Palette swatch.
  ///
  /// The [generator] is optional. If it is null, then the display will
  /// just be an empty container.
  const PaletteSwatches({Key? key, required this.generator}) : super(key: key);

  /// The [PaletteGenerator] that contains all of the swatches that we're going
  /// to display.
  final PaletteGenerator generator;

  @override
  Widget build(BuildContext context) {
    final List<Widget> swatches = <Widget>[];
    if (generator.colors.isEmpty) {
      return Container();
    }
    for (Color color in generator.colors) {
      swatches.add(PaletteSwatch(color: color));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Wrap(
          children: swatches,
        ),
        Container(height: 30.0),
        PaletteSwatch(label: 'Dominant', color: generator.dominantColor?.color),
        PaletteSwatch(
            label: 'Light Vibrant', color: generator.lightVibrantColor?.color),
        PaletteSwatch(label: 'Vibrant', color: generator.vibrantColor?.color),
        PaletteSwatch(
            label: 'Dark Vibrant', color: generator.darkVibrantColor?.color),
        PaletteSwatch(
            label: 'Light Muted', color: generator.lightMutedColor?.color),
        PaletteSwatch(label: 'Muted', color: generator.mutedColor?.color),
        PaletteSwatch(
            label: 'Dark Muted', color: generator.darkMutedColor?.color),
      ],
    );
  }
}

/// A small square of color with an optional label.
@immutable
class PaletteSwatch extends StatelessWidget {
  /// Creates a PaletteSwatch.
  ///
  /// If the [color] argument is omitted, then the swatch will show a
  /// placeholder instead, to indicate that there is no color.
  const PaletteSwatch({
    Key? key,
    this.color,
    this.label,
  }) : super(key: key);

  /// The color of the swatch. May be null.
  final Color? color;

  /// The optional label to display next to the swatch.
  final String? label;

  @override
  Widget build(BuildContext context) {
    // Compute the "distance" of the color swatch and the background color
    // so that we can put a border around those color swatches that are too
    // close to the background's saturation and lightness. We ignore hue for
    // the comparison.
    final HSLColor hslColor = HSLColor.fromColor(color ?? Colors.transparent);
    final HSLColor backgroundAsHsl = HSLColor.fromColor(_kBackgroundColor);
    final double colorDistance = math.sqrt(
        math.pow(hslColor.saturation - backgroundAsHsl.saturation, 2.0) +
            math.pow(hslColor.lightness - backgroundAsHsl.lightness, 2.0));

    Widget swatch = Padding(
      padding: const EdgeInsets.all(2.0),
      child: color == null
          ? const Placeholder(
              fallbackWidth: 34.0,
              fallbackHeight: 20.0,
              color: Color(0xff404040),
              strokeWidth: 2.0,
            )
          : Container(
              decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    width: 1.0,
                    color: _kPlaceholderColor,
                    style: colorDistance < 0.2
                        ? BorderStyle.solid
                        : BorderStyle.none,
                  )),
              width: 34.0,
              height: 20.0,
            ),
    );

    if (label != null) {
      swatch = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                swatch,
                Container(width: 5.0),
                Text(label!),
              ],
            ),
          ),
          Spacer(),
        ],
      );
    }
    return swatch;
  }
}
