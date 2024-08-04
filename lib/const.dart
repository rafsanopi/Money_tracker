import 'package:budgettracker/screens/authscreens/auth_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopUpMessage {
  static deleteMsg() {
    return Get.snackbar(
      "Deleted",
      "Successfully deleted",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  static somethingWrong() {
    return Get.snackbar("Error", "Something went wrong",
        backgroundColor: const Color.fromARGB(
          255,
          173,
          70,
          63,
        ),
        duration: const Duration(seconds: 1),
        colorText: Colors.black);
  }
}

class AllColors {
  static const primaryColor = Color(0xFF101926);
  static const secondaryColor = Color.fromARGB(255, 153, 162, 170);
  static const thirdColor = Color.fromARGB(255, 107, 38, 226);
  static const expensesColor = Color.fromARGB(255, 156, 17, 7);
  static const incomeColor = Color.fromARGB(255, 5, 182, 79);
}

class AllTxt {
  static TextStyle largetxt = TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w900,
      color: AllColors.secondaryColor);
  static TextStyle midtxt = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w900,
      color: AllColors.secondaryColor);
  static TextStyle smalltxt = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      color: AllColors.secondaryColor);

  static TextStyle verySmalltxt = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      color: AllColors.secondaryColor);
  static TextStyle vverySmalltxt = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w700,
      color: AllColors.secondaryColor);
}

class BottomSheetsTxt {
  static TextStyle largetxt = TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.w900,
      color: AllColors.primaryColor);
  static TextStyle smalltxt = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: AllColors.primaryColor);
}

class AllFunction {
  static User? currentUser = FirebaseAuth.instance.currentUser;

  static String currentyear = DateFormat('yyyy').format(DateTime.now());
  static var doc =
      FirebaseFirestore.instance.collection("user").doc(currentUser!.email);

  static int totalExpense = 0;
  static int totalInCome = 0;
  static int balance = 0;

  static Future<bool> signInWithGoogle() async {
    bool login = false;

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        login = true;
      }
    } on FirebaseAuthException {
      AllFunction.snakbarMsg("error", "Something went wrong", Colors.red);
      login = false;
    }
    return login;
  }

  static snakbarMsg(String error, String message, Color backgroundColor) {
    Get.snackbar(
      error, message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      // animationDuration: const Duration(seconds: 7),
    );
  }

  static Future<bool> internetCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static getExpense({required String month, required String year}) async {
    // Sum the count of each shard in the subcollection
    int count = 0;
    totalExpense = 0;

    final shards = await doc
        .collection("allTransactions")
        .where("isExpenses", isEqualTo: true)
        .where("year", isEqualTo: year)
        .where("month", isEqualTo: month)
        .get();

    for (var doc in shards.docs) {
      count += doc.data()['amount'] as int;
      totalExpense = count;
    }

    return count;
  }

  static getIncome({required String month, required String year}) async {
    // Sum the count of each shard in the subcollection
    int count = 0;
    totalInCome = 0;
    final shards = await FirebaseFirestore.instance
        .collection("user")
        .doc(currentUser!.email)
        .collection("allTransactions")
        .where("isExpenses", isEqualTo: false)
        .where("year", isEqualTo: year)
        .where("month", isEqualTo: month)
        .get();

    for (var doc in shards.docs) {
      count += doc.data()['amount'] as int;
      totalInCome = count;
    }

    return count;
  }

  static getBalance() {
    balance = totalInCome - totalExpense;
  }

  static updateBalance({required String month, year}) {
    doc.collection("balance").doc(month).set({
      "year": year,
      "month": month,
      "balance": AllFunction.balance,
      "expense": AllFunction.totalExpense,
      "income": AllFunction.totalInCome
    });
  }

  static alertPopUp({required BuildContext context, required Function? ontap}) {
    return Alert(
      context: context,
      style: AlertStyle(
          backgroundColor: AllColors.thirdColor,
          titleStyle: AllTxt.smalltxt,
          descStyle: AllTxt.smalltxt),
      type: AlertType.error,
      title: "Delete?",
      desc: "Are you sure?",
      buttons: [
        DialogButton(
          onPressed: () {
            ontap!();
          },
          gradient: const LinearGradient(
              colors: [AllColors.expensesColor, AllColors.thirdColor]),
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        DialogButton(
          onPressed: () => Navigator.pop(context),
          gradient: const LinearGradient(
              colors: [AllColors.incomeColor, AllColors.thirdColor]),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }
}

class CurrentUser extends StatelessWidget {
  const CurrentUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Money Tracker",
          style: AllTxt.largetxt,
        ),
        InkWell(
          onTap: () {
            Information.userinfo(context);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 46.w,
              imageUrl: AllFunction.currentUser!.photoURL.toString(),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ],
    );
  }
}

class Information {
  static userinfo(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Alert(
        //   style: AlertStyle(backgroundColor: AllColors.primaryColor),
        context: context,
        content: SizedBox(
          height: height / 4,
          width: width / 1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  width: 56.w,
                  imageUrl: AllFunction.currentUser!.photoURL.toString(),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Text(
                AllFunction.currentUser!.email.toString(),
                style: AllTxt.verySmalltxt,
              ),
              Text(
                AllFunction.currentUser!.displayName.toString(),
                style: AllTxt.verySmalltxt,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        GoogleSignIn().signOut();
                        FirebaseAuth.instance.signOut();
                        Get.off(() => const Authscreen());
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: AllColors.thirdColor,
                      ),
                      label: Text(
                        "Log out",
                        style: AllTxt.verySmalltxt,
                      )),
                  Text(
                    "V-4.9.35",
                    style: AllTxt.verySmalltxt,
                  ),
                ],
              )
            ],
          ),
        ),
        buttons: []).show();
  }
}
