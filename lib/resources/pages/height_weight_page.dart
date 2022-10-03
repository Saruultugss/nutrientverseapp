import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:numberpicker/numberpicker.dart';

class HeightWeightPage extends StatefulWidget {
  HeightWeightPage({Key? key}) : super(key: key);

  @override
  _HeightWeightPageState createState() => _HeightWeightPageState();
}

class _HeightWeightPageState extends NyState<HeightWeightPage> {
  int _height = 165;
  int _weight = 60;
  SPService _spService = SPService();

  @override
  init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "身長と体重",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "身長",
                    style: TextStyle(fontSize: 25),
                  ),
                  NumberPicker(
                    value: _height,
                    minValue: 100,
                    maxValue: 250,
                    textMapper: (numberText) {
                      return numberText + "cm";
                    },
                    onChanged: (value) => setState(() => _height = value),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "体重",
                    style: TextStyle(fontSize: 25),
                  ),
                  NumberPicker(
                    value: _weight,
                    minValue: 0,
                    maxValue: 150,
                    textMapper: (numberText) {
                      return numberText + "kg";
                    },
                    onChanged: (value) => setState(() => _weight = value),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _spService.storeInt(key: "height", value: _height);
          _spService.storeInt(key: "weight", value: _weight);
          Navigator.pushNamed(context, "/init/targetCountry");
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
