import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LINEOCRService {
  final String requestUrl =
      "https://bef2c44061654479868834a873039292.apigw.ntruss.com/custom/v1/464/2580fcb43bc90fe421f10c7206a0f8ae6fd43667eaeda7c4d679e21910b0b1e9/general";

  Future requestToLINEOcr(String imageUrl) async {
    print("Start: requestToLINEOcr");
    final payload = jsonEncode({
      "version": "V2",
      "requestId": "string",
      "timestamp": 0,
      "lang": "ja",
      "images": [
        {"format": "jpg", "name": "test 1", "url": imageUrl}
      ]
    });
    final headers = {
      "X-OCR-SECRET": "TEJ2dXpJZnFDZkp2c1FFaldWclB5SUpaRnVGTVJ6Qlo=",
      "Content-Type": "application/json"
    };

    final response =
        await http.post(requestUrl, headers: headers, body: payload);
    print("End: requestToLINEOcr");
    return response;
  }
}
