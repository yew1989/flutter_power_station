import 'package:flutter/material.dart';
import 'package:hsa_app/components/data_picker.dart';

typedef PowControlDialogOnConfirmActivePower = void Function(
    String activePower);
typedef PowControlDialogOnConfirmPowerFactor = void Function(
    String powerFactor);

class PowerControlDialogWidget extends StatefulWidget {
  final int powerMax;
  final PowControlDialogOnConfirmActivePower onConfirmActivePower;
  final PowControlDialogOnConfirmPowerFactor onConfirmPowerFactor;

  const PowerControlDialogWidget(
      {Key key,
      this.powerMax,
      this.onConfirmActivePower,
      this.onConfirmPowerFactor})
      : super(key: key);

  @override
  _PowerControlDialogWidgetState createState() =>
      _PowerControlDialogWidgetState();
}

class _PowerControlDialogWidgetState extends State<PowerControlDialogWidget> {
  List<String> powerFactorList = [];
  List<String> activePowerList = [];

  List<String> buildPowerFactorList() {
    List<String> list = [];
    for (var i = 0; i < 101; i++) {
      var k = i / 100;
      list.add(k.toStringAsFixed(2));
    }
    list = list.reversed.toList();
    return list;
  }

  List<String> buildActivePowerList(int activePowerMax) {
    List<String> list = [];
    for (var i = 0; i < activePowerMax + 1; i++) {
      list.add(i.toStringAsFixed(0));
    }
    list = list.reversed.toList();
    return list;
  }

  @override
  void initState() {
    powerFactorList = buildPowerFactorList();
    activePowerList = buildActivePowerList(widget.powerMax);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PowerControlDialog(
      activePowerList: activePowerList,
      powerFactorList: powerFactorList,
      onConfirmActivePower: widget.onConfirmActivePower,
      onConfirmPowerFactor: widget.onConfirmPowerFactor,
    );
  }
}

class PowerControlDialog extends Dialog {
  final List<String> powerFactorList;
  final List<String> activePowerList;
  final PowControlDialogOnConfirmActivePower onConfirmActivePower;
  final PowControlDialogOnConfirmPowerFactor onConfirmPowerFactor;

  PowerControlDialog(
      {this.activePowerList,
      this.powerFactorList,
      this.onConfirmActivePower,
      this.onConfirmPowerFactor});

  // 功率因数调控
  Widget powerFactorTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 43,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('功率因数调控',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 22, width: 22),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                showDataPicker(context, '请选择功率因数', powerFactorList,
                    (String data) {
                  if (onConfirmPowerFactor != null) onConfirmPowerFactor(data);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  //  有功调控
  Widget activePowerTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 43,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('有功调控',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 22, width: 22),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                showDataPicker(context, '请选择有功功率(kW)', activePowerList,
                    (String data) {
                  if (onConfirmActivePower != null) onConfirmActivePower(data);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // 分割线
  Widget divLine(double left) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
    );
  }

  // 底部调功
  Widget bottomTile(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 自动
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('自          动',
                              style: TextStyle(
                                  color: Colors.transparent, fontSize: 15)),
                          SizedBox(height: 14, width: 14),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 127),
                  // 调功率
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 22,
                            width: 22,
                            child: Image.asset(
                                'images/runtime/Time_Apower_icon.png'),
                          ),
                          SizedBox(width: 4),
                          Text('调功',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIphone5S =
        MediaQuery.of(context).size.width == 320.0 ? true : false;
    return SafeArea(
      child: Material(
        //透明类型
        type: MaterialType.transparency,
        //保证控件居中效果
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 75,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isIphone5S ? 9 : 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 152,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          activePowerTile(context),
                          divLine(12),
                          powerFactorTile(context),
                          divLine(0),
                          bottomTile(context),
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
}
