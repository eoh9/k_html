import 'dart:convert';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';
import 'package:translator_plus/translator_plus.dart';
import '../helper/global.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIs {
  //get answer from google gemini ai
  static Future<String> getAnswer(String question) async {
    try {
      log('api key: $apiKey');

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      log('res: ${res.text}');

      return res.text!;
    } catch (e) {
      log('getAnswerGeminiE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }

  static Future<List<double>> uploadImage(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://your-flask-server-url/predict"),  // ngrok URL 사용
      );
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        List<dynamic> result = json.decode(responseData.body);
        return List<double>.from(result);
      } else {
        throw Exception("Failed to load predictions");
      }
    } catch (e) {
      log('uploadImage error: $e');
      return [];
    }
  }

  static Future<List<double>> searchAiImages(File image) async {
    try {
      // ngrok에서 생성된 URL을 사용하여 Flask 서버에 이미지를 업로드하고 분류 결과를 요청
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://abcdef1234.ngrok.io/predict"),  // ngrok이 제공한 URL
      );
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        List<dynamic> result = json.decode(responseData.body);
        return List<double>.from(result);
      } else {
        throw Exception("Failed to load predictions");
      }
    } catch (e) {
      log('searchAiImages error: $e');
      return [];
    }
  }



  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      final res = await GoogleTranslator().translate(text, from: from, to: to);

      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Something went wrong!';
    }
  }
}