import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AllergyPage extends StatefulWidget {
  AllergyPage({Key? key}) : super(key: key);

  @override
  _AllergyPageState createState() => _AllergyPageState();
}

class _AllergyPageState extends NyState<AllergyPage> {
  SPService _spService = SPService();
  List<String> tags = [];
  List<String> options = [
    'たまご',
    '乳',
    '小麦',
    'ごま',
    'えび',
    'かに',
    '落花生',
    'そば',
    'アーモンド',
    'リンゴ',
    'もも',
    'バナナ',
    '豚肉',
    '牛肉',
    '鶏肉',
  ];

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
          "アレルギー",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: ChipsChoice<String>.multiple(
                  value: tags,
                  onChanged: (val) => setState(() => tags = val),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: options,
                    value: (i, v) => v,
                    label: (i, v) => v,
                  ),
                  choiceStyle: C2ChoiceStyle(
                      showCheckmark: false,
                      color: Colors.blue,
                      labelStyle: TextStyle(fontSize: 20)),
                  wrapped: true,
                ),
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _spService.storeStringList(key: "allergy", value: tags);
          Navigator.pushNamed(context, "/init/showStat");
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
