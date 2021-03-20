import 'dart:convert';

class ProcessAPIService {
  List<String> inferBasicData(response) {
    print("Start: inferBasicData");
    print(response);
    var data = jsonDecode(response);
    var images = data["images"];

    String textI = "";
    String nextTextI = "";
    // type は　品目 を表す
    String type = "None";
    // alcohol は 度数 Noneを表す
    String alcohol = "0%";
    // madeIn は 原産地 を表す
    String madeIn = "None";
    for (int i = 0; i < images[0]["fields"].length - 1; i++) {
      textI = images[0]["fields"][i]["inferText"].replaceAll(":", "");
      nextTextI = images[0]["fields"][i + 1]["inferText"];
      if (textI == "品") {
        type = textI + nextTextI;
      } else if (textI == "品目") {
        type = images[0]["fields"][i + 1]["inferText"];
      } else if (textI.contains("品目")) {
        type = textI.split("品目")[1];
      }
      if (textI == "アルコール分") {
        alcohol = nextTextI;
      } else if (textI.contains("アルコール分")) {
        alcohol = textI.split("アルコール分")[1]; // 50%
      }
      if (textI == "原産国名") {
        madeIn = nextTextI;
      } else if (textI == "原産地") {
        madeIn = nextTextI;
      } else if (textI == "原料原産地名") {
        madeIn = nextTextI;
      } else if (textI.contains("原産国名")) {
        madeIn = textI.split("原産国名")[1];
      } else if (textI.contains("原料原産地名")) {
        madeIn = textI.split("原料原産地名")[1];
      } else if (textI.contains("原産地")) {
        madeIn = textI.split("原産地")[1];
      }
    }

    String searchTerm = "";
    for (int i = 0; i < 3; i++) {
      textI = images[0]["fields"][i]["inferText"].replaceAll(":", "");
      searchTerm = searchTerm + " " + textI;
    }

    // ##########################
    // デバッグ用処理
    // うまく処理できなかったものを処理できるようにします
    type = type.replaceAll('品目', '');
    // ##########################

    print("End: inferBasicData");
    return [type, alcohol, madeIn, searchTerm];
  }
}
