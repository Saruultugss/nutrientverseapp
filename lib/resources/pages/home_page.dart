import 'dart:convert';
import 'dart:math';

import 'package:animations/animations.dart';
import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/app/controllers/home_controller.dart';
import 'package:flutter_app/app/networking/sp_service.dart';
import 'package:flutter_app/resources/widgets/nutrient_bar_widget.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:colorful_iconify_flutter/icons/twemoji.dart';

enum LegendShape { circle, rectangle }

class MyHomePage extends NyStatefulWidget {
  final HomeController controller = HomeController();
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends NyState<MyHomePage>
    with TickerProviderStateMixin {
  late List<Widget> tabItems;
  SPService _spService = SPService();
  int? _protein = 0;
  int? _calories = 0;
  int? _carbs = 0;

  int? _proteinPerc = 0;
  int? _caloriesPerc = 0;
  int? _carbsPerc = 0;

  String? _targetCountryId = "";
  List _foods = [];
  List _recommendationFoods = [];

  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  List<ChartSeries<_ChartData, String>>? _getStackedBarSeries;
  List<_ChartData>? chartData;
  TooltipBehavior? _tooltipBehavior;

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('public/assets/datas/meal.json');
    final data = await json.decode(response);
    _foods = data["data"];
    _foods.removeWhere((food) => food["countryId"] != _targetCountryId);
  }

  recommendFood() {
    _recommendationFoods.clear();
    var rng = Random();
    for (var i = 0; i < 4; i++) {
      int index = rng.nextInt(_foods.length);
      _recommendationFoods.add(_foods[index]);
    }

    setState(() {
      _recommendationFoods;
    });
    calcTotal();
  }

  calcTotal() {
    int energy = 0;
    int protein = 0;
    int carbohydrate = 0;
    int lipid = 0;
    _getStackedBarSeries!.clear();

    chartData![0].values.clear();
    chartData![1].values.clear();
    chartData![2].values.clear();
    chartData![3].values.clear();

    // chartData = <_ChartData>[
    //   _ChartData('脂質', 12, 15, 2),
    //   _ChartData('タンパク質', 25, 20, 3),
    //   _ChartData('炭水化物', 60, 75, 15),
    //   _ChartData('エネルギー', 700, 600, 300),
    // ];
    for (var food in _recommendationFoods) {
      energy += int.parse(food["energy"]);
      protein += int.parse(food["protein"]);
      carbohydrate += int.parse(food["carbohydrate"]);
      lipid += int.parse(food["lipid"]);

      chartData![0].values.add(int.parse(food["lipid"]));
      chartData![1].values.add(int.parse(food["protein"]));
      chartData![2].values.add(int.parse(food["carbohydrate"]));
      chartData![3].values.add(int.parse(food["energy"]));

      _getStackedBarSeries!.add(StackedBar100Series<_ChartData, String>(
          dataSource: chartData!,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) =>
              sales.values[_recommendationFoods.indexOf(food)],
          name: food["name"]));
    }

    setState(() {
      _proteinPerc = protein * 100 ~/ _protein!;
      _carbsPerc = carbohydrate * 100 ~/ _carbs!;
      _caloriesPerc = energy * 100 ~/ _calories!;
      _getStackedBarSeries;
    });
  }

  @override
  init() async {
    _protein = await _spService.fetchInt(key: SPService.oneDayProtein);
    _calories = await _spService.fetchInt(key: SPService.oneDayCalories);
    _carbs = await _spService.fetchInt(key: SPService.oneDayCarbs);
    _targetCountryId =
        await _spService.fetchString(key: SPService.targetCountryId);

    readJson().then((value) {
      recommendFood();
    });
  }

  @override
  void initState() {
    super.initState();

    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: true);

    chartData = <_ChartData>[
      _ChartData('脂質'),
      _ChartData('タンパク質'),
      _ChartData('炭水化物'),
      _ChartData('エネルギー'),
    ];
    _getStackedBarSeries = <ChartSeries<_ChartData, String>>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: ScrollOnExpand(
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToExpand: false,
                            tapBodyToCollapse: false,
                            hasIcon: false,
                          ),
                          header: Container(
                            color: Colors.indigoAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ExpandableIcon(
                                    theme: const ExpandableThemeData(
                                      expandIcon: Icons.arrow_right,
                                      collapseIcon: Icons.arrow_drop_down,
                                      iconColor: Colors.white,
                                      iconSize: 28.0,
                                      iconRotationAngle: 3.14 / 2,
                                      iconPadding: EdgeInsets.only(right: 0),
                                      hasIcon: false,
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NutrientBar(
                                          percentage: _caloriesPerc!,
                                          nutrientName: "エネルギー",
                                          barColor: Colors.red.shade400,
                                        ),
                                        NutrientBar(
                                          percentage: _proteinPerc!,
                                          nutrientName: "タンパク質",
                                          barColor: Colors.amber,
                                        ),
                                        NutrientBar(
                                          percentage: _carbsPerc!,
                                          nutrientName: "炭水化物",
                                          barColor: Colors.greenAccent,
                                        ),
                                        NutrientBar(
                                          percentage: 90,
                                          nutrientName: "脂質",
                                          barColor: Colors.pinkAccent,
                                        ),
                                        // NutrientBar(
                                        //   percentage: 10,
                                        //   nutrientName: "カルシウム",
                                        //   barColor: Colors.lightBlue.shade200,
                                        // ),
                                        // NutrientBar(
                                        //   percentage: 85,
                                        //   nutrientName: "糖質",
                                        //   barColor: Colors.blueGrey,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          collapsed: Container(),
                          expanded: Container(
                            height: 500,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SfCartesianChart(
                                    plotAreaBorderWidth: 1,
                                    title: ChartTitle(text: '各食から摂取する栄養量'),
                                    legend: Legend(
                                        isVisible: true,
                                        position: LegendPosition.bottom,
                                        overflowMode:
                                            LegendItemOverflowMode.wrap,
                                        shouldAlwaysShowScrollbar: true),
                                    primaryXAxis: CategoryAxis(
                                      majorGridLines:
                                          const MajorGridLines(width: 0),
                                    ),
                                    primaryYAxis: NumericAxis(
                                        rangePadding: ChartRangePadding.none,
                                        axisLine: const AxisLine(width: 0),
                                        majorTickLines:
                                            const MajorTickLines(size: 0)),
                                    series: _getStackedBarSeries,
                                    tooltipBehavior: _tooltipBehavior,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
              Center(
                child: Text(
                  "今日のメニュー",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _recommendationFoods.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _recommendationFoods[index];
                      return Dismissible(
                        key: Key(item["id"]),
                        onDismissed: (direction) {
                          setState(() {
                            _recommendationFoods.removeAt(index);
                          });
                          calcTotal();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${item["name"]}が削除されました。')));
                        },
                        child: OpenContainer<bool>(
                          transitionType: _transitionType,
                          openBuilder: (context, openContainer) =>
                              _DetailsPage(_recommendationFoods[index]),
                          tappable: false,
                          closedShape: const RoundedRectangleBorder(),
                          closedElevation: 0,
                          closedBuilder: (context, openContainer) {
                            return ListTile(
                              onTap: openContainer,
                              title:
                                  Text('${_recommendationFoods[index]["name"]}',
                                      style: TextStyle(
                                        fontSize: 22,
                                      )),
                              subtitle: Table(children: <TableRow>[
                                TableRow(
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Iconify(Twemoji.fire,
                                                  size: 15)),
                                          Text("エネルギー:" +
                                              _recommendationFoods[index]
                                                  ["energy"] +
                                              "kcal"),
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Iconify(
                                                  Emojione.meat_on_bone,
                                                  size: 15)),
                                          Text("タンパク質:" +
                                              _recommendationFoods[index]
                                                  ["protein"] +
                                              "g"),
                                        ]),
                                  ],
                                ),
                                TableRow(
                                  children: <Widget>[
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Iconify(Emojione.bread,
                                                  size: 15)),
                                          Text("炭水化物:" +
                                              _recommendationFoods[index]
                                                  ["carbohydrate"] +
                                              "g"),
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Iconify(Emojione.peanuts,
                                                  size: 15)),
                                          Text("脂質:" +
                                              _recommendationFoods[index]
                                                  ["lipid"] +
                                              "g"),
                                        ])
                                  ],
                                ),
                              ]),
                            );
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(onPressed: recommendFood, child: Text("もう一度")),
              ElevatedButton(
                  onPressed: () async {
                    final result =
                        await Navigator.pushNamed(context, "/foodSelection");
                    if (result != null) {
                      for (int id in (result) as List<int>) {
                        _recommendationFoods.add(_foods[id]);
                      }
                      calcTotal();
                      setState(() {
                        _recommendationFoods;
                      });
                    }
                  },
                  child: Text("メニューから追加"))
            ],
          ),
        ));
  }
}

class _ChartData {
  _ChartData(this.x);
  final String x;
  List<num> values = [];
}

class _DetailsPage extends StatelessWidget {
  final dynamic _food;

  const _DetailsPage(this._food);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _food["name"],
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.black38,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(70),
              child: Image.asset(
                getImageAsset("nylo_logo.png"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  _food["description"],
                  style: textTheme.bodyText2!.copyWith(
                    color: Colors.black54,
                    height: 1.5,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
