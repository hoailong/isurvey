import 'dart:convert' as JSON;
import 'package:flutter_isurvey/models/access-info.dart';
class Ticket {
  String id;
  String ticketId;
  String title;
  String location;
  String branch;
  String serviceType;
  String cusType;
  String issueName;
  String createdDate;
  String requiredDate;
  String divisionName;
  String cricLev;
  String foundMobile;
  String foundIpPhone;
  String checkin;
  String checkout;
  int status;
  String error;
  AccessInfo accessInfo;

  Ticket({
    this.id,
    this.ticketId,
    this.title,
    this.location,
    this.branch,
    this.serviceType,
    this.cusType,
    this.issueName,
    this.createdDate,
    this.requiredDate,
    this.divisionName,
    this.cricLev,
    this.foundMobile,
    this.foundIpPhone,
    this.checkin,
    this.checkout,
    this.status,
    this.error,
    this.accessInfo,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return
      Ticket(
        id: json["_id"],
        ticketId: json["TicketID"],
        title: json["Title"],
        location: json["Location"],
        branch: json["Branch"],
        serviceType: json["ServiceType"],
        cusType: json["CusType"],
        issueName: json["IssueName"],
        createdDate: json["CreatedDate"],
        requiredDate: json["RequiredDate"],
        divisionName: json["DivisionName"],
        cricLev: json["CricLev"],
        foundMobile: json["FoundMobile"],
        foundIpPhone: json["FoundIPPhone"],
        checkin: json["checkin"],
        checkout: json["checkout"],
        status: json["status"],
        accessInfo: json["infoAccessDC"] == null ? null : AccessInfo.fromJson(JSON.jsonDecode(json["infoAccessDC"]))
      );
  }
}
