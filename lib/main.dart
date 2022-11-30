import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'common/url_page.dart';
import 'core/db/database_helper.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.init();
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final AppRouter router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.indigo,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: UrlPage.signIn,
      onGenerateRoute: router.generateRouter,
    );
  }
}
