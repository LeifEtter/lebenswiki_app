import 'package:go_router/go_router.dart';
import 'package:lebenswiki_app/domain/models/pack/pack.model.dart';
import 'package:lebenswiki_app/main_wrapper.dart';
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
                    if (state.extra != null) {
                      Pack? pack = state.extra as Pack;
                      return CreatorPackInfo(pack: pack);
                    } else {
                      return const CreatorPackInfo();
                    }
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
