// https://api.coingecko.com/api/v3/coins/

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> getPrice(String id) async {
  try {
    var response = await http.get(Uri.parse("https://api.coingecko.com/api/v3/coins/" + id));
    var json = jsonDecode(response.body);
    var value = json['market_data']['current_price']['eur'].toString();
    return double.parse(value);
  } catch (e) {
    print(e.toString());
    return 0.0;
  }
}

Future<double> getPriceChange(String id) async {
  try {
    var response = await http.get(Uri.parse("https://api.coingecko.com/api/v3/coins/" + id));
    var json = jsonDecode(response.body);
    var value = json['market_data']['price_change_percentage_24h'].toString();
    return double.parse(value);
  } catch (e) {
    print(e.toString());
    return 0.0;
  }
}
