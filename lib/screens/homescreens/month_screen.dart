import 'package:budgettracker/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class MonthScreen extends StatefulWidget {
  final String year;
  const MonthScreen({Key? key, required this.year}) : super(key: key);

  @override
  State<MonthScreen> createState() => _MonthScreenState();
}

class _MonthScreenState extends State<MonthScreen> {
  var currentMonth = DateFormat.yMMMM().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AllColors.secondaryColor,
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(AllFunction.currentUser!.email!)
              .collection("months")
              .doc(currentMonth)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              Get.snackbar("Error", "Month already exist");
              return;
            } else {
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(AllFunction.currentUser!.email!)
                  .collection("months")
                  .doc(currentMonth)
                  .set(
                      {"month": currentMonth, "year": AllFunction.currentyear});
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
                .doc(AllFunction.currentUser!.email!)
                .collection("months")
                .where('year', isEqualTo: widget.year)
                .orderBy("month", descending: true)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 40.h),
                    child: Text(
                      textAlign: TextAlign.center,
                      "No Months...!! Add A Month From Below Using the Add Button To \nGet Started.",
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
                                doc[index]["month"] ?? " no title",
                                textAlign: TextAlign.center,
                                style: AllTxt.midtxt,
                              ),
                              trailing: IconButton(
                                  iconSize: 25,
                                  onPressed: () {
                                    AllFunction.internetCheck()
                                        .then((intenet) async {
                                      if (intenet == true) {
                                        // Internet Present Case
                                        AllFunction.alertPopUp(
                                            context: context,
                                            ontap: () async {
                                              navigator!.pop();
                                              //delete munth
                                              AllFunction.doc
                                                  .collection("months")
                                                  .doc(doc[index].id)
                                                  .delete();

                                              // delete all transactions under this month
                                              //deletting Pending_orders after oder has been issued

                                              var snapshot = await AllFunction
                                                  .doc
                                                  .collection("allTransactions")
                                                  .where("month",
                                                      isEqualTo: doc[index]
                                                          ["month"])
                                                  .get();
                                              for (var doc in snapshot.docs) {
                                                await doc.reference.delete();
                                              }

                                              //update balance
                                              AllFunction.totalExpense = 0;
                                              AllFunction.totalInCome = 0;
                                              AllFunction.balance = 0;

                                              AllFunction.updateBalance(
                                                month: doc[index]["month"],
                                              );
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
                            Get.toNamed("/monthly-tra-screen",
                                arguments: [doc[index]["month"], widget.year]);
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
