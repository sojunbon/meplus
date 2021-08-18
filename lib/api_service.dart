import 'dart:convert';

import 'package:http/http.dart' as http;

//import 'models/user.dart';
import 'package:meplus/models/user_db.dart';

class ApiService {
  static String url(int nrResults) {
    return 'http://api.randomuser.me/?results=$nrResults';
  }

  static Future<List<Userdb>> getUsers({int nrUsers = 1}) async {
    try {
      var response = await http
          .get(url(nrUsers), headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        Iterable list = data["results"];
        List<Userdb> users = list.map((l) => Userdb.fromJson(l)).toList();
        return users;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
