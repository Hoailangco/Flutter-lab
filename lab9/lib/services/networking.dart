import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    // We use the 'http' package to get the response
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      // Convert the raw string into a JSON object
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}