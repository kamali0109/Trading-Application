import 'dart:convert';

import 'package:http/http.dart' as http;

class Apicall {
  String mainUrl = 'http://192.168.1.59:12345/';
  Future<Map<String, dynamic>> registerpost(Map data) async {
    String endpoint = "postClientDetails";

    try {
      http.Response response = await http.post(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data));
          print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "StatusCode": {response.statusCode}
        };
      }
    } catch (e) {
      print( {e});
      return {
        "Exception": {e}
        
      };
    }
  }

  Future<dynamic> tradeexecution() async {
    String endpoint = "getScriptMasterDetails";

    try {
      http.Response response = await http.get(Uri.parse("$mainUrl$endpoint"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }

  Future<dynamic> tradeinsert(dynamic data) async {
    String endpoint = "postPurchaseTrade";

    try {
      http.Response response = await http.post(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
  Future<dynamic> tradeupdate(dynamic data) async {
    String endpoint = "updatetrade";

    try {
      http.Response response = await http.post(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
    Future<dynamic> tradedelete(dynamic data) async {
    String endpoint = "tradedelete";

    try {
      http.Response response = await http.post(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
   Future<dynamic> billingupdate(dynamic data) async {
    String endpoint = "updatebilling";

    try {
      http.Response response = await http.post(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }



  Future<dynamic> loginmethod(dynamic data) async {
    String endpoint = "verifyClientDetails";

    try {
      http.Response response = await http.post(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
  
  Future<dynamic> kycputmethod(List data) async {
    String endpoint = "updateClientDetails";

    try {
      http.Response response = await http.put(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data));
      print("eeeeeeeeeeeeeeeeeeeeeeeeee${jsonEncode(data)}");
      if (response.statusCode == 200) {
        print("lllllllllllllllllllllllllllllll${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  } 
    Future<dynamic> requestclientdetails() async {
    String endpoint = "getClientDetails";

    try {
      http.Response response = await http.get(Uri.parse("$mainUrl$endpoint"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }

  Future<dynamic> tradehistory(dynamic data) async {
    String endpoint = "postTradeHistoryAPI";

    try {
      http.Response response = await http.post(Uri.parse("$mainUrl$endpoint"),
          body: jsonEncode(data)
          );
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        return "StatusCode:${response.statusCode}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
  
  
}
