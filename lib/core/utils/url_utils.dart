import 'package:charify/core/api/api_config.dart';

class UrlUtils {
  static String buildImageURL(String filename) {
    return "${ApiConfig.BASE_URL}uploads/$filename";
  }
}
