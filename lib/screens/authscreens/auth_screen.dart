import 'package:budgettracker/const.dart';
import 'package:budgettracker/screens/homescreens/year_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({Key? key}) : super(key: key);

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Widget logincontainers(String img, Function? ontap) {
      return InkWell(
        onTap: () {
          ontap!();
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.h,
          width: 200.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AllColors.primaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Google Auth",
                style: TextStyle(
                    fontSize: 15 + (width / 40),
                    fontWeight: FontWeight.w900,
                    color: AllColors.secondaryColor),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0.h),
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: AllColors.primaryColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Money Tracker",
                style: AllTxt.largetxt,
              ),
              SizedBox(
                height: 20.h,
              ),
              LottieBuilder.asset(
                "assets/animations/money-light.zip",
                fit: BoxFit.fitHeight,
                height: 300.h,
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      "Track Money, Save Money\nYour Path to Financial Success!",
                      style: TextStyle(
                          fontSize: 15 + (width / 40),
                          fontWeight: FontWeight.w900,
                          color: AllColors.secondaryColor),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 45.h,
                    width: 110.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AllColors.thirdColor),
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: AllTxt.midtxt,
                      ),
                    ),
                  ),
                  logincontainers("assets/img/google.png", () async {
                    AllFunction.internetCheck().then((intenet) async {
                      if (intenet == true) {
                        // Internet Present Case

                        bool login = await AllFunction.signInWithGoogle();
                        if (login == true) {
                          Get.off(() => const YearScreen());
                        }
                      } else {
                        // No-Internet Case
                        AllFunction.snakbarMsg(
                            "No internet?", "Connect to network", Colors.red);
                      }
                    });
                  }),
                ],
              ),
            ],
          ),
        ));
  }
}
