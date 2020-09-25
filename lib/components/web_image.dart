import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

class WebImage extends StatelessWidget {
  final String imageUrl;
  final Widget placeholder;
  final Widget errorWidget;
  final double width;
  final double height;
  final BoxFit fit;

  const WebImage(this.imageUrl,
      {Key key,
      this.placeholder = const Center(child: CircularProgressIndicator()),
      this.errorWidget,
      this.width,
      this.height,
      this.fit})
      : super(key: key);

  static void clean(String url) {
    DefaultCacheManager().removeFile(url);
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholder;
    }
    return CachedNetworkImage(
      // cacheManager: DefaultCacheManager(),
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget ?? placeholder,
    );
  }
}

/*class DefaultCacheManager extends BaseCacheManager {
  static const key = "cachedImageData";

  static DefaultCacheManager _instance;

  /// The DefaultCacheManager that can be easily used directly. The code of
  /// this implementation can be used as inspiration for more complex cache
  /// managers.
  factory DefaultCacheManager() {
    if (_instance == null) {
      _instance = new DefaultCacheManager._();
    }
    return _instance;
  }

  DefaultCacheManager._() : super(key, maxAgeCacheObject: Duration(days: 30));

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}*/
