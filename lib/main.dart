import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:flutter_app/bootstrap/app.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'bootstrap/boot.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Nylo nylo = await Nylo.init(setup: Boot.nylo, setupFinished: Boot.finished);
  SPService _spService = SPService();

  bool? _registrationComplete =
      await _spService.fetchBool(key: SPService.registrationComplete);

  runApp(
    AppBuild(
      initialRoute: _registrationComplete == null || !_registrationComplete
          ? "/init/currentCountry"
          : "/home",
      navigatorKey: NyNavigator.instance.router.navigatorKey,
      onGenerateRoute: nylo.router!.generator(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
