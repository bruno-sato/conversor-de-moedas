import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key={{ PUT_YOUR_KEY_HERE }}";

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}
