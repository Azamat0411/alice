import 'dart:convert';

class AliceParser {
  static const String _emptyBody = "Body is empty";
  static const String _unknownContentType = "Unknown";
  static const String _jsonContentTypeSmall = "content-type";
  static const String _jsonContentTypeBig = "Content-Type";
  static const String _parseFailedText = "Failed to parse ";
  static const JsonEncoder encoder = JsonEncoder.withIndent('  ');

  // static String _parseJson(dynamic json) {
  //   try {
  //     return encoder.convert(json);
  //   } catch (exception) {
  //     return json.toString();
  //   }
  // }
  //
  // static dynamic _decodeJson(dynamic body) {
  //   try {
  //     return json.decode(body as String);
  //   } catch (exception) {
  //     return body;
  //   }
  // }

  static String formatBody(dynamic body, String? contentType) {
    try {
      if (body == null) {
        return _emptyBody;
      }

      var bodyContent = _emptyBody;
      int a = 0, b = 0;
      space(String body) {
        String text = '';
        for (int i = 0; i < body.toString().length; i++) {
          if (body[i] == '[') {
            a++;
            text += '[\n' + '   ' * (a + b);
          } else if (body[i] == '{') {
            b++;
            text += '{\n' + '   ' * (a + b);
          } else if (body[i] == ',' && body[i + 1] == ' ') {
            text += '${body[i]}\n' + '   ' * (a + b);
            i++;
          } else if (body[i] == ']') {
            a--;
            text += ']\n' + '   ' * (a + b);
          }
          else if (body[i] == '}') {
            b--;
            if (i < body.length - 1) {
              if (body[i + 1] == ',' && i < body.length - 1) {
                text += '\n' + '   ' * (a + b) + '},';
                text += '\n' + '   ' * (a + b);
                i++;
              } else {
                text += '}\n' + '   ' * (a + b);
              }
            } else {
              text += '}\n' + '   ' * (a + b);
            }
          }
          else {
            text += body[i];
          }
        }
        return text;
      }
      bodyContent = space(body);
      return bodyContent;
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
