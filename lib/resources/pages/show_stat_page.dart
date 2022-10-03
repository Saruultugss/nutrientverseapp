import 'package:animated_digit/animated_digit.dart';
import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ShowStatPage extends StatefulWidget {
  ShowStatPage({Key? key}) : super(key: key);

  @override
  _ShowStatPageState createState() => _ShowStatPageState();
}

class _ShowStatPageState extends NyState<ShowStatPage>
    with SingleTickerProviderStateMixin {
  SPService _spService = SPService();

  late int? height;
  late int? weight;
  late int? age;
  late String? gender;
  late int? currentId;
  late String? targetId;
  late List<String>? allergy;

  double? _bmi = 0.0;
  int? _calories = 0;
  int? _protein = 0;
  int? _carbs = 0;

  double? calcBmi(int weight, int height) {
    double bmi;
    bmi = weight.toDouble() /
        (height.toDouble() / 100) /
        (height.toDouble() / 100);
    return (bmi * 10).roundToDouble() / 10;
  }

  int calcProtein(int weight) {
    return (weight * 0.8).toInt();
  }

  int calcCarbs(int weight, int height, int age, String gender) {
    int carbs = 0;
    // BMR (Females) = 10 x Weight (kg) + 6.25 x Height (cm) - 5 x Age (years) + 5
    // BMR (Males) = 10 x Weight (kg) + 6.25 x Height (cm) - 5 x Age (years) – 161
    if (gender.toString().compareTo("Gender.Male") == 0) {
      carbs = (10 * weight + 6.25 * height - 5 * age - 161) * 0.7 ~/ 4;
    } else {
      carbs = (10 * weight + 6.25 * height - 5 * age + 5) * 0.7 ~/ 4;
    }
    return carbs;
  }

  int? calcCalory(int vital_no, int age, int weight, String gender) {
    double vital = 0;

    if (age >= 15 && age <= 69) {
      if (vital_no == 1) {
        vital = 1.5;
      } else if (vital_no == 2) {
        vital = 1.75;
      } else {
        vital = 2;
      }
    } else {
      if (vital_no == 1) {
        vital = 1.3;
      } else if (vital_no == 2) {
        vital = 1.5;
      } else {
        vital = 1.7;
      }
    }

    double t_std;
    if (gender.toString().compareTo("Gender.Male") == 0) {
      if (age >= 1 && age <= 2) {
        t_std = 61;
      } else if (age >= 3 && age <= 5) {
        t_std = 54.8;
      } else if (age >= 6 && age <= 7) {
        t_std = 44.3;
      } else if (age >= 8 && age <= 9) {
        t_std = 40.8;
      } else if (age >= 10 && age <= 11) {
        t_std = 37.4;
      } else if (age >= 12 && age <= 14) {
        t_std = 31;
      } else if (age >= 15 && age <= 17) {
        t_std = 27;
      } else if (age >= 18 && age <= 29) {
        t_std = 24;
      } else if (age >= 30 && age <= 49) {
        t_std = 22.3;
      } else if (age >= 50 && age <= 69) {
        t_std = 21.5;
      } else {
        t_std = 21.5;
      }
    } else {
      if (age >= 1 && age <= 2) {
        t_std = 59.7;
      } else if (age >= 3 && age <= 5) {
        t_std = 52.2;
      } else if (age >= 6 && age <= 7) {
        t_std = 41.9;
      } else if (age >= 8 && age <= 9) {
        t_std = 38.3;
      } else if (age >= 10 && age <= 11) {
        t_std = 34.8;
      } else if (age >= 12 && age <= 14) {
        t_std = 29.6;
      } else if (age >= 15 && age <= 17) {
        t_std = 25.3;
      } else if (age >= 18 && age <= 29) {
        t_std = 23.6;
      } else if (age >= 30 && age <= 49) {
        t_std = 21.7;
      } else if (age >= 50 && age <= 69) {
        t_std = 20.7;
      } else {
        t_std = 20.7;
      }
    }
    return (t_std * weight.toDouble() * vital).toInt();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  init() async {
    height = await _spService.fetchInt(key: "height");
    weight = await _spService.fetchInt(key: "weight");
    age = await _spService.fetchInt(key: "age");
    gender = await _spService.fetchString(key: "gender");
    currentId = await _spService.fetchInt(key: "currentCountryId");
    targetId = await _spService.fetchString(key: "targetCountryId");
    allergy = await _spService.fetchStringList(key: "allergy");
    print("ALlergy : " + allergy.toString());
    setState(() {
      _bmi = calcBmi(weight!, height!);
      _calories = calcCalory(1, age!, weight!, gender!);
      _protein = calcProtein(weight!);
      _carbs = calcCarbs(weight!, height!, age!, gender!);
    });
    _spService.storeInt(key: "oneDayCalories", value: _calories!);
    _spService.storeInt(key: "oneDayProtein", value: _protein!);
    _spService.storeInt(key: "oneDayCarbs", value: _carbs!);
    _spService.storeString(key: "BMI", value: _bmi.toString());
  }

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
          "一日の栄養量",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "一日に必要な栄養要素",
                  style: TextStyle(fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Table(children: <TableRow>[
                    TableRow(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Iconify(
                                Emojione.control_knobs,
                                size: 15,
                              )),
                          Text(
                            "BMI: ",
                            style: TextStyle(fontSize: 20),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          AnimatedDigitWidget(
                            value: _bmi,
                            enableSeparator: true,
                            fractionDigits: 1,
                            duration: Duration(milliseconds: 900),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ]),
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Iconify(Twemoji.fire, size: 15)),
                          Text(
                            "エネルギー: ",
                            style: TextStyle(fontSize: 20),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          AnimatedDigitWidget(
                            value: _calories,
                            duration: Duration(milliseconds: 900),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "kcal",
                            style: TextStyle(fontSize: 20),
                          )
                        ]),
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Iconify(Emojione.meat_on_bone, size: 15)),
                          Text(
                            "タンパク質: ",
                            style: TextStyle(fontSize: 20),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          AnimatedDigitWidget(
                            value: _protein,
                            duration: Duration(milliseconds: 900),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "g",
                            style: TextStyle(fontSize: 20),
                          )
                        ]),
                      ),
                    ]),
                    TableRow(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Iconify(Emojione.bread, size: 15)),
                          Text(
                            "炭水化物: ",
                            style: TextStyle(fontSize: 20),
                          ),
                        ]),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Row(children: <Widget>[
                          AnimatedDigitWidget(
                            value: _carbs,
                            duration: Duration(milliseconds: 900),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "g",
                            style: TextStyle(fontSize: 20),
                          )
                        ]),
                      ),
                    ])
                  ]),
                ),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _spService.storeBool(
              key: SPService.registrationComplete, value: true);
          Navigator.pushNamed(context, "/home");
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
