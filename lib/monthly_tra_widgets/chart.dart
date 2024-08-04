import 'package:budgettracker/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class Chart extends StatefulWidget {
  final String month;
  const Chart({Key? key, required this.month}) : super(key: key);

  @override
  State<Chart> createState() => ChartState();
}

class ChartState extends State<Chart> {
  Widget myColumn({
    required String balance,
    required String income,
    required String expense,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Balance",
          style: AllTxt.largetxt,
        ),
        Text(
          balance,
          style: AllTxt.largetxt,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: AllColors.incomeColor,
                  size: 30.h,
                ),
                Column(
                  children: [
                    Text(
                      "Income",
                      style: AllTxt.verySmalltxt,
                    ),
                    Text(
                      income,
                      style: AllTxt.verySmalltxt,
                    )
                  ],
                )
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: AllColors.expensesColor,
                  size: 30.h,
                ),
                Column(
                  children: [
                    Text(
                      "Expense",
                      style: AllTxt.verySmalltxt,
                    ),
                    Text(
                      expense,
                      style: AllTxt.verySmalltxt,
                    )
                  ],
                )
              ],
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 25.h),
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AllColors.primaryColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 33, 52, 82),
                offset: Offset(4, 4),
                blurRadius: 10,
                spreadRadius: 1),
            BoxShadow(
              color: Color.fromARGB(255, 29, 44, 68),
              offset: Offset(-4, -4),
              blurRadius: 10,
              spreadRadius: 1,
            ), // BoxShadow
          ], // BoxShadow
        ),
        child: StreamBuilder(
          stream: AllFunction.doc
              .collection("balance")
              .doc(widget.month)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Loading"));
            }
            // Use the null-aware operator (?) here to handle the case when data is null
            Map<String, dynamic>? data =
                snapshot.data?.data() as Map<String, dynamic>?;

            // Use the null-aware operator (??) to provide a default value for the map
            data ??= {
              "balance": "0",
              "income": "0",
              "expense": "0",
            };

            return myColumn(
              balance: data["balance"].toString(),
              income: data["income"].toString(),
              expense: data["expense"].toString(),
            );
          },
        )); // BoxDecoration
// Container
  }
}
