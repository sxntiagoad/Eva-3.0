import 'package:eva/core/config/update_service.dart';
import 'package:eva/presentation/is_authenticated/screen/is_authenticated.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'EVA',
            home: Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ProviderScope(
            child: MaterialApp.router(
              routerConfig: appRouter,
              title: 'EVA',
              theme: AppTheme().getThemeData(),
              debugShowCheckedModeBanner: false,
            ),
          );
        }

        return const MaterialApp(
          title: 'EVA',
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}

class UpdaterWrapper extends StatefulWidget {
  final Widget child;
  
  const UpdaterWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<UpdaterWrapper> createState() => _UpdaterWrapperState();
}

class _UpdaterWrapperState extends State<UpdaterWrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        UpdateService.checkForUpdates(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}