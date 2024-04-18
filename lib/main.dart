import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/application/auth/prefs_handler.dart';

import 'package:lebenswiki_app/data/category_api.dart';
import 'package:lebenswiki_app/domain/models/category.model.dart';
import 'package:lebenswiki_app/domain/models/error.model.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/domain/models/user/user.model.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
import 'package:lebenswiki_app/presentation/providers/providers.dart';
import 'package:lebenswiki_app/presentation/screens/creator/creator.dart';
import 'package:lebenswiki_app/presentation/screens/creator/creator_information.dart';
import 'package:lebenswiki_app/presentation/screens/main/authentication.dart';
import 'package:lebenswiki_app/presentation/screens/main/short_creation.dart';
import 'package:lebenswiki_app/presentation/screens/menu/about_us.dart';
import 'package:lebenswiki_app/presentation/screens/menu/contact.dart';
import 'package:lebenswiki_app/presentation/screens/menu/created.dart';
import 'package:lebenswiki_app/presentation/screens/menu/profile.dart';
import 'package:lebenswiki_app/presentation/screens/menu/saved.dart';
import 'package:lebenswiki_app/presentation/screens/other/avatar_screen.dart';
import 'package:lebenswiki_app/presentation/screens/quizzer/quiz_main.dart';
import 'package:lebenswiki_app/presentation/screens/viewer/view_pack.dart';
import 'package:lebenswiki_app/presentation/screens/viewer/view_pack_started.dart';
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
  GoRouter router = createRouter(initRouteResults.$1);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://c30e1c85e3fcf934335f96d328f23ae0@o4506802868846592.ingest.sentry.io/4506802920226816';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ProviderScope(
          child: LebenswikiApp(
        user: initRouteResults.$2,
        categories: categories,
        router: router,
      )),
    ),
  );
}

Future<(String, User?)> getRoute() async {
  final TokenHandler tokenHandler = TokenHandler();

  if ((await PrefHandler.isBrowsingAnonymously())) {
    return ("/", null);
  }

  String? token = await tokenHandler.get();
  if (token == null || token == "") {
    return ("/register", null);
  }

  Either<CustomError, User> authResult =
      await UserApi().authenticate(token: token);
  if (authResult.isLeft) {
    return ("/login", null);
  }
  if (authResult.isRight) {
    return ("/", authResult.right);
  }
  return ("/login", null);
}

GoRouter createRouter(String? initialLocation) => GoRouter(
      initialLocation: initialLocation ?? "/",
      routes: [
        GoRoute(
          path: "/",
          builder: (context, state) => const NavBarWrapper(),
          routes: [
            GoRoute(
              path: "pack/overview/:id",
              builder: (context, state) => ViewPack(
                packId: int.parse(state.pathParameters["id"]!),
                heroName: "",
              ),
            ),
            GoRoute(
              path: "pack/:id",
              builder: (context, state) => PackViewerStarted(
                packId: int.parse(state.pathParameters["id"]!),
                heroName: "",
              ),
              routes: [
                GoRoute(
                    path: "quiz/:quizId",
                    builder: (context, state) =>
                        Quizzer(quizId: state.pathParameters["quizId"]!))
              ],
            ),
            GoRoute(
              path: "contact",
              builder: (context, state) => const ContactView(),
            ),
            GoRoute(
              path: "impressum",
              builder: (context, state) => const AboutUsView(),
            ),
            GoRoute(
              path: "saved",
              builder: (context, state) => const SavedView(),
            ),
            GoRoute(
              path: "created",
              builder: (context, state) => const CreatedView(),
              routes: [
                GoRoute(
                  path: "shorts",
                  builder: (context, state) =>
                      const CreatedView(startWithShorts: true),
                )
              ],
            ),
            GoRoute(
              path: "profile",
              builder: (context, state) => const ProfileView(),
            ),
            GoRoute(
              path: "avatar",
              builder: (context, state) => const AvatarScreen(),
            ),
            GoRoute(
              path: "create",
              builder: (context, state) => const CreatedView(),
              routes: [
                GoRoute(
                  path: "short",
                  builder: (context, state) => const ShortCreationView(),
                ),
                GoRoute(
                  path: "pack/pages",
                  builder: (context, state) {
                    Pack? pack = state.extra as Pack;
                    return Creator(pack: pack);
                  },
                ),
                GoRoute(
                  path: "pack",
                  builder: (context, state) {
                    Pack? pack = state.extra as Pack;
                    return CreatorPackInfo(pack: pack);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: "/login",
          builder: (context, state) => const AuthenticationView(),
        ),
        GoRoute(
          path: "/register",
          builder: (context, state) =>
              const AuthenticationView(startWithRegister: true),
        ),
      ],
    );

class LebenswikiApp extends ConsumerWidget {
  final User? user;
  final List<Category> categories;
  final GoRouter router;

  const LebenswikiApp({
    super.key,
    this.user,
    required this.router,
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Lebenswiki",
      theme: buildTheme(Brightness.light),
      routerConfig: router,
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
