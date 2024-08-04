import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ExpensesBalance extends StatefulWidget {
  late bool isexpenses;
  final Color activeColor;
  final Color inactiveColor;

  final Function? ontap1;
  final Function? ontap2;

  ExpensesBalance(
      {Key? key,
      required this.isexpenses,
      required this.activeColor,
      required this.inactiveColor,
      required this.ontap1,
      required this.ontap2})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpensesBalanceState createState() => _ExpensesBalanceState();
}

class _ExpensesBalanceState extends State<ExpensesBalance> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  widget.ontap1!();
                },
                child: Text(
                  "Expenses",
                  style: TextStyle(
                      fontSize: 26.sp,
                      color: widget.isexpenses
                          ? widget.activeColor
                          : widget.inactiveColor,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                height: 2.h,
                width: 170.w,
                color: widget.isexpenses
                    ? widget.activeColor
                    : widget.inactiveColor,
              )
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  widget.ontap2!();
                },
                child: Text(
                  "Income",
                  style: TextStyle(
                      fontSize: 26.sp,
                      color: !widget.isexpenses
                          ? widget.activeColor
                          : widget.inactiveColor,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                height: 2.h,
                width: 170.w,
                color: !widget.isexpenses
                    ? widget.activeColor
                    : widget.inactiveColor,
              )
            ],
          )
        ],
      ),
    );
  }
}
