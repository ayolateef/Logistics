import 'dart:convert';

class Geocodedata {
  List<DataGeocode>? results;
  String? status;
  Geocodedata({this.results, this.status});

  factory Geocodedata.fromJson(Map<String, dynamic> data) {
    var list = data['results'] as List;
    print(list.runtimeType);
    List<DataGeocode> dataGeoList =
        list.map((i) => DataGeocode.fromJson(i)).toList();
    return Geocodedata(results: dataGeoList, status: data["status"]);
  }
}

class DataGeocode {
  List<Addresscomponent>? address_components;
  String? formatted_address;
  Geometry? geometry;
  String? place_id;
  // PlusCode plus_code;
  List<String>? types;

  DataGeocode(
      {this.address_components,
      this.formatted_address,
      this.geometry,
      this.place_id,
      //  this.plus_code,
      this.types});
  factory DataGeocode.fromJson(Map<String, dynamic> json) {
    var list = json['address_components'] as List;
    print(list.runtimeType);
    List<Addresscomponent> addressList =
        list.map((i) => Addresscomponent.fromJson(i)).toList();
    var list2 = json['address_components'] as List;
    print(list.runtimeType);
    List<String> typesList = list2.map((i) => i.toString()).toList();
    PlusCode plusCodenew = PlusCode(compound_code: "", global_code: "");
    return DataGeocode(
        address_components: addressList,
        formatted_address: json['formatted_address'],
        geometry: Geometry.fromJson(json['geometry']),
        place_id: json['place_id'],
        //    plus_code:
        //       PlusCode.fromJson(json['plus_code']) == null ? '' : plusCodenew,
        types: typesList);
  }
  Map<String, dynamic> toJson() {
    PlusCode plusCodenew = PlusCode(compound_code: "", global_code: "");
    return {
      "address_components": address_components,
      "formatted_address": formatted_address,
      "geometry": geometry,
      "place_id": place_id,
      //   "plus_code": this.plus_code == null ? plusCodenew : this.plus_code,
      "types": types,
    };
  }
}

class Addresscomponent {
  String? long_name;
  String? short_name;
  List<String>? types;

  Addresscomponent({this.long_name, this.short_name, this.types});
  factory Addresscomponent.fromJson(Map<String, dynamic> json) {
    var list = json['types'] as List;
    print(list.runtimeType);
    List<String> typesList = list.map((i) => i.toString()).toList();
    return Addresscomponent(
        long_name: json['long_name'],
        short_name: json['short_name'],
        types: typesList);
  }
}

class LatLng {
  double? lat;
  double? lng;
  LatLng({this.lat, this.lng});
  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(lat: json['lat'], lng: json['lng']);
  }
}

class Geometry {
  LatLng? location;
  String? location_type;
  Viewport? viewport;

  Geometry({this.location, this.location_type, viewport});
  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
        location: LatLng.fromJson(json['location']),
        location_type: json['location_type'],
        viewport: Viewport.fromJson(json['viewport']));
  }
}

class Viewport {
  LatLng? northeast;
  LatLng? southwest;
  Viewport({this.northeast, this.southwest});
  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
        northeast: LatLng.fromJson(json['northeast']),
        southwest: LatLng.fromJson(json['southwest']));
  }
}

class PlusCode {
  late final String? compound_code;
  late final String? global_code;

  PlusCode({this.compound_code, this.global_code});
  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
        compound_code: json['compound_code'] ?? '',
        global_code: json['global_code'] ?? '');
  }
  PlusCode.map(dynamic obj, this.compound_code, this.global_code) {
    compound_code = obj['compound_code'] ? '' : obj['compound_code'];
    global_code = obj['global_code'] ? '' : obj['global_code'];
  }
}
