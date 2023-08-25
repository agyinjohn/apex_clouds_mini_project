import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  const TextFieldInput(
      {required this.textEditingController,
      required this.textInputType,
      required this.hintText,
      this.isPass = false,
      super.key});
  final String? hintText;
  final bool isPass;
  final TextInputType textInputType;
  final TextEditingController textEditingController;

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: widget.textEditingController,
      decoration: InputDecoration(
        suffixIcon: widget.isPass? IconButton(onPressed: (){
          setState(() {
            isHidden =!isHidden;
          });
        }, icon: isHidden?  const Icon(Icons.visibility) : 
        const  Icon(Icons.visibility_off )): Container(width: 0,),
        hintText: widget.hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
      ),
      obscureText: widget.isPass? isHidden : false,
      keyboardType: widget.textInputType,
    );
  }
}
