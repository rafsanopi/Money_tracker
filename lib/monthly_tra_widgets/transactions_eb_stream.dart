import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../const.dart';

// ignore: must_be_immutable
class TransactionsStream extends StatefulWidget {
  final String month;
  final String year;

  bool isExpense;
  TransactionsStream(
      {Key? key,
      required this.isExpense,
      required this.month,
      required this.year})
      : super(key: key);

  @override
  State<TransactionsStream> createState() => _TransactionsStreamState();
}

class _TransactionsStreamState extends State<TransactionsStream> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(AllFunction.currentUser!.email)
            .collection("allTransactions")
            .where("year", isEqualTo: widget.year)
            .where("month", isEqualTo: widget.month)
            .where("isExpenses", isEqualTo: widget.isExpense ? true : false)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong Or Add Data',
                style: AllTxt.smalltxt,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Text(
              "Loading",
              style: AllTxt.smalltxt,
            ));
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Transactions",
                style: AllTxt.smalltxt,
              ),
            );
          }
          var data = snapshot.data!.docs;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10.h, left: 10.h, right: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.h),
                  color: AllColors.thirdColor,
                ),
                child: ListTile(
                    leading: Container(
                      alignment: Alignment.center,
                      width: 120.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.w),
                          color: AllColors.primaryColor),
                      child: Text(
                        "${data[index]["amount"]} Tk",
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: widget.isExpense
                                ? AllColors.expensesColor
                                : AllColors.incomeColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Text(
                      data[index]["title"] ?? " no title",
                      style: AllTxt.smalltxt,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      data[index]["date"] ?? " no date",
                      style: AllTxt.vverySmalltxt,
                      textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                        iconSize: 23.h,
                        onPressed: () {
                          AllFunction.internetCheck().then((intenet) async {
                            if (intenet == true) {
                              // Internet Present Case

                              AllFunction.alertPopUp(
                                  context: context,
                                  ontap: () {
                                    //delete transaction
                                    AllFunction.doc
                                        .collection("allTransactions")
                                        .doc(data[index].id)
                                        .delete()
                                        .then((value) async {
                                      //
                                      //update balance

                                      await AllFunction.getExpense(
                                          month: widget.month,
                                          year: widget.year);
                                      await AllFunction.getIncome(
                                          month: widget.month,
                                          year: widget.year);
                                      await AllFunction.getBalance();
                                      AllFunction.updateBalance(
                                          month: widget.month,
                                          year: widget.year);
                                    });

                                    navigator!.pop();
                                  });
                            } else {
                              // No-Internet Case
                              AllFunction.snakbarMsg("No internet?",
                                  "Connect to network", Colors.red);
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: AllColors.primaryColor,
                        ))),
              );
            },
          );
        },
      ),
    );
  }
}
