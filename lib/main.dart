import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web_fun/core/routes.dart';

import 'bl/providers/auth_provider.dart';
import 'bl/providers/orders_provider.dart';
import 'bl/providers/products_provider.dart';
import 'core/theme/custom_theme.dart';
import 'view/home_page.dart';
import 'view/orders_page.dart';
import 'view/products_page.dart';

Future<void> main() async {
  await _init();
  runApp(const MyApp());
}

Future<void> _init() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (ctx) => OrdersProvider(),
          update: (ctx, authProvider, prevProvider) => prevProvider!..update(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (ctx) => ProductsProvider(),
          update: (ctx, authProvider, prevProvider) => prevProvider!..update(),
        ),
        // ChangeNotifierProvider(
        //   create: (_) => AuthorProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (_) => CommentsProvider(),
        // ),
      ],
      child: MaterialApp.router(
        builder: BotToastInit(),
        // navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        // onGenerateRoute: NavigationRoute.instance.generateRoute,
        theme: CustomTheme.lightTheme,
        supportedLocales: const [Locale('en', 'US')],
        // home: Selector<AuthProvider, AuthStatus>(
        //   selector: (BuildContext context, AuthProvider authProvider) =>
        //       authProvider.authStatus,
        //   builder: (context, AuthStatus authStatus, child) {
        //     return authStatus != AuthStatus.loggedIn
        //         ? const HomePage()
        //         : const HomePage();
        //   },
        // ),
        routeInformationParser: VxInformationParser(),
        routerDelegate: VxNavigator(routes: {
          Routes.homeRoute: (_, __) => const MaterialPage(child: HomePage()),
          Routes.ordersRoute: (_, __) =>
              const MaterialPage(child: OrdersPage()),
          Routes.productsRoute: (_, __) =>
              const MaterialPage(child: ProductsPage())
        }),
      ),
    );
  }
}
