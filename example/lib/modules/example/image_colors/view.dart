import 'dart:io';
import 'dart:math' as math;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easy/flutter_easy.dart';
import 'package:flutter_easy_example/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../routes.dart';
import 'controller.dart';

class ImageColorsPage extends StatelessWidget {
  const ImageColorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageColorsController controller = Get.put(ImageColorsController());

    Future<void> onImagePickerClicked() async {
      if (controller.isPicking) return;
      controller.isPicking = true;
      var usingCamera = false;
      try {
        const imageTypes = XTypeGroup(
          label: 'Images',
          extensions: ['bmp', 'gif', 'jpeg', 'jpg', 'png', 'webp'],
          mimeTypes: ['image/*'],
        );
        XFile? image;
        if (isWeb || isDesktop) {
          image = await openFile(acceptedTypeGroups: [imageTypes]);
        } else {
          final selected = await showBaseBottomSheet<int>(
            BaseActionSheet(
              actions: <Widget>[
                BaseActionSheetAction(
                  child: const Text('拍照'),
                  onPressed: () => offBack(0),
                ),
                BaseActionSheetAction(
                  child: const Text('从相册选择'),
                  onPressed: () => offBack(1),
                ),
                BaseActionSheetAction(
                  child: const Text('从文件选择图片'),
                  onPressed: () => offBack(2),
                ),
              ],
              cancelButton: BaseActionSheetAction(
                isDestructiveAction: true,
                onPressed: () => offBack(),
                child: const Text('取消'),
              ),
            ),
          );
          if (selected == null) return;
          if (selected == 2) {
            image = await openFile(acceptedTypeGroups: [imageTypes]);
          } else {
            usingCamera = selected == 0;
            image = await ImagePicker().pickImage(
              source: usingCamera ? ImageSource.camera : ImageSource.gallery,
            );
          }
        }
        if (image != null) await controller.updateImage(image);
      } catch (error, stack) {
        logError(error, stackTrace: stack);
        if (error is PlatformException &&
            (error.code == 'camera_access_denied' ||
                error.code == 'camera_permission_error')) {
          showErrorToast('无法访问相机，请在系统设置中检查相机权限');
        } else if (usingCamera) {
          showErrorToast('无法打开相机，请确认设备有可用的相机应用');
        } else {
          showErrorToast('无法选择或读取图片，请重新选择有效的图片文件');
        }
      } finally {
        controller.isPicking = false;
      }
    }

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(S.of(context).example_ExtractProminentColorsFromAnImage),
        actions: [
          BaseButton(
            onPressed: onImagePickerClicked,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: GetX<ImageColorsController>(
        builder: (controller) {
          if (controller.imagePath.isNotEmpty &&
              controller.paletteGenerator != null) {
            final image =
                isWeb ? controller.imagePath.value : controller.imagePath.value;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BaseButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      toGalleryView(
                        images: [image],
                      );
                    },
                    child: isWeb
                        ? Image.network(
                            image,
                            width: screenWidthDp,
                          )
                        : Image.file(
                            File(image),
                            width: screenWidthDp,
                          ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(15),
                      child: PaletteSwatches(
                          generator: controller.paletteGenerator!.value)),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Selected Image"));
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
  const PaletteSwatches({super.key, required this.generator});

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
    super.key,
    this.color,
    this.label,
  });

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
          const Spacer(),
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
          const Spacer(),
        ],
      );
    }
    return swatch;
  }
}
