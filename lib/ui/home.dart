import 'package:flutter/material.dart';
import 'result.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void _resetCampos() {
    pesoController = TextEditingController();
    alturaController = TextEditingController();
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora de IMC v2.0"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetCampos,
          )
        ], //<Widget>[]
      ), // app bar
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person, size: 120, color: Colors.blueAccent),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                controller: pesoController,
                validator: (value) {
                  if (value!.isEmpty)
                    return "Insira seu peso!";
                  else
                    return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura (m)",
                    labelStyle: TextStyle(color: Colors.blueAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                controller: alturaController,
                validator: (value) {
                  if (value!.isEmpty)
                    return "Insira sua altura!";
                  else
                    return null;
                },
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child:
                      // Adicionando uma Row widget para colocar os dois botões
                      Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly, // Alinhando os botões
                    children: [
                      // Criando um novo ElevatedButton widget com o texto "IMC Ideal" e a função _calcularIMCIdeal() como onPressed
                      ElevatedButton(
                        onPressed:
                            _calcularIMCIdeal, // Chamando a função _calcularIMCIdeal()
                        child: Text(
                          "IMC Ideal",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        style:
                            ElevatedButton.styleFrom(), // Estilizando o botão
                      ),
                      // Mantendo o botão "Calcular" original
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _calcular();
                          }
                        },
                        child: Text(
                          "Calcular",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        style:
                            ElevatedButton.styleFrom(), // Estilizando o botão
                      ),
                    ],
                  )),
            ], //<widget>[]
          ),
        ),
      ),
    );
  }

  void _calcular() {
    String _texto = "";
    String _imagem = "";

    double peso = double.parse(pesoController.text);
    double altura = double.parse(alturaController.text);

    double imc = peso / (altura * altura);
    //debugPrint("Peso ${peso} e altura ${altura}");
    //debugPrint("$imc");
    if (imc < 18.6) {
      _texto = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
      _imagem = "imagens/thin.png";
    } else if (imc >= 18.6 && imc < 24.9) {
      _texto = "Peso ideal (${imc.toStringAsPrecision(4)})";
      _imagem = "imagens/shape.png";
    } else if (imc >= 24.9 && imc < 29.9) {
      _texto = "Levemente acima do peso (${imc.toStringAsPrecision(4)})";
      _imagem = "imagens/fat.png";
    } else if (imc >= 29.9 && imc < 34.9) {
      _texto = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      _imagem = "imagens/fat.png";
    } else if (imc >= 34.9 && imc < 39.9) {
      _texto = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      _imagem = "imagens/fat.png";
    } else if (imc >= 40) {
      _texto = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      _imagem = "imagens/fat.png";
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Result(_imagem, _texto)));
  }

  void _calcularIMCIdeal() {
    // Obtém a altura do controller
    double altura = double.parse(alturaController.text); //?? 0.0;

    //double peso = double.parse(pesoController.text);
    //double altura = double.parse(alturaController.text);

    // Calcula o IMC ideal na faixa de 18,5 a 24,9
    double imcMinimo = 18.5;
    double imcMaximo = 24.9;

    // Calcula o peso ideal correspondente à altura inserida
    double pesoMinimo = imcMinimo * (altura * altura);
    double pesoMaximo = imcMaximo * (altura * altura);

    // Exibe um diálogo com o IMC ideal
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("IMC Ideal"),
          content: Text(
            "Seu IMC ideal deve estar na faixa de $imcMinimo a $imcMaximo.\n"
            "Isso significa que seu peso ideal deve estar entre ${pesoMinimo.toStringAsFixed(2)} kg e ${pesoMaximo.toStringAsFixed(2)} kg.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
