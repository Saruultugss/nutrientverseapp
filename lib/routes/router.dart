import 'package:flutter_app/resources/pages/age_gender_page.dart';
import 'package:flutter_app/resources/pages/allergy_page.dart';
import 'package:flutter_app/resources/pages/current_country_page.dart';
import 'package:flutter_app/resources/pages/food_selection_page.dart';
import 'package:flutter_app/resources/pages/height_weight_page.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/show_stat_page.dart';
import 'package:flutter_app/resources/pages/target_country_page.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:page_transition/page_transition.dart';

/*
|--------------------------------------------------------------------------
| App Router
|
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "flutter pub run nylo_framework:main make:page my_page"
| Learn more https://nylo.dev/docs/3.x/router
|--------------------------------------------------------------------------
*/

appRouter() => nyRoutes((router) {
      router.route("/init/currentCountry", (context) => CurrentCountryPage());
      // router.route("/", (context) => MyHomePage(title: "Hello World"));

      // Add your routes here
      router.route("/init/ageGender", (context) => AgeGenderPage());
      router.route("/init/heightWeight", (context) => HeightWeightPage());
      router.route("/init/targetCountry", (context) => TargetCountryPage());
      router.route("/init/allergy", (context) => AllergyPage());
      router.route("/init/showStat", (context) => ShowStatPage());
      router.route(
          "/home",
          (context) => MyHomePage(
                title: 'Home',
              ),
          transition: PageTransitionType.fade);
      router.route("/foodSelection", (context) => FoodSelectionPage());
    });
