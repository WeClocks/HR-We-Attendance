import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:hr_we_attendance/Screens/HRTrackScreen/controller/HRTrackController.dart';
// import 'package:location/location.dart';
import 'package:hr_we_attendance/Screens/HomeScreen/Model/trackingModel.dart';
import 'package:hr_we_attendance/Screens/LoginScreen/Controller/LoginController.dart';
import 'package:hr_we_attendance/Utils/ApiHelper.dart';
import 'package:hr_we_attendance/Utils/DBHelper.dart';
import 'package:hr_we_attendance/main.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  Rx<Completer<GoogleMapController>> googleMapController = Completer<GoogleMapController>().obs;
  RxList<LatLng> polylineList = <LatLng>[].obs;
  RxSet<Marker> markerList = <Marker>{}.obs;
  RxInt polylineGetOrNot = 0.obs;
  Rx<LatLng> currentLocation = LatLng(0, 0).obs;
  Rx<LatLng> firstPunchInOutLocation = LatLng(0, 0).obs;
  Rx<TrackingModel> firstPunchInOutData = TrackingModel().obs;
  Rx<BitmapDescriptor> markerIcon = BitmapDescriptor.defaultMarker.obs;
  var battery = Battery();
  LoginController loginController = Get.put(LoginController());
  HRTrackController hrTrackController = Get.put(HRTrackController());
  RxDouble polylineProgress = 0.0.obs;

  Future<void> playPauseLocation() async {
    List<TrackingModel>? trackingDataList = await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: hrTrackController.hrTrackOrNot.value ? hrTrackController.hrAttendanceOneData['staff_id'] : loginController.UserLoginData.value.id!);
    List<TrackingModel> dateWiseTrackingData = [];
    if(hrTrackController.hrTrackOrNot.value)
    {
      DateTime date = DateTime.parse(hrTrackController.selectedDate.value);
      dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(date.year,date.month,date.day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
    }
    else
    {
      dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
    }

    int index = 0;
    GoogleMapController mapController = await googleMapController.value.future;
    firstPunchInOutData.value = dateWiseTrackingData[index];
    firstPunchInOutLocation.value = LatLng(polylineList[index].latitude, polylineList[index].longitude);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(
              target: firstPunchInOutLocation.value,
              zoom: 18
          )
      ),
    );
    Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      if(index == polylineList.length)
      {
        firstPunchInOutLocation.value = LatLng(double.parse(dateWiseTrackingData[0].lat!), double.parse(dateWiseTrackingData[0].long!));
        firstPunchInOutData.value = dateWiseTrackingData[0];
        timer.cancel();
      }
      else
      {
        // GoogleMapController controller = await googleMapController.value.future;
        // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: firstPunchInOutLocation.value,zoom: 14)));
        firstPunchInOutLocation.value = LatLng(polylineList[index].latitude, polylineList[index].longitude);
        firstPunchInOutData.value = dateWiseTrackingData[0];
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: firstPunchInOutLocation.value,
                  zoom: 18
              )
          ),
        );
      }
      index++;
    });
  }

  Future<void> getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<TrackingModel>? trackingDataList = await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: hrTrackController.hrTrackOrNot.value ? hrTrackController.hrAttendanceOneData['staff_id'] : loginController.UserLoginData.value.id!);
    // List<TrackingModel> dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
    List<TrackingModel> dateWiseTrackingData = [];
    if(hrTrackController.hrTrackOrNot.value)
    {
      DateTime date = DateTime.parse(hrTrackController.selectedDate.value);
      dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(date.year,date.month,date.day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
    }
    else
    {
      dateWiseTrackingData = trackingDataList == null ? [] : trackingDataList.where((element) => ((DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day).compareTo(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
    }

    print("===========~~~~~~~~~~~~111111111199999999 ${trackingDataList == null ? "nulllllllll" : trackingDataList.length} ${dateWiseTrackingData.length}");
    // List<TrackingModel> dateWiseTrackingData = [
    //   TrackingModel(lat: "21.1664583",lag: "72.8413321"),
    //   TrackingModel(lat: "21.177588",lag: "72.834411"),
    //   TrackingModel(lat: "21.172031",lag: "72.820181"),
    //   TrackingModel(lat: "21.167056",lag: "72.828248"),
    //   TrackingModel(lat: "21.1664583",lag: "72.8413321"),
    // ];
    int count = 0;
    polylineProgress.value = 0;
    if(dateWiseTrackingData.isNotEmpty)
    {
      markerList.add(
        Marker(
            markerId: MarkerId("1"),
            position: LatLng(double.parse(dateWiseTrackingData[0].lat!), double.parse(dateWiseTrackingData[0].long!))
        ),
      );
      firstPunchInOutData.value = dateWiseTrackingData[0];
      firstPunchInOutLocation.value = LatLng(double.parse(dateWiseTrackingData[0].lat!), double.parse(dateWiseTrackingData[0].long!));
      polylineProgress.value = (1 / dateWiseTrackingData.length);
      print("====================progressssssssssss $polylineProgress ${dateWiseTrackingData.length}");
      for(int j=0; j<(dateWiseTrackingData.length - 1);)
      {
        markerList.add(
          Marker(
              markerId: MarkerId("${j+1}"),
              position: LatLng(double.parse(dateWiseTrackingData[j+1].lat!), double.parse(dateWiseTrackingData[j+1].long!))
          ),
        );

        PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyBpJTPrkpEL-Obocx8RmnpTX-QA2SB2-4E",
          // PointLatLng(21.1664583, 72.8413321),
          PointLatLng(double.parse(dateWiseTrackingData[j].lat!), double.parse(dateWiseTrackingData[j].long!)),
          PointLatLng(double.parse(dateWiseTrackingData[j+1].lat!), double.parse(dateWiseTrackingData[j+1].long!)),
          // travelMode: TravelMode.bicycling
          // PointLatLng(21.173457, 72.838350),
        );

        if (polylineResult.points.isNotEmpty) {
          List<LatLng> polyLines = polylineResult.points
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList();
          polylineList.addAll(polyLines);
        }

        count++;
        j++;
        polylineProgress.value = ((j+1) / (dateWiseTrackingData.length));
        print("====================progressssssssssss222222222 ${polylineProgress*100} $j $polylineProgress ${dateWiseTrackingData.length}");
      }
      print("============ $count ${dateWiseTrackingData.length}");
      if(count == (dateWiseTrackingData.length - 1))
      {
        polylineGetOrNot.value = 1;
      }
    }
    else
    {
      polylineGetOrNot.value = 1;
      firstPunchInOutLocation.value = const LatLng(21.1664583, 72.8413321);
    }
    // setState(() {});
  }

  Future<void> getBatteryAndDestinationsData()
  async {
    homeController.batteryPercentage.value = await battery.batteryLevel;
    List<TrackingModel>? trackingAllReport = await ApiHelper.apiHelper.getTrackingUserIdWise(staff_id: hrTrackController.hrTrackOrNot.value ? hrTrackController.hrAttendanceOneData['staff_id'] : loginController.UserLoginData.value.id!);
    homeController.totalDestinations.value = 0;

    if(trackingAllReport != null)
    {
      List<TrackingModel> dateWiseTrackingReport = [];
      if(hrTrackController.hrTrackOrNot.value)
      {
        DateTime date = DateTime.parse(hrTrackController.selectedDate.value);
        dateWiseTrackingReport = trackingAllReport.where((element) => ((DateTime(date.year,date.month,date.day).compareTo(DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
      }
      else
      {
        dateWiseTrackingReport = trackingAllReport.where((element) => ((DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).compareTo(DateTime(element.createdAt!.year,element.createdAt!.month,element.createdAt!.day)) == 0) && (element.gpsActive!.toLowerCase() == "On".toLowerCase()))).toList();
      }
      if(dateWiseTrackingReport.isNotEmpty)
      {
        if(dateWiseTrackingReport.length >= 2)
        {
          homeController.totalDestinations.value = Geolocator.distanceBetween(double.parse(dateWiseTrackingReport.first.lat!.toString()), double.parse(dateWiseTrackingReport.first.long!.toString()), double.parse(dateWiseTrackingReport[1].lat!.toString()), double.parse(dateWiseTrackingReport[1].long!.toString()));
          for(int j=1; j<(dateWiseTrackingReport.length-1);)
          {
            double  destination = Geolocator.distanceBetween(double.parse(dateWiseTrackingReport[j].lat!.toString()), double.parse(dateWiseTrackingReport[j].long!.toString()), double.parse(dateWiseTrackingReport[j+1].lat!.toString()), double.parse(dateWiseTrackingReport[j+1].long!.toString()));
            print("dissssssssssss ${dateWiseTrackingReport.length} $destination ${double.parse(dateWiseTrackingReport[j].lat!.toString())}, ${double.parse(dateWiseTrackingReport[j].long!.toString())}, ${double.parse(dateWiseTrackingReport[j+1].lat!.toString())}, ${double.parse(dateWiseTrackingReport[j+1].long!.toString())}");
            homeController.totalDestinations.value =  homeController.totalDestinations.value + destination;
            j++;
          }
        }
      }
    }
  }

  @override
  void initState() {
    circleLatLng.value = hrTrackController.hrTrackOrNot.value ? hrTrackController.userSubSiteData.value.lat == null ? LatLng(double.parse('${homeController.siteOneDropDownItem.value.lat}'), double.parse('${homeController.siteOneDropDownItem.value.longs}')) : LatLng(double.parse('${hrTrackController.userSubSiteData.value.lat}'), double.parse('${hrTrackController.userSubSiteData.value.longs}')) : homeController.subSiteOneDropDownItem.value.lat == null ? LatLng(double.parse('${homeController.siteOneDropDownItem.value.lat}'), double.parse('${homeController.siteOneDropDownItem.value.longs}')) : LatLng(double.parse('${homeController.subSiteOneDropDownItem.value.lat}'), double.parse('${homeController.subSiteOneDropDownItem.value.longs}'));
    polylineGetOrNot.value = 0;
    // getCurrentLatLog();
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/image/location.png").then((icon) {
      print("~~~~~~~~~~~~~~~~~~~~~~~~");
      markerIcon.value = icon;
    });
    getBatteryAndDestinationsData();
    getPolylinePoints();
    super.initState();
  }

  RxSet<Circle> circles = <Circle>{}.obs;
  Rx<LatLng> circleLatLng = LatLng(0, 0).obs;
  // Location location = Location();
  // Stream<LocationData>? _locationStream;
  // Stream<Position> _locationStream = Stream.empty();
  // Future<void> getCurrentLatLog()
  // async {
  //   await Geolocator.requestPermission();
  //   await Geolocator.getCurrentPosition().then((value) {
  //     currentLocation.value = LatLng(value.latitude, value.longitude);
  //   });
  //   // ignore: invalid_use_of_protected_member
  //   circles.value = {Circle(
  //     circleId: CircleId("1"),
  //     center: currentLocation.value,
  //     radius: 50,
  //     fillColor: Colors.blue.shade50,
  //     strokeColor: Colors.transparent
  //   )};
  //   _locationStream = Geolocator.getPositionStream();
  //   setState(() {});
  //   // _locationStream = location.onLocationChanged;
  //   // setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF5b1aa0)),
          title: Text(
            "${'map'.tr}${hrTrackController.hrTrackOrNot.value ? " [ ${hrTrackController.hrAttendanceOneData['staff_name']} ]" : ""}",
            style: const TextStyle(color: Color(0xFF5b1aa0), fontSize: 16),
          ),
          centerTitle: false,
        ),
        body: Obx(() => polylineGetOrNot.value == 0
            ? Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            lottie.Lottie.asset("assets/animation/mapLoad.json",width: Get.width/2,height: Get.width/2),
            SizedBox(height: Get.width/30,),
            CircularProgressIndicator(value: polylineProgress.value == 0 ? null : double.parse(polylineProgress.value.toString()),color: Colors.purpleAccent,),
            SizedBox(height: Get.width/30,),
            Obx(
                  () => Text(
                "${(polylineProgress.value * 100).round()}%",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 16),
              ),
            ),
            Text(
              "${'please_wait'.tr}... ${'its_take_a_time_while_loading_map'.tr}.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.purpleAccent,fontWeight: FontWeight.bold,fontSize: 12),
            )
          ],
        ),)
        //     : GoogleMap(
        //   initialCameraPosition: CameraPosition(
        //       target: firstPunchInOutLocation.value,
        //       zoom: 18
        //   ),
        //   myLocationEnabled: true,
        //   // myLocationEnabled: true,
        //   // markers: {
        //   //   Marker(
        //   //     markerId: MarkerId("source"),
        //   //     position: LatLng(21.1664583, 72.8413321)
        //   //   ),
        //   //   Marker(
        //   //     markerId: MarkerId("destination"),
        //   //     position: LatLng(21.173457, 72.838350)
        //   //   ),
        //   // },
        //   // markers: markerList,
        //   markers: firstPunchInOutLocation.value.latitude == 0 ? {} : {
        //     Marker(
        //       markerId: const MarkerId("firstPunchInOutLocation"),
        //       position: firstPunchInOutLocation.value,
        //       // icon: markerIcon.value,
        //     ),
        //     Marker(
        //       markerId: const MarkerId("currentLocation"),
        //       position: currentLocation.value,
        //       // icon: markerIcon.value,
        //     )
        //   },
        //   polylines: {
        //     Polyline(
        //       polylineId: const PolylineId("route"),
        //       points: polylineList,
        //       width: 5,
        //       color: Colors.blue,
        //     ),
        //   },
        //   onMapCreated: (controller) {
        //     print("==================controllerrrrrrrrr $controller");
        //     googleMapController.value.complete(controller);
        //   },
        //   circles: circles,
        // ),),
            : Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: firstPunchInOutLocation.value,
                zoom: 18,
              ),
              myLocationEnabled: true,
              mapType: homeController.mapType.value ? MapType.satellite : MapType.normal,
              // markers: {
              //   Marker(
              //     markerId: MarkerId("source"),
              //     position: LatLng(21.1664583, 72.8413321)
              //   ),
              //   Marker(
              //     markerId: MarkerId("destination"),
              //     position: LatLng(21.173457, 72.838350)
              //   ),
              // },
              // markers: markerList,
              markers: {
                Marker(
                    markerId: const MarkerId("firstPunchInOutLocation"),
                    position: firstPunchInOutLocation.value,
                    infoWindow: firstPunchInOutData.value.createdAt == null ? const InfoWindow() : InfoWindow(
                        title: DateFormat('dd-MM-yyyy hh:mm a').format(firstPunchInOutData.value.createdAt!)
                    )
                  // icon: markerIcon.value,
                ),
                Marker(
                    markerId: const MarkerId("currentLocation"),
                    position: circleLatLng.value,
                    icon: markerIcon.value,
                    infoWindow: InfoWindow(
                        title: "WeClocks Technology"
                    )
                  // icon: markerIcon.value,
                )
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineList,
                  width: 5,
                  color: homeController.mapType.value ? Colors.red : Colors.blue,
                ),
              },
              onMapCreated: (controller) {
                print("==================controllerrrrrrrrr $controller");
                googleMapController.value.complete(controller);
              },
              circles: {
                Circle(
                    circleId: CircleId("1"),
                    center: circleLatLng.value,
                    radius: 30,
                    strokeColor: Colors.red,
                    fillColor: homeController.mapType.value ? Colors.red.shade50.withOpacity(0.5) : Colors.red.shade50,
                    strokeWidth: 3
                )
              },
            ),
            polylineGetOrNot.value == 0
                ? Container()
                : Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: Get.width/6,right: Get.width/30),
                child: InkWell(
                  onTap: () {
                    homeController.mapType.value = !homeController.mapType.value;
                  },
                  child: Container(
                    height: Get.width/10.5,
                    width: Get.width/10.5,
                    // padding: EdgeInsets.all(Get.width/90),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(3),
                        border: homeController.mapType.value ? Border.all(color: Colors.white70) : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0),
                            blurRadius: 2,
                          )
                        ]
                    ),
                    child: ClipRRect(borderRadius: BorderRadius.circular(3),child: Image.asset("assets/image/${homeController.mapType.value ? 'sateliteMapImage.jpg' : 'normalMapImage.png'}",fit: BoxFit.cover,)),
                  ),
                ),
              ),
            )
          ],
        ),),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Obx(() => polylineGetOrNot.value == 0
            ? Container()
            : Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton(
              onPressed: () {
                playPauseLocation();
              },
              child: Icon(Icons.play_arrow_rounded,color: Color(0xFF5b1aa0),),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color(0xfff0e5ff)
              ),
              padding: EdgeInsets.all(Get.width/25),
              margin: EdgeInsets.only(left: Get.width/30),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.battery_full_rounded,color: Color(0xFF5b1aa0),),
                        Text(
                          "${homeController.batteryPercentage}%",
                          style: const TextStyle(
                            color: Color(0xFF5b1aa0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: Get.width/30,),
                    Row(
                      children: [
                        const Icon(Icons.run_circle_outlined,color: Color(0xFF5b1aa0),),
                        Text(
                          " ${homeController.totalDestinations.value >= 1000 ? "${(homeController.totalDestinations.value / 1000).toStringAsFixed(1)} km" : "${homeController.totalDestinations.value.toStringAsFixed(1)} m"}",
                          style: const TextStyle(
                            color: Color(0xFF5b1aa0),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),),

        // body: FlutterMap(
        //   options: MapOptions(
        //     initialCenter: LatLng(21.1664583, 72.8413321),
        //     // minZoom: 170.0
        //   ),
        //   children: [
        //     TileLayer(
        //       urlTemplate:
        //           "https://api.mapbox.com/styles/v1/weclocks/clojqzq2j002x01nz71gifnf0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoid2VjbG9ja3MiLCJhIjoiY2xvanA3Y2lhMXk4ajJrcGxlOXkzenczZSJ9.2QbRG8Wkw6bUFNH6UBs7_g",
        //       additionalOptions: const {
        //         "accessToken":
        //             "pk.eyJ1Ijoid2VjbG9ja3MiLCJhIjoiY2xvanA3Y2lhMXk4ajJrcGxlOXkzenczZSJ9.2QbRG8Wkw6bUFNH6UBs7_g",
        //         "id": "mapbox.streets",
        //       },
        //     ),
        //     const MarkerLayer(
        //       markers: [
        //         Marker(
        //           point: LatLng(21.1664583, 72.8413321),
        //           child: Icon(
        //             Icons.fmd_good_rounded,
        //             color: Colors.red,
        //           ),
        //         ),
        //         Marker(
        //           point: LatLng(21.173457, 72.838350),
        //           child: Icon(
        //             Icons.fmd_good_rounded,
        //             color: Colors.red,
        //           ),
        //         ),
        //       ],
        //     ),
        //     PolylineLayer(
        //       polylines: [
        //         Polyline(
        //           points: [
        //             const LatLng(21.1664583, 72.8413321),
        //             const LatLng(21.173457, 72.838350)
        //           ],
        //           color: Colors.red,
        //           strokeWidth: 3
        //         ),
        //       ],
        //       // polylineCulling: true,
        //     ),
        //   ],
        // ),
        // body: MapboxMap(
        //   styleString: "https://api.mapbox.com/styles/v1/weclocks/clojqzq2j002x01nz71gifnf0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoid2VjbG9ja3MiLCJhIjoiY2xvanA3Y2lhMXk4ajJrcGxlOXkzenczZSJ9.2QbRG8Wkw6bUFNH6UBs7_g",
        //   accessToken: "pk.eyJ1Ijoid2VjbG9ja3MiLCJhIjoiY2xvanA3Y2lhMXk4ajJrcGxlOXkzenczZSJ9.2QbRG8Wkw6bUFNH6UBs7_g",
        //   initialCameraPosition: const CameraPosition(target: LatLng(21.1664583, 72.8413321)),
        //   onMapCreated: (controller) {
        //     controller.addLine(
        //       const LineOptions(
        //         geometry: [
        //           LatLng(21.1664583, 72.8413321),
        //           LatLng(21.173457, 72.838350),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}