import 'dart:typed_data';
import 'package:bus_karo/models/bus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BusInformation extends StatefulWidget {
  const BusInformation({super.key, required this.bus});
  final Bus bus;

  @override
  State<BusInformation> createState() {
    return _BusInformationState();
  }
}


class _BusInformationState extends State<BusInformation> {

  late Color densityColor;
  late ImageProvider driverImage = const AssetImage('lib/assets/images/DriverPhoto.png');
  bool isLoading = true;

  void _loadData() async{

    double passengerDensity = widget.bus.currentNumberOfPassenger / widget.bus.totalPassengerCapacity;
    if (passengerDensity <= 0.3) {
      densityColor = Colors.green;
    } else if (passengerDensity > 0.3 && passengerDensity <= 0.7) {
      densityColor = Colors.orange;
    } else {
      densityColor = Colors.red;
    }

    final response = await http.post(Uri.parse("https://3cuv2rjor4.execute-api.ap-south-1.amazonaws.com/prod/getDriverPhoto?busUID=${widget.bus.busUID}"));
    final responseBodyBytes = response.bodyBytes;
    driverImage = Image.memory(Uint8List.fromList(responseBodyBytes)).image;
    setState(() {isLoading=false;});
  }


  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return isLoading? const Center(child: CircularProgressIndicator())
        :
    Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 30,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 79.5,
                     ),
                      CircleAvatar(
                        radius: 90,

                        backgroundColor: Colors.blueGrey,
                        backgroundImage: driverImage,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     // const SizedBox(width: 86),
                      Text(widget.bus.driverName,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Text(
                    "${widget.bus.currentNumberOfPassenger.toInt()} / ${widget.bus.totalPassengerCapacity.toInt()}  passengers",
                    style: TextStyle(color: densityColor, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.bus.busNumberPlate,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Route : ${widget.bus.busRouteStart}, ${widget.bus.busRouteEnd}",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 90,
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(widget.bus.temporaryNotification,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 21)),
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
