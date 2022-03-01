class Guest {
  String fullName;
  String cmnd;
  List<String> cardNo;

  Guest({
    this.fullName,
    this.cmnd,
    this.cardNo,
  });

  factory Guest.fromJson(Map<String, dynamic> json) => Guest(
    fullName: json["fullName"],
    cmnd: json["CMND"],
    cardNo: List<String>.from(json["cardNo"].map((x) => x)),
  );
}