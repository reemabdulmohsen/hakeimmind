import 'dart:convert';
import 'package:http/http.dart' as http;

class MindMapService {
  static Future<dynamic> fetchMindMapData(String diseaseName) async {
    print("11");
    final url = 'http://reemabdulmohsen.pythonanywhere.com/diseases?diseasesName=${diseaseName.trim().toString()}';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to fetch mind map data');
    }
  }
}
