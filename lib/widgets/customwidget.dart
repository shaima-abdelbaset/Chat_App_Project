import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget{
  CustomFormTextField ({this.hinttxt,this.onChanged,this.obsecur=false});
  String?hinttxt;
  bool? obsecur;
 Function(String)?onChanged;
  @override
  Widget build (BuildContext context){
    return TextFormField(
      obscureText: obsecur!,
      validator:(data) {
        if(data!.isEmpty)
          {
            return 'field is required';
          }
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hinttxt,
        hintStyle:TextStyle(
          color: Colors.white,
        ) ,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color:Colors.white,
          ),
        ),
      ),
    );
  }
}