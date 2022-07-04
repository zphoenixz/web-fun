import 'package:flutter/material.dart';
import 'package:morphing_text/morphing_text.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../bl/providers/auth_provider.dart';
import '../core/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).login();
    });

    load(context);
    return Container(
      color: Colors.white,
      child: Center(
        child: EvaporateMorphingText(
          texts: List.from([
            "Hi I am the homepage XD, I have no use atm,",
            " so in a bit you will be redirected just wait :D "
          ]),
          speed: const Duration(seconds: 1),
          loopForever: true,
          onComplete: () {},
          yDisplacement: 1.2, // To factor of y-displacement
          textStyle: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }

  load(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4));
    await context.vxNav.push(Uri.parse(Routes.productsRoute));
  }
}
