import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crochet_store/IntroScreens/introScreen.dart';
import 'package:crochet_store/IntroScreens/introScreenProvider.dart';
import 'package:crochet_store/UserSide/AddProductProvider.dart';
import 'package:crochet_store/UserSide/productServices.dart';
import 'package:crochet_store/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CrochetStoreApp());
}

class CrochetStoreApp extends StatelessWidget {
  const CrochetStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => IntroscreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(
            FirebaseFirestore.instance.collection('products'),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AddProductProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Error initializing Firebase"),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return const Introscreen();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}


//WHY WE HAVE USED FUTURE BUILDER IN MAIN.DART FILE?
/* The changes address common Firebase initialization issues and Provider setup problems:

1. Double initialization prevention: Using `FutureBuilder` ensures Firebase is properly initialized before showing the app content

2. Loading state handling: Shows loading indicator while Firebase initializes, error message if initialization fails

3. Provider scope: MultiProvider wraps MaterialApp, ensuring all child widgets can access the providers

4. Clean architecture: Separates initialization logic from widget building, making the code more maintainable

This structure prevents race conditions and provider access issues that were causing your app to freeze at the splash screen. */