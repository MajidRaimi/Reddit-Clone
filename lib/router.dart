import 'package:routemaster/routemaster.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/login_screen.dart';

// loggedOut route

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      )
});



// loggedIn route