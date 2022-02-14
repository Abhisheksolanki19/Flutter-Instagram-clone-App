import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_app/providers/user_provider.dart';
import 'package:flutter_instagram_app/responsive/mobile_screen_layout.dart';
import 'package:flutter_instagram_app/responsive/responsive_layout_screen.dart';
import 'package:flutter_instagram_app/responsive/web_screen_layout.dart';
import 'package:flutter_instagram_app/screens/login_screen.dart';
import 'package:flutter_instagram_app/utils/colors.dart';
import 'package:flutter_instagram_app/utils/my_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAjjqpkYCO_ZzkXID4OpRgUL4s4XkXhPgA",
          appId: "1:836239946911:web:e90f16959fd98d0b0cdeaa",
          messagingSenderId: "836239946911",
          projectId: "flutter-instagram-clone-d402d",
          storageBucket: "flutter-instagram-clone-d402d.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider())
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Instagram Clone',
            themeMode: themeProvider.themeMode,
            theme: MyTheme.lightTheme(),
            darkTheme: MyTheme.darkTheme(),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                        webScreenLayout: WebSreenLayout(),
                        mobileScreenLayout: MobileScreenLayout());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }

                return const LoginScreen();
              },
            ));
      },
    );
  }
}
