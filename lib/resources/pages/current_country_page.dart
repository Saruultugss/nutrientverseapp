import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/controllers/register_controller.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double _kItemExtent = 32.0;

// List<CountrySelection> _countries = <CountrySelection>[
//   CountrySelection(
//       "Japan", Image.asset('icons/flags/png/jp.png', package: 'country_icons')),
//   CountrySelection(
//       "USA", Image.asset('icons/flags/png/us.png', package: 'country_icons')),
//   CountrySelection("Vietnam",
//       Image.asset('icons/flags/png/vn.png', package: 'country_icons')),
//   CountrySelection("Mongolia",
//       Image.asset('icons/flags/png/mn.png', package: 'country_icons')),
//   CountrySelection("Thailand",
//       Image.asset('icons/flags/png/th.png', package: 'country_icons')),
//   CountrySelection(
//       "China", Image.asset('icons/flags/png/cn.png', package: 'country_icons')),
// ];

class CurrentCountryPage extends StatefulWidget {
  final RegisterController controller = RegisterController();

  CurrentCountryPage({Key? key}) : super(key: key);

  @override
  _CurrentCountryPageState createState() => _CurrentCountryPageState();
}

class _CurrentCountryPageState extends NyState<CurrentCountryPage> {
  int _selectedCountry = 0;
  List _countries = [];
  SPService _spService = SPService();

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('public/assets/datas/country.json');
    final data = await json.decode(response);
    setState(() {
      _countries = data["data"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

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
          "??????",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: _countries.length > 0
                    ? Image.asset(
                        'icons/flags/png/' +
                            _countries[_selectedCountry]["language_short"]
                                .toLowerCase() +
                            '.png',
                        package: 'country_icons')
                    : Text("")),
          ),
          Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            // The Bottom margin is provided to align the popup above the system navigation bar.
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // Provide a background color for the popup.
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(
              top: false,
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.2,
                useMagnifier: true,
                itemExtent: _kItemExtent,
                // This is called when selected item is changed.
                onSelectedItemChanged: (int selectedItem) {
                  setState(() {
                    _selectedCountry = selectedItem;
                  });
                },
                children: List<Widget>.generate(_countries.length, (int index) {
                  return Center(
                    child: Text(
                      _countries[index]["name"],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _spService.storeInt(key: "currentCountryId", value: _selectedCountry);
          Navigator.pushNamed(context, "/init/ageGender");
        },
        child: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
