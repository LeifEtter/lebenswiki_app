import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:lebenswiki_app/application/auth/prefs_handler.dart';
import 'package:lebenswiki_app/application/routing/router.dart';
import 'package:lebenswiki_app/data/category_api.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/widgets/common/theme.dart';
import 'package:lebenswiki_app/data/user_api.dart';
import 'package:lebenswiki_app/application/auth/token_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await dotenv.load(fileName: ".env");
  (String, User?) initRouteResults = await getRoute();
  List<Category> categories = await CategoryApi().getCategories();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c30e1c85e3fcf934335f96d328f23ae0@o4506802868846592.ingest.sentry.io/4506802920226816';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ProviderScope(
          child: LebenswikiApp(
        initialRoute: initRouteResults.$1,
        user: initRouteResults.$2,
        categories: categories,
      )),
    ),
  );
}

Future<(String, User?)> getRoute() async {
  final TokenHandler tokenHandler = TokenHandler();

  if ((await PrefHandler.isBrowsingAnonymously())) {
    return (homeRoute, null);
  }

  String? token = await tokenHandler.get();
  if (token == null || token == "") {
    return (authRoute, null);
  }

  Either<CustomError, User> authResult =
      await UserApi().authenticate(token: token);
  if (authResult.isLeft) {
    return (authRoute, null);
  }
  if (authResult.isRight) {
    return (homeRoute, authResult.right);
  }
  return (authRoute, null);
}

class LebenswikiApp extends ConsumerWidget {
  final String initialRoute;
  final User? user;
  final List<Category> categories;

  const LebenswikiApp({
    super.key,
    required this.initialRoute,
    this.user,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      user != null
          ? ref.read(userProvider).setUser(user!)
          : ref.read(userProvider).removeUser();
      ref.read(categoryProvider).setCategories(categories);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lebenswiki",
      theme: buildTheme(Brightness.light),
      onGenerateRoute: generateRoute,
      initialRoute: initialRoute,
    );
  }

  Widget backendDown() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text("Backend wird derzeit gewartet,"),
            ),
            Text("versuche es später erneut."),
          ],
        ),
      );
}
