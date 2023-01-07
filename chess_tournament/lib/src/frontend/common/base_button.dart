import 'package:flutter/material.dart';

class BaseButton extends StatefulWidget {
  final callback;
  final String text;
  const BaseButton({super.key, required this.callback, required this.text});

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          onPressed: widget.callback,
          child: Text(widget.text),
        ),
      ),
    );
  }
}
