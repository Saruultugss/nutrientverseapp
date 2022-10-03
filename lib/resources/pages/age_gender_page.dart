import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/register_controller.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:gender_picker/gender_picker.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AgeGenderPage extends StatefulWidget {
  final RegisterController controller = RegisterController();
  AgeGenderPage({Key? key}) : super(key: key);

  @override
  _AgeGenderPageState createState() => _AgeGenderPageState();
}

class _AgeGenderPageState extends NyState<AgeGenderPage> {
  @override
  void dispose() {
    super.dispose();
  }

  int _age = 18;
  String _gender = Gender.Male.toString();
  SPService _spService = SPService();

  @override
  init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "年齢と性別",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: [
                Text(
                  '年齢',
                  style: TextStyle(fontSize: 25),
                ),
                NumberPicker(
                  value: _age,
                  minValue: 0,
                  maxValue: 100,
                  textMapper: (numberText) {
                    return numberText;
                  },
                  onChanged: (value) => setState(() => _age = value),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '性別',
                  style: TextStyle(fontSize: 25),
                ),
                GenderPickerWithImage(
                  showOtherGender: true,
                  verticalAlignedText: true,
                  selectedGender: Gender.Male,
                  selectedGenderTextStyle: TextStyle(
                      color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
                  unSelectedGenderTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal),
                  onChanged: (Gender? gender) {
                    _gender = gender.toString();
                  },
                  equallyAligned: true,
                  animationDuration: Duration(milliseconds: 300),
                  isCircular: true,
                  // default : true,
                  opacityOfGradient: 0.4,
                  padding: const EdgeInsets.all(3),
                  size: 50, //default : 40
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _spService.storeInt(key: "age", value: _age);
          _spService.storeString(key: "gender", value: _gender);
          Navigator.pushNamed(context, "/init/heightWeight");
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
