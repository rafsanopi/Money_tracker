import 'package:budgettracker/screens/homescreens/year_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'screens/authscreens/auth_screen.dart';
import 'screens/homescreens/month_tran_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ScreenUtil.ensureScreenSize();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          "/monthly-tra-screen": (_) => const MonthlyTransActionsScreen()
        },
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return const Authscreen();
              }
              return const YearScreen();
            }));
  }
}



// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       routes: {"/monthly-tra-screen": (_) => const MonthlyTransActionsScreen()},
//       home: ScreenUtilInit(
//         builder: (context, child) {
//           return StreamBuilder(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: (ctx, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Authscreen();
//                 }
//                 return const YearScreen();
//               });
//         },
//       ),
//     );
//   }
// }
