import 'dart:developer';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  late final dataD;
  late DatabaseReference _dataref;
  @override
  void initState() {
    _dataref = FirebaseDatabase.instance.ref("Grupos");
    print("datared");
    print(_dataref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Tab(
        child: Text("Data from database"),
      ),
      _crearListado(context),
    ]);
  }

  Widget _crearListado(BuildContext context) {
    print("estoy en crear");
    return Expanded(
      child: FirebaseAnimatedList(
          query: _dataref,
          itemBuilder: (context, snapshot, animation, index) {
            Map data = snapshot.value as Map;

            List<Widget> widgetList = [];

            data.forEach((key, value) {

              var id = value?["end_device_ids"]?["device_id"];
              var humedad = value?["uplink_message"]?["decoded_payload"]?["humedad"];
              humedad??=0;
              var temperatura = value?["uplink_message"]?["decoded_payload"]?["temp"];
              temperatura??=0;
              var fecha = value?["received_at"];

              var listItem = Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                  title: Text("ID: $id",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle:
                      Text("Humedad: $humedad\nTemperatura: $temperatura"),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Fecha: ${fecha.split("T")[0]}"),
                      Text("Hora: ${fecha.split(".")[0].split("T")[1]}"),
                    ],
                  )),
            );

            widgetList.add(listItem);

             });
            return Column(children: widgetList);
          }),
    );
  }
}
