import 'dart:convert';

class AliceParser {
  static const String _emptyBody = "Body is empty";
  static const String _unknownContentType = "Unknown";
  static const String _jsonContentTypeSmall = "content-type";
  static const String _jsonContentTypeBig = "Content-Type";
  static const String _parseFailedText = "Failed to parse ";
  static const JsonEncoder encoder = JsonEncoder.withIndent('  ');

  static String formatJson(Map<String, dynamic> json) {
    return encoder.convert(json);
  }

  static String formatBody(dynamic body, String? contentType) {
    try {
      if (body == null) {
        return _emptyBody;
      }

      String formattedJson = formatJson(body);
      return formattedJson;
    } catch (exception) {
      return _parseFailedText + body.toString();
    }
  }

  static String? getContentType(Map<String, dynamic>? headers) {
    if (headers != null) {
      if (headers.containsKey(_jsonContentTypeSmall)) {
        return headers[_jsonContentTypeSmall] as String?;
      }
      if (headers.containsKey(_jsonContentTypeBig)) {
        return headers[_jsonContentTypeBig] as String?;
      }
    }
    return _unknownContentType;
  }
}
