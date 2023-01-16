import 'package:chess_tournament/src/frontend/common/base_input_field.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BaseInputIncrement extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int startValue;

  final ValueChanged<int> onChanged;

  int counter = 0;

  BaseInputIncrement({
    super.key,
    this.minValue = 1,
    this.maxValue = 10,
    this.startValue = 1,
    required this.onChanged,
  }) {
    counter = startValue;
  }

  @override
  State<BaseInputIncrement> createState() {
    return _BaseInputIncrementState();
  }
}

class _BaseInputIncrementState extends State<BaseInputIncrement> {
  TextEditingController incrementController = TextEditingController();
  TextEditingController gameTimeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 30.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(
              Icons.remove,
            ),
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.h),
            iconSize: 4.w,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (widget.counter > widget.minValue) {
                  widget.counter--;
                  incrementController.text = widget.counter.toString();
                }
                widget.onChanged(widget.counter);
              });
            },
          ),
          SizedBox(
            width: 13.w,
            // child: Text(
            //   '$counter',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 12.sp,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            //TODO: Should clamp value
            child: BaseInputField(
              numbersOnly: true,
              placeholderText: widget.startValue.toString(),
              validatorCallback: ((value) => {}),
              textFieldController: incrementController,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.h),
            iconSize: 4.w,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                if (widget.counter < widget.maxValue) {
                  widget.counter++;
                  incrementController.text = widget.counter.toString();
                }
                widget.onChanged(widget.counter);
              });
            },
          ),
        ],
      ),
    );
  }
}
