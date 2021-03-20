import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  Future<dynamic> getImageFromGoogle(String query) async {
    final baseUrl = 'https://www.googleapis.com/customsearch/v1';
    final key = 'AIzaSyBHWHwxT_-OPntC9fRHHTnBW_eHvcDUl7k';
    final searchEngineId = '87f63fcbf55b82e53';

    var url = '$baseUrl?key=$key&cx=$searchEngineId&q=$query liquor';

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    var imageUrl = getImageUrl(data);
    // print(imageUrl);
    return imageUrl;
  }

  String getImageUrl(dynamic data) {
    for (var i = 0; i < 10; i++) {
      var items = data['items'];
      var cseImage = items[i]['pagemap']['cse_image'];
      var imageUrl = (cseImage != null) ? cseImage[0]['src'] : null;
      if (judgeExtenExtension(imageUrl)) {
        return imageUrl;
      }
    }
  }

  bool judgeExtenExtension(String url) {
    var target = url.split('.');
    if (target[target.length - 1] == 'png' ||
        target[target.length - 1] == 'jpg') {
      return true;
    } else {
      return false;
    }
  }
}
