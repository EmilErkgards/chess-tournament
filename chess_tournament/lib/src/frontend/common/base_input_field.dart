import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseInputField extends StatefulWidget {
  final bool numbersOnly;
  final String placeholderText;
  final Function(String) validatorCallback;
  final TextEditingController? textFieldController;
  final bool valueVisible;
  final Function(String)? callbackOnChanged;

  const BaseInputField({
    super.key,
    required this.numbersOnly,
    required this.placeholderText,
    required this.validatorCallback,
    required this.textFieldController,
    this.valueVisible = true,
    this.callbackOnChanged = null,
  });

  @override
  State<BaseInputField> createState() => _BaseInputFieldState();
}

class _BaseInputFieldState extends State<BaseInputField> {
  double height = 50;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        height: height,
        child: TextFormField(
          obscureText: !widget.valueVisible,
          inputFormatters: [
            if (widget.numbersOnly) ...{
              FilteringTextInputFormatter.digitsOnly,
            }
          ],
          keyboardType: TextInputType.number,
          validator: validator,
          textAlign: TextAlign.center,
          onChanged: widget.callbackOnChanged,
          controller: widget.textFieldController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: widget.placeholderText,
          ),
        ),
      ),
    );
  }

  String? validator(string) {
    var validatorResult = widget.validatorCallback(string);
    if (validatorResult != null) {
      setState(() {
        height = 80;
      });
      return validatorResult;
    } else {
      setState(() {
        height = 50;
      });
      return null;
    }
  }
}
