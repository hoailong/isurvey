class Glob {
  //One instance, needs factory 
  static Glob _instance;
  factory Glob() => _instance ??= new Glob._();
  Glob._();
  //

  String _imei ='0';
  String _model ='NULL';
  String _deviceID ='NULL';

  String get imei => _imei;

  String get model => _model;

  String get deviceID => _deviceID;

  set imei(String value) => _imei = value;

  set model(String value) => _model = value;

  set deviceID(String value) => _deviceID = value;
}