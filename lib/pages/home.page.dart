import 'package:conversor_de_moedas/service/currency.service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double dolar;
  double euro;

  final controladorReal = TextEditingController();
  final controladorDolar = TextEditingController();
  final controladorEuro = TextEditingController();

  void realModificado(String texto) {
    if (texto.isEmpty) {
      limparCampos();
      return;
    }
    double real = double.parse(texto);
    controladorEuro.text = (real / euro).toStringAsFixed(2);
    controladorDolar.text = (real / dolar).toStringAsFixed(2);
  }

  void dolarModificado(String texto) {
    if (texto.isEmpty) {
      limparCampos();
      return;
    }
    double dolar = double.parse(texto);
    controladorEuro.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    controladorReal.text = (dolar * this.dolar).toStringAsFixed(2);
  }

  void euroModificado(String texto) {
    if (texto.isEmpty) {
      limparCampos();
      return;
    }
    double euro = double.parse(texto);
    controladorDolar.text = (euro * this.euro / dolar).toStringAsFixed(2);
    controladorReal.text = (euro * this.euro).toStringAsFixed(2);
  }

  void limparCampos() {
    controladorReal.text = "";
    controladorDolar.text = "";
    controladorEuro.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de moedas"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: limparCampos,
          ),
        ],
      ),
      body: FutureBuilder<Map>(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao carregar dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          "Reais", "R\$", controladorReal, realModificado),
                      Divider(),
                      buildTextField(
                          "Dólares", "US\$", controladorDolar, dolarModificado),
                      Divider(),
                      buildTextField(
                          "Euros", "€", controladorEuro, euroModificado),
                    ],
                  ),
                );
              }
          }
        },
        future: getData(),
      ),
    );
  }
}

buildTextField(
  String label,
  String prefixo,
  TextEditingController controlador,
  Function funcao,
) {
  return TextFormField(
    controller: controlador,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.amber,
        fontSize: 20,
      ),
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25,
    ),
    onChanged: funcao,
  );
}
