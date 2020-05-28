import 'package:flutter/material.dart';
import 'package:hsa_app/api/operation_func_code/operation_manager.dart';
import 'package:hsa_app/components/data_picker.dart';
import 'package:hsa_app/util/share.dart';

typedef PowControlDialogOnConfirmActivePower = void Function(num activePower);
typedef PowControlDialogOnConfirmPowerFactor = void Function(num powerFactor);

class PowerControlDialogWidget extends StatefulWidget {
  
  final int powerMax;
  final int currentPower;
  final double currentFactor;
  final PowControlDialogOnConfirmActivePower onConfirmActivePower;
  final PowControlDialogOnConfirmPowerFactor onConfirmPowerFactor;

  const PowerControlDialogWidget(
      {Key key,
      this.powerMax,
      this.currentPower,
      this.currentFactor,
      this.onConfirmActivePower,
      this.onConfirmPowerFactor})
      : super(key: key);

  @override
  _PowerControlDialogWidgetState createState() => _PowerControlDialogWidgetState();
}

class _PowerControlDialogWidgetState extends State<PowerControlDialogWidget> {
  List<String> powerFactorList = [];
  List<String> activePowerList = [];
  int powerMax;
  int currentPower;
  double currentFactor;
  bool editBox = false;
  bool isShow = false;
  

  @override
  void initState() {
    super.initState();
    powerMax = widget.powerMax ?? 0;
    powerMax = (powerMax * 1.2).toInt();
    currentPower = widget?.currentPower ?? 0;
    currentPower = currentPower > powerMax  ? powerMax : currentPower;
    currentFactor = widget?.currentFactor ?? 0.0;
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() async {
    this.editBox = OperationManager.getInstance().haveModifyPowerWithEditBox;
    this.isShow = await ShareManager.instance.loadIsSaveEditBox();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PowerControlDialog(
      powerMax: powerMax,
      currentPower: currentPower,
      currentFactor: currentFactor,
      onConfirmActivePower: widget.onConfirmActivePower,
      onConfirmPowerFactor: widget.onConfirmPowerFactor,
      editBox: editBox,
      isShow: isShow,
    );
  }
}

class PowerControlDialog extends Dialog {

  final int powerMax;
  final int currentPower;
  final double currentFactor;
  final bool editBox;
  final bool isShow;
  
  final PowControlDialogOnConfirmActivePower onConfirmActivePower;
  final PowControlDialogOnConfirmPowerFactor onConfirmPowerFactor;

  PowerControlDialog(
      {this.powerMax,
      this.currentPower,
      this.currentFactor,
      this.onConfirmActivePower,
      this.onConfirmPowerFactor,
      this.editBox,
      this.isShow});

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
                  Text('功率因数调控',style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 22, width: 22),
                ],
              ),
            ),
            GestureDetector(
              onTap: ()  async {
                Navigator.of(context).pop();
                
                showNumberPicker(
                  context,  (num data) {
                    if (onConfirmPowerFactor != null) onConfirmPowerFactor(data);
                  },
                  title: '请'+(editBox ? '输入' : '选择')+'功率因数',
                  current : (currentFactor*100).toInt(),
                  max : 100,
                  decimal:2,
                  type : 'powerFactor',
                  isShow: editBox ? isShow : false,
                );
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
                  Text('有功调控',style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 22, width: 22),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                showNumberPicker(
                  context,  (num data) {
                    if (onConfirmActivePower != null) onConfirmActivePower(data);
                  },
                  title: '请'+(editBox ? '输入' : '选择')+'有功功率(kW)',
                  current : currentPower,
                  max : powerMax,
                  decimal:0,
                  type : 'activePower',
                  isShow: editBox ? isShow : false,
                );
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
                        SizedBox(height: 22,width: 22,child: Image.asset('images/runtime/Time_Apower_icon.png')),
                        SizedBox(width: 4),
                        Text('调功',style:TextStyle(color: Colors.white, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(onTap: () => Navigator.of(context).pop()),
        ],
      ),
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
              bottom: 70,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isIphone5S ? 5 : 5),
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
