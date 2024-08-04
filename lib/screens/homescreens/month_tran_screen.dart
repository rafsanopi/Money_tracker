import 'package:budgettracker/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../monthly_tra_widgets/chart.dart';
import '../../monthly_tra_widgets/expanses_balance_button.dart';
import '../../monthly_tra_widgets/transaction_bottomsheet.dart';
import '../../monthly_tra_widgets/transactions_eb_stream.dart';

class MonthlyTransActionsScreen extends StatefulWidget {
  const MonthlyTransActionsScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyTransActionsScreen> createState() =>
      _MonthlyTransActionsScreenState();
}

class _MonthlyTransActionsScreenState extends State<MonthlyTransActionsScreen> {
  late bool isexpenses = true;

  Color activeColor = AllColors.thirdColor;
  Color inactiveColor = AllColors.secondaryColor;

  String month = Get.arguments[0];
  String year = Get.arguments[1];

  @override
  void initState() {
    super.initState();
    AllFunction.getExpense(month: month, year: year);
    AllFunction.getIncome(month: month, year: year);
    AllFunction.getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            foregroundColor: AllColors.thirdColor,
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: AllColors.primaryColor,
                context: context,
                builder: (context) => Transactionbottomsheet(
                    isExpense: isexpenses, month: month, year: year),
              );
            },
            backgroundColor: AllColors.secondaryColor,
            child: const Icon(Icons.add)),
        backgroundColor: AllColors.primaryColor,
        body: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            const CurrentUser(),
            SizedBox(
              height: 6.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "It's $month",
                  style: AllTxt.midtxt,
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),

            Chart(month: month),

            ExpensesBalance(
              isexpenses: isexpenses,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              ontap1: () {
                if (isexpenses) {
                  setState(() {
                    isexpenses = true;
                  });
                } else {
                  setState(() {
                    isexpenses = !isexpenses;
                  });
                }
              },
              ontap2: () {
                if (!isexpenses) {
                  setState(() {
                    isexpenses = false;
                  });
                } else if (isexpenses) {
                  setState(() {
                    isexpenses = !isexpenses;
                  });
                }
              },
            ),
            // transaction list
            TransactionsStream(
              isExpense: isexpenses,
              month: month,
              year: year,
            )
          ],
        ));
  }
}
