import 'dart:async';
import 'dart:convert';
import 'package:flutter_isurvey/client.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_isurvey/config.dart';
import 'package:flutter_isurvey/models/ticket.dart';

class ApiService{
  static var client = MyClient();

  static Future<Ticket> fetchTicketById(String id) async {
    final response =
        await client.post(Uri.parse(URL_GET_TICKET), body: {'TicketID': id});
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "success") {
        Map<String, dynamic> mapTicket = mapResponse['data'];
        return Ticket.fromJson(mapTicket);
      } else if (mapResponse["status"] == "error") {
        return Ticket(error: mapResponse["message"]);
      }
    } else {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "error") {
        return Ticket(error: mapResponse["message"]);
      }
      throw('Failed');
    }
  }

  static Future<Ticket> checkinTicket(String id) async {
    final response =
        await client.get(Uri.parse(URL_GET_TICKET + id + '/checkin/?token=$GET_TOKEN'));
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "success") {
        Map<String, dynamic> mapTicket = mapResponse['data'];
        return Ticket.fromJson(mapTicket);
      } else if (mapResponse["status"] == "error") {
        return Ticket(error: mapResponse["message"]);
      }
    } else {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "error") {
        return Ticket(error: mapResponse["message"]);
      }
      throw Exception('Failed');
    }
  }

  static Future<Ticket> checkoutTicket(String id) async {
    final response =
        await client.get(Uri.parse(URL_GET_TICKET + id + '/checkout/?token=$GET_TOKEN'));
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "success") {
        Map<String, dynamic> mapTicket = mapResponse['data'];
        return Ticket.fromJson(mapTicket);
      } else if (mapResponse["status"] == "error") {
        return Ticket(error: mapResponse["message"]);
      }
    } else {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "error") {
        return Ticket(error: mapResponse["message"]);
      }
      throw Exception('Failed');
    }
  }

  static Future<Ticket> reviewTicket(
      String id, Map<String, dynamic> params) async {
    final response = await client
        .post(Uri.parse(URL_GET_TICKET + id + '/review/'), body: params);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "success") {
        Map<String, dynamic> mapTicket = mapResponse['data'];
        return Ticket.fromJson(mapTicket);
      } else if (mapResponse["status"] == "error") {
        throw Exception(mapResponse["message"]);
      }
    } else {
      throw Exception('Failed');
    }
  }

  static Future<List<dynamic>> fetchSliders() async {
    final response = await client.get(Uri.parse(URL_GET_SLIDE));
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "sucess") {
        final sliders = mapResponse['data'].cast<Map<String, dynamic>>();
        final listSliders = await sliders.map((json) {
          return json["image"];
        }).toList();
        return listSliders;
      } else if (mapResponse["status"] == "error") {
        throw Exception(mapResponse["message"]);
      }
    } else {
      throw Exception('Failed');
    }
  }

  static Future<bool> saveSignatureTicket(Map<String, dynamic> params) async {
    final response =
        await client.post(Uri.parse(URL_SAVE_SIGNATURE), body: params);
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      if (mapResponse["status"] == "success") {
        return true;
      } else if (mapResponse["status"] == "error" || mapResponse["status"] == "warning") {
        throw Exception(mapResponse["message"]);
      }
    } else {
      throw Exception('Failed');
    }
  }
}
