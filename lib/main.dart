import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // VARIAVEIS
  final _tConta = TextEditingController();
  final _tContaBebida = TextEditingController();
  final _tPessoas = TextEditingController();
  final _tPessoasBebida = TextEditingController();
  double _tGarcom = 0.0;
  var _infoText = "Valor Garçom:\tR\$ 0,00";
  var _infoText1 = "Valor Total:\tR\$ 0,00";
  var _infoText2 = "Valor Individual (s/bebida):\tR\$ 0,00";
  var _infoText3 = "Valor Individual (c/bebida):\tR\$ 0,00";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racha Contas"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields() {
    _tConta.text = "";
    _tContaBebida.text = "";
    _tPessoas.text = "";
    _tPessoasBebida.text = "";
    setState(() {
      _infoText = "Valor Garçom:\tR\$ 0,00";
      _infoText1 = "Valor Total:\tR\$ 0,00";
      _infoText2 = "Valor Individual (s/bebida):\tR\$ 0,00";
      _infoText3 = "Valor Individual (c/bebida):\tR\$ 0,00";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _textLabel("Total da conta (s/bebida)"),
              _editText("total da conta (s/bebida).", _tConta),
              _textLabel("Total da bebida"),
              _editText("total da bebida.", _tContaBebida),
              _textLabel("Quantas pessoas (s/bebida)"),
              _editText("quantas pessoas (s/bebida).", _tPessoas),
              _textLabel("Quantas pessoas (c/bebida)"),
              _editText("quantas pessoas (c/bebida).", _tPessoasBebida),
              _textLabel("Porcentagem do Garçom"),
              _editSlider(),
              _buttonCalcular(),
              _textInfo(_infoText),
              _textInfo(_infoText1),
              _textInfo(_infoText2),
              _textInfo(_infoText3),
            ],
          ),
        ));
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: Colors.red,
      ),
    );
  }

  _editSlider() {
    return Slider(
      value: _tGarcom,
      min: 0,
      max: 100,
      divisions: 10,
      label: _tGarcom.round().toString(),
      onChanged: (double value) {
        setState(() {
          _tGarcom = value;
        });
      },
    );
  }

  // PROCEDIMENTO PARA VALIDAR OS CAMPOS
  String _validate(String text, String field) {
    if (text.isEmpty) {
      return "Digite $field";
    }
    return null;
  }

  // Widget button
  _buttonCalcular() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      height: 45,
      child: RaisedButton(
        color: Colors.red,
        child: Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _calculate();
          }
        },
      ),
    );
  }

  // PROCEDIMENTO PARA CALCULAR O IMC
  void _calculate() {
    setState(() {
      double comida = double.parse(_tConta.text);
      double bebida = double.parse(_tContaBebida.text);
      double comidaBebida = comida + bebida;
      double garcom = comidaBebida * (_tGarcom / 100.0);
      double total = comidaBebida + garcom;

      double individual = (comida + garcom) /
          (double.parse(_tPessoas.text) + double.parse(_tPessoasBebida.text));
      double individualBebida = individual;
      individualBebida += bebida / double.parse(_tPessoasBebida.text);

      _infoText = "Valor Garçom:\tR\$ ${garcom}";
      _infoText1 = "Valor Total:\tR\$ ${total}";
      _infoText2 = "Valor Individual (s/bebida):\tR\$ ${individual}";
      _infoText3 = "Valor Individual (c/bebida):\tR\$ ${individualBebida}";

      /*double = double.parse(_tPeso.text);
      double altura = double.parse(_tAltura.text) / 100;
      double imc = peso / (altura * altura);
      String imcStr = imc.toStringAsPrecision(4);
      _infoText = imcStr;*/
    });
  }

  // // Widget text
  _textInfo(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black, fontSize: 18.0),
    );
  }

  _textLabel(String label) {
    return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          label,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black, fontSize: 18.0),
        ));
  }
}
