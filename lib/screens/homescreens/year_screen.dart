// ignore: file_names
import 'package:budgettracker/const.dart';
import 'package:budgettracker/screens/homescreens/month_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages

class YearScreen extends StatelessWidget {
  const YearScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AllColors.secondaryColor,
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(AllFunction.currentUser!.email!)
              .collection("years")
              .doc(AllFunction.currentyear)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              Get.snackbar("Error", "Year already exist");
              return;
            } else {
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(AllFunction.currentUser!.email!)
                  .collection("years")
                  .doc(AllFunction.currentyear)
                  .set({
                "year": AllFunction.currentyear,
              });
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: AllColors.primaryColor,
        ),
      ),
      backgroundColor: AllColors.primaryColor,
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          const CurrentUser(),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("user")
                .doc(AllFunction.currentUser!.email)
                .collection("years")
                .orderBy("year", descending: true)
                .snapshots(),
            builder: (ctx,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Something went wrong',
                    style: AllTxt.largetxt,
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text(
                    "Loading",
                    style: AllTxt.largetxt,
                  ),
                );
              }
              // Perform a null check on snapshot.data

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 40.h),
                    child: Text(
                      "Click below button to get started",
                      style: AllTxt.midtxt,
                    ),
                  ),
                );
              }

              var doc = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                    itemCount: doc.length,
                    itemBuilder: (ctx, index) => InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            height: 60.h,
                            margin: EdgeInsets.only(
                                bottom: 10.h, left: 15.w, right: 15.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AllColors.thirdColor,
                            ),
                            child: ListTile(
                              title: Text(
                                doc[index]["year"] ?? " no year",
                                textAlign: TextAlign.center,
                                style: AllTxt.midtxt,
                              ),
                              trailing: IconButton(
                                  iconSize: 25,
                                  onPressed: () {
                                    AllFunction.internetCheck()
                                        .then((intenet) async {
                                      if (intenet == true) {
                                        AllFunction.alertPopUp(
                                            context: context,
                                            ontap: () async {
                                              navigator!.pop();
                                              //delete year
                                              AllFunction.doc
                                                  .collection("years")
                                                  .doc(doc[index].id)
                                                  .delete();

                                              // delete all date under this year
                                              var monthSnapshot =
                                                  await AllFunction.doc
                                                      .collection("months")
                                                      .where("year",
                                                          isEqualTo: doc[index]
                                                              ["year"])
                                                      .get();
                                              for (var doc
                                                  in monthSnapshot.docs) {
                                                await doc.reference.delete();
                                              }
                                              // delete all transactions under this month

                                              var transactionSnapshot =
                                                  await AllFunction.doc
                                                      .collection(
                                                          "allTransactions")
                                                      .where("year",
                                                          isEqualTo: doc[index]
                                                              ["year"])
                                                      .get();
                                              for (var doc
                                                  in transactionSnapshot.docs) {
                                                await doc.reference.delete();
                                              }

                                              // delete all balance under this year

                                              var balanceSnapshot =
                                                  await AllFunction.doc
                                                      .collection("balance")
                                                      .where("year",
                                                          isEqualTo: doc[index]
                                                              ["year"])
                                                      .get();
                                              for (var doc
                                                  in balanceSnapshot.docs) {
                                                await doc.reference.delete();
                                              }
                                              PopUpMessage.deleteMsg();
                                            });
                                      } else {
                                        // No-Internet Case
                                        AllFunction.snakbarMsg("No internet?",
                                            "Connect to network", Colors.red);
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ),
                          ),
                          onTap: () {
                            Get.to(() => MonthScreen(
                                  year: doc[index]["year"],
                                ));
                            print(doc[index]["year"]);
                          },
                        )),
              );
            },
          )
        ],
      ),
    );
  }
}
