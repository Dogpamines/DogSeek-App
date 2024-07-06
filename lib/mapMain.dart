import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'hospitalDetail.dart';
import 'searchHospital.dart';
import 'location.dart';

class Hospital {
  final String name;
  final String phone;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String openhour;
  final String closehour;
  final String closeday;

  Hospital({
    required this.name,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.openhour,
    required this.closehour,
    required this.closeday,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['bplcnm'],
      phone: json['sitetel'],
      latitude: double.parse(json['y']),
      longitude: double.parse(json['x']),
      imageUrl: json['image'], // Replace with actual image path if available
      openhour: json['openhour'],
      closehour: json['closehour'],
      closeday: json['closeday'],
    );
  }
}

class MapMain extends StatefulWidget {
  MapMain({Key? key}) : super(key: key);

  NaverMapViewOptions options = const NaverMapViewOptions(
    initialCameraPosition:
    NCameraPosition(target: NLatLng(37.4988, 127.0267), zoom: 16),
    mapType: NMapType.basic,
    locationButtonEnable: true,
  );

  @override
  State<MapMain> createState() => _MapMainState();
}

class _MapMainState extends State<MapMain> {
  double? latitude;
  double? longitude;
  late NaverMapController _controller;
  List<Hospital> hospitals = [];
  bool _showBottomSheet = false;
  Hospital? _selectedHospital;
  double? _distance;

  @override
  void initState() {
    super.initState();
    getGeoData();
    loadHospitals();
    print(hospitals);
  }

  Future<void> loadHospitals() async {
    String data = await rootBundle.loadString('assets/data/hospitalData.json');
    List<dynamic> jsonResult = json.decode(data);
    setState(() {
      hospitals = jsonResult.map((e) => Hospital.fromJson(e)).toList();
    });
  }

  Future<void> getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371; // Radius of the Earth in km
    final double dLat = (lat2 - lat1) * (3.141592653589793 / 180);
    final double dLon = (lon2 - lon1) * (3.141592653589793 / 180);
    final double a =
        0.5 - (cos(dLat) / 2) + cos(lat1 * (3.141592653589793 / 180)) * cos(lat2 * (3.141592653589793 / 180)) * (1 - cos(dLon)) / 2;
    return R * 2 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Color.fromRGBO(99, 197, 74, 100),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Location',
              style: TextStyle(fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/icon_location.png'),
                Locate(),
              ],
            )
          ],
        ),
        actions: [
          SizedBox(
            width: 60,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          NaverMap(
            // 카메라 위치 설정
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.4988, 127.0267),
                  zoom: 13,
                  bearing: 0,
                  tilt: 0
              ),
              mapType: NMapType.basic,
              activeLayerGroups: [
                NLayerGroup.transit,
                NLayerGroup.building,
              ],
              minZoom: 10,
              maxZoom: 20,
              maxTilt: 30,
              extent: NLatLngBounds(southWest: NLatLng(31.43, 122.37), northEast: NLatLng(44.35, 132.0)),
              locationButtonEnable: true,
              scaleBarEnable: true,
            ),
            onMapReady: (controller) async {
              print("네이버 맵 로딩됨!");
              _controller = controller;

              final locationOverlay = await controller.getLocationOverlay();
              locationOverlay.setPosition(NLatLng(37.4988, 127.0267));
              print(locationOverlay.getPosition());

              final location = NMarker(
                id: 'location',
                position: const NLatLng(37.4988, 127.0267),
                anchor: const NPoint(0.5, 0.5),
                size: const Size(20, 20),
                icon: const NOverlayImage.fromAssetImage('assets/images/location_mark.png'),
              );

              for (Hospital hospital in hospitals) {
                double distance = calculateDistance(37.4988, 127.0267, hospital.latitude, hospital.longitude);
                if (distance <= 1.5) {
                  final marker = NMarker(
                    id: hospital.name,
                    position: NLatLng(hospital.latitude, hospital.longitude),
                    anchor: const NPoint(0.5, 0.5),
                    size: const Size(60, 60),
                    icon: const NOverlayImage.fromAssetImage('assets/images/marker.png'),
                  );

                  controller.addOverlay(marker);

                  marker.setOnTapListener((NMarker marker) {
                    _controller.updateCamera(NCameraUpdate.fromCameraPosition(NCameraPosition(target: marker.position, zoom: 18)));
                    setState(() {
                      _selectedHospital = hospital;
                      _distance = distance;
                      _showBottomSheet = true;
                    });
                  });
                }
              }
              controller.addOverlay(location);
            },
            onMapTapped: (NPoint point, NLatLng latLng) {
              setState(() {
                _showBottomSheet = false;
              });
              print(_showBottomSheet);
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchHospital()),);
              },
              child: Text(
                '병원목록',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff404a3c),
              ),
            ),
          ),
          _showBottomSheet && _selectedHospital != null
              ? HospitalInfoWidget(hospital: _selectedHospital!, distance: _distance!)
              : Container(),
        ],
      ),
    );
  }
}

class HospitalInfoWidget extends StatelessWidget {
  final Hospital hospital;
  final double distance;

  const HospitalInfoWidget({required this.hospital, required this.distance, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      left: 10,
      bottom: 0,
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20),
          ),
        ),
        width: 200,
        height: 120.0,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SizedBox(
                        child: Image.network('${hospital.imageUrl}',
                          fit: BoxFit.cover,
                        )
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  height: 80,
                  width: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 160,
                        child: Text(hospital.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 24, top: 20),
                        width: 100,
                        child:
                        Text(hospital.phone, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent),),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 25),
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('영업중', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xff999999)),),
                            Text('${distance.toStringAsFixed(2)} km', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xff999999)),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: EdgeInsets.only(top: 35),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HospitalDetail(bplcnm: hospital.name)),);
                    },
                    child: Text('상세', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xff63C54A),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LocationData {
  double latitude = 0;
  double longitude = 0;

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
