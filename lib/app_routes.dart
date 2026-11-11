import 'package:flutter/material.dart';
import 'data/models/enums.dart';
import 'data/models/seizure_library_entry.dart';
import 'data/repositories/example_cases.dart';
import 'data/repositories/seizure_library_data.dart';
import 'domain/scoring/seizure_scoring_engine.dart';
import 'features/about/about_screen.dart';
import 'features/assessment/assessment_wizard_screen.dart';
import 'features/assessment/result/result_screen.dart';
import 'features/home/home_screen.dart';
import 'features/library/library_detail_screen.dart';
import 'features/library/library_screen.dart';
import 'features/localization/localization_screen.dart';
import 'features/pearls/pearls_screen.dart';
import 'features/search/search_screen.dart';

/// URL routes. With the path URL strategy every screen has a shareable,
/// indexable address, e.g. compass.thetract.org/atlas/juvenile-myoclonic-epilepsy.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const assess = '/assess';
  static const localization = '/localization';
  static const atlas = '/atlas';
  static const history = '/history';
  static const figures = '/figures';
  static const pearls = '/pearls';
  static const search = '/search';
  static const about = '/about';
  static const example = '/example';

  static String exampleFor(ExampleCase c) => '$example/${c.id}';

  static String slug(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r"[’'()]"), '')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');

  static String atlasEntry(SeizureLibraryEntry e) => '$atlas/${slug(e.name)}';
  static String localizationFor(LocalizationRegion r) => '$localization/${r.name}';

  /// Builds the back stack for a deep link (e.g. /atlas/x → home, atlas,
  /// entry), ignoring the trailing slash the static hosting adds.
  static List<Route<dynamic>> initialRoutes(String initial) {
    final parts = initial.split('/').where((p) => p.isNotEmpty).toList();
    final routes = <Route<dynamic>>[onGenerateRoute(const RouteSettings(name: home))];
    if (parts.isEmpty) return routes;
    if (parts.length > 1 && parts.first == 'atlas') routes.add(onGenerateRoute(const RouteSettings(name: atlas)));
    routes.add(onGenerateRoute(RouteSettings(name: '/${parts.join('/')}')));
    return routes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? home);
    final seg = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    Widget page;
    var name = settings.name ?? home;
    switch (seg.isEmpty ? '' : seg.first) {
      case 'assess':
        page = const AssessmentWizardScreen();
      case 'localization':
        final region = seg.length > 1
            ? LocalizationRegion.values.where((r) => r.name == seg[1]).firstOrNull
            : null;
        page = LocalizationScreen(initialRegion: region);
      case 'atlas':
        final entry = seg.length > 1 ? seizureLibrary.where((e) => slug(e.name) == seg[1]).firstOrNull : null;
        page = entry == null ? const LibraryScreen() : LibraryDetailScreen(entry: entry);
        if (entry == null) name = atlas;
      case 'history':
        page = const LibraryScreen(initialTabIndex: 1);
      case 'figures':
        page = const LibraryScreen(initialTabIndex: 2);
      case 'pearls':
        page = const PearlsScreen();
      case 'search':
        page = const SearchScreen();
      case 'about':
        page = const AboutScreen();
      case 'example':
        final ex = seg.length > 1 ? exampleCases.where((c) => c.id == seg[1]).firstOrNull : null;
        if (ex == null) {
          page = const HomeScreen();
          name = home;
        } else {
          page = ResultScreen(result: const SeizureScoringEngine().score(ex.build()), example: ex);
        }
      default:
        page = const HomeScreen();
        name = home;
    }
    return _SettleRoute(page: page, settings: RouteSettings(name: name, arguments: settings.arguments));
  }
}

/// Screen change: the new screen fades in while rising and growing a touch
/// into place; the old one dims slightly behind it. Instant when the
/// platform asks for reduced motion.
class _SettleRoute extends PageRouteBuilder<dynamic> {
  _SettleRoute({required Widget page, required RouteSettings settings})
      : super(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 340),
          reverseTransitionDuration: const Duration(milliseconds: 240),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return child;
            final enter = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
            final leave = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut);
            return FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0.55).animate(leave),
              child: FadeTransition(
                opacity: enter,
                child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 0.035), end: Offset.zero).animate(enter),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.975, end: 1).animate(enter),
                    child: child,
                  ),
                ),
              ),
            );
          },
        );
}
