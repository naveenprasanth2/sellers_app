import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final IconData? iconData;
  final String? hintText;
  final bool? isObscure;
  final bool? isEnabled;

  const CustomTextField(
      {super.key,
      required this.textEditingController,
      required this.iconData,
      required this.hintText,
      this.isObscure = false,
      this.isEnabled = true});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: widget.isEnabled,
        controller: widget.textEditingController,
        obscureText: widget.isObscure!,
        cursorColor:Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
              widget.iconData,
            color: Colors.purpleAccent,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: widget.hintText,

        ),
      ),
    );
  }
}
