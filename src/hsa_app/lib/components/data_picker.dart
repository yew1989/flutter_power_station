import 'package:flutter/material.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';

typedef DataPickerOnConfirmCallback(String item);

void showDataPicker(BuildContext context,String title,List<String> datas,DataPickerOnConfirmCallback onConfirm) {
       final bool showTitleActions = true;
       DataPicker.showDatePicker(context,
         showTitleActions: showTitleActions,
         locale: 'zh',
         datas: datas ?? [],
         title: title ??'',
         onConfirm:(data){
           if(onConfirm != null) onConfirm(data);
         }, 
       );
  }