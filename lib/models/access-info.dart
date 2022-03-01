import 'package:flutter_isurvey/models/guest.dart';

class AccessInfo {
    // String datacenter;
    List<String> datacenters;
    List<String> racks;
    String u;
    String numberOfCards;
    List<Guest> guests;

    AccessInfo({
        // this.datacenter,
        this.datacenters,
        this.racks,
        this.u,
        this.numberOfCards,
        this.guests,
    });

    factory AccessInfo.fromJson(Map<String, dynamic> json) => AccessInfo(
        // datacenter: json["datacenter"],
        datacenters: List<String>.from(json["datacenter"].map((x) => x)),
        racks: List<String>.from(json["racks"].map((x) => x)),
        u: json["U"],
        numberOfCards: json["numberOfCards"],
        guests: List<Guest>.from(json["guests"].map((x) => Guest.fromJson(x))),
    );
}