import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hsa_app/components/public_tool.dart';
import 'package:hsa_app/util/number_picker.dart';

class CustomDialog  extends Dialog {

  final String title;
  final int current;
  final int max;
  final int decimal;
  final bool isShow;
  final String type;
  final ValueChanged<num> onChanged;

  static num _change = 0.0;

  CustomDialog({
    this.title,
    this.current,
    this.max,
    this.decimal,
    this.isShow,
    this.onChanged,
    this.type
  });

  // 分割线
  Widget divLine(double left) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final isIphone5S = MediaQuery.of(context).size.width == 320.0 ? true : false;

    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            GestureDetector(onTap: () => Navigator.of(context).pop()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isIphone5S ? 5 : 5),
                child: SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Color.fromRGBO(53, 117, 191, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.all(6.0),),
                          Text(title ?? '',style: TextStyle(color: Colors.white, fontSize: 18)),
                          Padding(padding: EdgeInsets.all(6.0),),
                          divLine(0),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 60),
                              Expanded(
                                child: Container(
                                  child: 
                                  this.isShow ? input():
                                  NumberPickerRow.integer(
                                    max: max, 
                                    current: current,
                                    decimal: decimal,
                                    defaultStyle: TextStyle(color: Colors.white24,fontSize: 16),
                                    selectedStyle: TextStyle(color: Colors.white,fontSize: 25), 
                                    onChanged: (num value) {
                                      _change = value;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 60),
                            ],
                          ),
                          divLine(0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child:Text('确定',style: TextStyle(color: Colors.white, fontSize: 16)), 
                                onPressed: () {
                                  if(_change <= max){
                                    onChanged(_change);
                                  }else{
                                    showToast('请正确填写数值！');
                                  }
                                },
                              )
                            ]
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //判断输入框
  Widget input(){

    if('powerFactor' == type){
      return powerFactorInput();
    }else if('activePower' == type){
      return activePowerInput();
    }else{
      return Container();
    }

  }

  //功率因数输入框
  Widget powerFactorInput(){
    
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('功率因数设置范围：0.00-1.00',style: TextStyle(color: Colors.white,fontSize: 12),),
            ],
          ) 
        ),
        SizedBox(height: 70,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white38),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: <Widget>[
                TextFormField( 
                  inputFormatters:[
                    WhitelistingTextInputFormatter(RegExp(r'^(0.?\d{0,2}|0|1)$')),
                  ],
                  enabled: true,
                  maxLength: 4,
                  autofocus: false,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white,fontSize: 16),
                  decoration: InputDecoration(
                    icon: SizedBox(width: 12),
                    counterText: "",
                    border:InputBorder.none,
                    hintText: '请输入功率因数',
                    labelStyle: TextStyle(color: Colors.white,fontSize: 16),
                    hintStyle: TextStyle(color: Colors.white30,fontSize: 16),
                  ),
                  onChanged:(String text){
                    _change = double.parse(text);
                  },
                )
              ],
            ),
          )
        ),
        SizedBox(height: 30,),
      ]
    );
  }


  //有功功率输入框
  Widget activePowerInput(){
    
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('有功功率设置范围：0-'+max.toString(),style: TextStyle(color: Colors.white,fontSize: 12),),
            ],
          ) 
        ),
        SizedBox(height: 70,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white38),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              children: <Widget>[
                TextFormField( 
                  inputFormatters:[
                    //WhitelistingTextInputFormatter(RegExp(r'^(0.?\d{0,2}|0|1)$')),
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  enabled: true,
                  maxLength: 4,
                  autofocus: false,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white,fontSize: 16),
                  decoration: InputDecoration(
                    icon: SizedBox(width: 12),
                    counterText: "",
                    border:InputBorder.none,
                    hintText: '请输入有功功率',
                    labelStyle: TextStyle(color: Colors.white,fontSize: 16),
                    hintStyle: TextStyle(color: Colors.white30,fontSize: 16),
                  ),
                  onChanged:(String text){
                    _change = int.parse(text);
                  },
                )
              ],
            ),
          )
        ),
        SizedBox(height: 30,),
      ]
    );
  }

}