import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const URI = "https://api.hgbrasil.com/finance?format=json&key=60df7606";

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
  theme: ThemeData(
    hintColor: Colors.amber,
    primaryColor: Colors.amber
  )));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final reaisController = TextEditingController();

  double dolar;
  double euro;

  void _euroChanged(value) {
    double interEuro = double.parse(value);
    reaisController.text = (interEuro * this.euro).toStringAsFixed(2);
    dolarController.text = (interEuro * this.euro / dolar).toStringAsFixed(2);
  }

  void _dolarChanged(value) {
    double interDolar = double.parse(value);
    reaisController.text = (interDolar * this.dolar).toStringAsFixed(2);
    euroController.text = (interDolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _reaisChanged(value) {
    double real = double.parse(value);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('\$ Conversor \$'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando dados...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.amber, fontSize: 29.0)),
              );
            default:
              if(snapshot.hasError) {
                return Center(
                  child: Text('Error ao carregar dados',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.amber, fontSize: 29.0)),
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];
                print(dolar);
                print(euro);
                return SingleChildScrollView(
                  padding: EdgeInsets.only(top: 15.0, left: 12.0, right: 12.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,size: 150.0, color: Colors.amber),
                      TextField(
                        onChanged: _reaisChanged,
                        controller: reaisController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Reais',
                            labelStyle: TextStyle(color: Colors.amber, fontSize: 30.0),
                            border: OutlineInputBorder(),
                            prefixText: 'R\$ '
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      ),
                      Divider(),
                      TextField(
                        controller: dolarController,
                        onChanged: _dolarChanged,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Dólares',
                            labelStyle: TextStyle(color: Colors.amber, fontSize: 30.0),
                            border: OutlineInputBorder(),
                            prefixText: 'US\$ '
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      ),
                      Divider(),
                      TextField(
                        controller: euroController,
                        onChanged: _euroChanged,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Euro',
                            labelStyle: TextStyle(color: Colors.amber, fontSize: 30.0),
                            border: OutlineInputBorder(),
                            prefixText: '€ '
                        ),
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      )
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

/**
 * API
 */
Future<Map> getData() async {
  http.Response response = await http.get(URI);
  return json.decode(response.body);
}
