import 'package:flutter/material.dart';
//import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';
import 'package:hsa_app/page/dialog/custom_dialog.dart';

typedef DataPickerOnConfirmCallback(num item);

// void showDataPicker(BuildContext context,String title,List<String> datas,DataPickerOnConfirmCallback onConfirm) {
//        final bool showTitleActions = true;
//        DataPicker.showDatePicker(context,
//          showTitleActions: showTitleActions,
//          locale: 'zh',
//          datas: datas ?? [],
//          title: title ??'',
//          onConfirm:(data){
//            if(onConfirm != null) onConfirm(data);
//          }, 
//        );
//   }

void showNumberPicker(BuildContext context,DataPickerOnConfirmCallback onConfirm,{String title,int current,int max,int decimal}){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => CustomDialog(
      title:title,
      current :current,
      max:max,
      decimal:decimal,
      onChanged: (value){
        if(onConfirm != null) onConfirm(value);
      },
    )
    );
}




