import 'dart:convert';

class ProcessAPIService {
  List<String> inferBasicData(response) {
    print("Start: inferBasicData");
    print(response);
    var data = jsonDecode(response);
    var images = data["images"];

    // ignore: non_constant_identifier_names
    String text_i = "";
    // ignore: non_constant_identifier_names
    String text_i_plus_1 = "";
    // type は　品目 を表す
    String type = "None";
    // alcohol は 度数 Noneを表す
    String alcohol = "0%";
    // madeIn は 原産地 を表す
    String madeIn = "None";
    for (int i = 0; i < images[0]["fields"].length - 1; i++) {
      text_i = images[0]["fields"][i]["inferText"].replaceAll(":", "");
      text_i_plus_1 = images[0]["fields"][i + 1]["inferText"];
      if (text_i == "品") {
        type = text_i + text_i_plus_1;
      } else if (text_i == "品目") {
        type = images[0]["fields"][i + 1]["inferText"];
      } else if (text_i.contains("品目")) {
        type = text_i.split("品目")[1];
      }
      if (text_i == "アルコール分") {
        alcohol = text_i_plus_1;
      } else if (text_i.contains("アルコール分")) {
        alcohol = text_i.split("アルコール分")[1]; // 50%
      }
      if (text_i == "原産国名") {
        madeIn = text_i_plus_1;
      } else if (text_i == "原産地") {
        madeIn = text_i_plus_1;
      } else if (text_i == "原料原産地名") {
        madeIn = text_i_plus_1;
      } else if (text_i.contains("原産国名")) {
        madeIn = text_i.split("原産国名")[1];
      } else if (text_i.contains("原料原産地名")) {
        madeIn = text_i.split("原料原産地名")[1];
      } else if (text_i.contains("原産地")) {
        madeIn = text_i.split("原産地")[1];
      }
    }

    // ignore: non_constant_identifier_names
    String serch_term = "";
    for (int i = 0; i < 3; i++) {
      text_i = images[0]["fields"][i]["inferText"].replaceAll(":", "");
      serch_term = serch_term + " " + text_i;
    }

    // ##########################
    // デバッグ用処理
    // うまく処理できなかったものを処理できるようにします
    type = type.replaceAll('品目', '');
    // ##########################

    print("End: inferBasicData");
    return [type, alcohol, madeIn, serch_term];
  }
}
