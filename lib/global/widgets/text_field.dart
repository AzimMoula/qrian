import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.isObscured = false,
      this.keyboard = TextInputType.text,
      this.isLast = false,
      this.hintText = ''});
  final TextEditingController controller;
  final TextInputType keyboard;
  final bool isObscured;
  final bool isLast;
  final String hintText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscured;
  @override
  void initState() {
    obscured = widget.isObscured ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.maxFinite,
      child: TextFormField(
        style: const TextStyle(color: Colors.black),
        controller: widget.controller,
        obscureText: obscured,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        keyboardType: widget.keyboard,
        textInputAction:
            !widget.isLast ? TextInputAction.next : TextInputAction.done,
        decoration: InputDecoration(
          suffixIcon: widget.isObscured
              ? IconButton(
                  tooltip: obscured ? 'Show Password' : 'Hide Password',
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    setState(
                      () => obscured = !obscured,
                    );
                  },
                  icon: Icon(
                    obscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    // color: const Color.fromARGB(255, 156, 200, 179),
                    color: const Color.fromARGB(255, 136, 172, 202),
                  ),
                )
              : null,
          filled: true,
          // fillColor: Colors.green.shade50,
          fillColor: Colors.blue.shade50,
          label: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              widget.hintText,
              // style: TextStyle(color: Colors.green.shade200),
              style: TextStyle(color: Colors.blue.shade200),
            ),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              // borderSide: BorderSide(color: Colors.green.shade200)),
              borderSide: BorderSide(color: Colors.blue.shade200)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              // borderSide: BorderSide(color: Colors.lightGreen.shade100)),
              borderSide: BorderSide(color: Colors.lightBlue.shade100)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              // borderSide: BorderSide(color: Colors.green.shade300)),
              borderSide: BorderSide(color: Colors.blue.shade300)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
        ),
      ),
    );
  }
}
