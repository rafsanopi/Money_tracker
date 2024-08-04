import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../const.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Transactionbottomsheet extends StatefulWidget {
  final bool isExpense;
  final String month;
  final String year;

  const Transactionbottomsheet(
      {Key? key,
      required this.isExpense,
      required this.month,
      required this.year})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TransactionbottomsheetState createState() => _TransactionbottomsheetState();
}

class _TransactionbottomsheetState extends State<Transactionbottomsheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ammountController = TextEditingController();
  var currentMonth = DateFormat.yMMMM().format(DateTime.now());

  addTransaction() {
    AllFunction.doc.collection("allTransactions").add({
      "title": _titleController.text,
      "amount": int.parse(_ammountController.text),
      "date": DateFormat.yMMMMd('en_US').format(_selectedDate!),
      "isExpenses": widget.isExpense,
      "month": currentMonth,
      "year": widget.year
    });
    AllFunction.snakbarMsg(
        "Done", "Successfully Data Added", AllColors.thirdColor);

    navigator!.pop(context);
  }

  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.h),
            child: Text(
              widget.isExpense ? "Add Expense" : "Add Income",
              style: AllTxt.midtxt,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 150.w,
                padding: EdgeInsets.all(2.w),
                margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle: AllTxt.smalltxt,
                    hintText: "Title",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  style: BottomSheetsTxt.smalltxt,
                  cursorColor: Colors.black,
                ),
              ),
              Container(
                width: 150.w,
                padding: EdgeInsets.all(2.w),
                margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 2.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                child: TextFormField(
                  controller: _ammountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle: AllTxt.smalltxt,
                    hintText: "Ammount",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  style: BottomSheetsTxt.smalltxt,
                  cursorColor: Colors.black,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2030))
                        .then((date) {
                      if (date == null) {
                        return;
                      }
                      setState(() {
                        _selectedDate = date;
                      });
                    });
                  },
                  child: Text(
                    "Choose Date",
                    style:
                        TextStyle(color: AllColors.thirdColor, fontSize: 16.sp),
                  )),
              Text(
                _selectedDate == null
                    ? "No Date Choosen"
                    : DateFormat.yMMMMd('en_US').format(_selectedDate!),
                style: AllTxt.verySmalltxt,
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              if (_titleController.text.isEmpty ||
                  _ammountController.text.isEmpty ||
                  _selectedDate == null) {
                AllFunction.snakbarMsg("Error", "Please input all information",
                    const Color.fromARGB(255, 238, 2, 2));
              } else {
                addTransaction();
                await AllFunction.getExpense(
                    month: widget.month, year: widget.year);
                await AllFunction.getIncome(
                    month: widget.month, year: widget.year);
                await AllFunction.getBalance();
                AllFunction.updateBalance(
                    month: widget.month, year: widget.year);
              }
            },
            child: Container(
              height: 50.h,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.h),
                  color: AllColors.thirdColor),
              child: Text(
                "Add Transaction",
                style: AllTxt.verySmalltxt,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
