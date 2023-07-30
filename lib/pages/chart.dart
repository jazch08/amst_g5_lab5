import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

class Chart extends StatefulWidget {
  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late List<Registro> _data;
  late List<charts.Series<Registro, String>> _chardata;
  late DatabaseReference _dataref;
  void _makeData() {
    _chardata.add(charts.Series(
      domainFn: (Registro registro, _) => registro.fecha + " " + registro.hora,
      measureFn: (Registro registro, _) => registro.temperatura,
      id: 'Registros',
      data: _data,
    ));
  }

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    _dataref = database.ref();
    _data = <Registro>[];
    _chardata = <charts.Series<Registro, String>>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return StreamBuilder(
        stream: _dataref.onValue,
        builder: (context, snapshot) {
          print("--------------------------------");
          print(snapshot.data);
          print("--------------------------------");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  CircularProgressIndicator(), // Muestra un indicador de carga mientras esperas los datos.
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text(
                "No hay datos disponibles"); // Manejo de datos nulos o sin información.
          } else {
            List<Registro> registros = <Registro>[];
            Map data = (snapshot.data as dynamic).snapshot.value;
            for (Map childata in data["Grupos"].values) {
              var datos = childata.values;
              datos.forEach((element) {
                var fecha = element["received_at"].toString();
                var temperatura = element?["uplink_message"]?["decoded_payload"]?["temp"]?.toString();
                var humedad = element?["uplink_message"]?["decoded_payload"]?["humedad"]?.toString();
                temperatura ??= "0";
                humedad ??= "0";
                registros.add(Registro(fecha, temperatura, humedad));
              });
            }
            return _builChart(context, registros);
          }
        });
  }

  Widget _builChart(BuildContext context, List<Registro> registros) {
    _data = registros;
    _makeData();
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Diagrama de barras de temperaturas G1"),
              SizedBox(height: 10.0),
              Expanded(
                child: charts.BarChart(
                  _chardata,
                  animate: true,
                  animationDuration: Duration(seconds: 1),
                  vertical: false,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Registro {
  String fecha = '';
  String hora = '';
  double temperatura = 0;
  double humedad = 0;
  Registro(fecha, temperatura, humedad) {
    this.fecha = fecha.split("T")[0];
    this.hora = fecha.split(".")[0].split("T")[1];
    this.temperatura = double.parse(temperatura);
    this.humedad = double.parse(humedad);
  }
}
