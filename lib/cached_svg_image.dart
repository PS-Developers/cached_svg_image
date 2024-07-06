library cached_svg_image;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedNetworkSvgImage extends StatefulWidget {
  const CachedNetworkSvgImage(
      {super.key,
      required this.loadingGif,
      required this.url,
      this.width,
      this.height,
      this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.placeholderBuilder,
      this.matchTextDirection = false,
      this.allowDrawingOutsideViewBox = false,
      this.semanticsLabel,
      this.excludeFromSemantics = false,
      this.clipBehavior = Clip.hardEdge,
      this.cacheColorFilter = false,
      this.colorFilter,
      this.theme,
      this.color,
      this.colorBlendMode = BlendMode.srcIn,
      this.forceRefresh = false});

  final String loadingGif;
  final String url;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;
  final WidgetBuilder? placeholderBuilder;
  final bool allowDrawingOutsideViewBox;
  final String? semanticsLabel;
  final Clip clipBehavior;
  final ColorFilter? colorFilter;
  final bool cacheColorFilter;
  final SvgTheme? theme;
  final Color? color;
  final BlendMode colorBlendMode;
  final BoxFit fit;
  final bool matchTextDirection;
  final bool excludeFromSemantics;
  final bool forceRefresh;

  @override
  State<CachedNetworkSvgImage> createState() => _CachedNetworkSvgImageState();
}

class _CachedNetworkSvgImageState extends State<CachedNetworkSvgImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
        future: getImageData(),
        builder: ((context, snapshot) {
          if (snapshot.data != null) {
            File? file = snapshot.data;
            return SvgPicture.file(
              file!,
              width: widget.width,
              alignment: widget.alignment,
              allowDrawingOutsideViewBox: widget.allowDrawingOutsideViewBox,
              clipBehavior: widget.clipBehavior,
              excludeFromSemantics: widget.excludeFromSemantics,
              fit: widget.fit,
              height: widget.height,
              key: widget.key,
              matchTextDirection: widget.matchTextDirection,
              placeholderBuilder: widget.placeholderBuilder,
              semanticsLabel: widget.semanticsLabel,
              theme: widget.theme,
            );
          }
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child: Image.asset(
                widget.loadingGif,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          );
        }));
  }

  Future<File> getImageData() async {
    late File file;
    if (!widget.forceRefresh) {
      file = await DefaultCacheManager().getSingleFile(widget.url);
    } else {
      var downloadedFile =
          await DefaultCacheManager().downloadFile(widget.url, force: true);
      file = downloadedFile.file;
    }
    return file;
  }
}

class CachedNetworkSvgImageManageUtils {
  static void removeFileCache(String url) {
    DefaultCacheManager().removeFile(url).then((value) {
      debugPrint('File removed');
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  }

  void clearCacheAll() {
    DefaultCacheManager().emptyCache();
  }
}
