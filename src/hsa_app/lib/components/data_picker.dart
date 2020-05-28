import 'package:flutter/material.dart';
import 'package:hsa_app/page/dialog/custom_dialog.dart';

typedef DataPickerOnConfirmCallback(num item);


void showNumberPicker(BuildContext context,DataPickerOnConfirmCallback onConfirm,{String title,int current,int max,int decimal,bool isShow,String type}){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title:title,
      current :current,
      max:max,
      decimal:decimal,
      isShow:isShow,
      type:type,
      onChanged: (value){
        if(onConfirm != null) onConfirm(value);
      },
    ),
  );
}




