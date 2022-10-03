import 'dart:convert';

import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';

class FoodSelectionPage extends StatefulWidget {
  FoodSelectionPage({Key? key}) : super(key: key);

  @override
  _FoodSelectionPageState createState() => _FoodSelectionPageState();
}

class _FoodSelectionPageState extends NyState<FoodSelectionPage> {
  bool isSelectionMode = true;
  List _foods = [];
  String? _targetCountryId = "";
  Map<int, bool> selectedFlag = {};
  SPService _spService = SPService();

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('public/assets/datas/meal.json');
    final data = await json.decode(response);
    _foods = data["data"];

    _foods.removeWhere((food) => food["countryId"] != _targetCountryId);
    setState(() {});
  }

  @override
  init() async {
    _targetCountryId =
        await _spService.fetchString(key: SPService.targetCountryId);
    readJson();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
    }
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _buildSelectIcon(bool isSelected, Map data) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text('${data['id']}'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('メニュー'),
      ),
      body: SafeArea(
        // TODO: Sort by nutrients
        child: ListView.builder(
          itemBuilder: (builder, index) {
            Map data = _foods[index];
            selectedFlag[index] = selectedFlag[index] ?? false;
            bool? isSelected = selectedFlag[index];

            return ListTile(
              onLongPress: () => onLongPress(isSelected!, index),
              onTap: () => onTap(isSelected!, index),
              title: Text("${data['name']}"),
              leading: _buildSelectIcon(isSelected!, data),
              subtitle: Table(children: <TableRow>[
                TableRow(
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Iconify(Twemoji.fire, size: 15)),
                      Text("エネルギー:${data['energy']}kcal"),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Iconify(Emojione.meat_on_bone, size: 15)),
                      Text("タンパク質:${data['protein']}g"),
                    ]),
                  ],
                ),
                TableRow(
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Iconify(Emojione.bread, size: 15)),
                      Text("炭水化物:${data['carbohydrate']}g"),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Iconify(Emojione.peanuts, size: 15)),
                      Text("脂質:${data['lipid']}g"),
                    ])
                  ],
                ),
              ]),
            );
          },
          itemCount: _foods.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          List<int> selected = [];
          for (int k in selectedFlag.keys) {
            if (selectedFlag[k] == true) {
              selected.add(k);
            }
          }

          Navigator.pop(context, selected);
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
