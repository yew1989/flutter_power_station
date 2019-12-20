import 'package:flutter/material.dart';
import 'package:hsa_app/model/runtime_adapter.dart';

class ControlModelDialogWidget extends StatefulWidget {
  final RuntimeData runtimeData;
  final void Function(ControlModelCurrentStatus status) onChoose;

  const ControlModelDialogWidget({Key key, this.runtimeData, this.onChoose})
      : super(key: key);

  @override
  _ControlModelDialogWidgetState createState() =>
      _ControlModelDialogWidgetState();
}

class _ControlModelDialogWidgetState extends State<ControlModelDialogWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ControlModelDialog(widget.runtimeData.status,widget.onChoose);
  }
}

enum ControlModelCurrentStatus { unknow, manual, auto, remoteOn, remoteOff }

class ControlModelDialog extends Dialog {

  final ControlModelCurrentStatus currentStatus;
  final void Function(ControlModelCurrentStatus status) onChoose;
  
  ControlModelDialog(this.currentStatus, this.onChoose);

  Widget modelTile(BuildContext context,String string,bool enable,ControlModelCurrentStatus status) {

    var isRemoteMode = status == ControlModelCurrentStatus.remoteOff 
    || status == ControlModelCurrentStatus.remoteOn;
    
    return Container(
      margin: EdgeInsets.only(right: 12,
      left:  isRemoteMode ? 40 : 12),
      child: SizedBox(
        height: 43,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              Text(string, style: TextStyle(color: enable ? Colors.white :Colors.white60, fontSize: 16)),
              SizedBox(
                  height: 22,
                  width: 22,
                  child: status == currentStatus
                      ? Image.asset('images/runtime/Time_selected_icon.png')
                      : null),
          ],
        ),
            ),
        GestureDetector(
          onTap: (){
            if(isRemoteMode) {
              Navigator.of(context).pop();
              if(onChoose != null) onChoose(status);
            }
          },
        ),
          ],
        ),
      ),
    );
  }

  Widget divider(double left){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: left),
      height: 1,
      color: Colors.white12,
      );
  }

  @override
  Widget build(BuildContext context) {

    final isIphone5s = MediaQuery.of(context).size.width == 320.0 ? true : false;

    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 75,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isIphone5s ? 9 : 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 280,
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

                          modelTile(context,'手动',false,ControlModelCurrentStatus.manual),
                          divider(12),
                          modelTile(context,'自动',false,ControlModelCurrentStatus.auto),
                          divider(12),

                          // 智能
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              height: 43,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: '智能',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      TextSpan(
                                          text: ' (下位机智能控制屏旋钮处于智能模式时,方可开启)',
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: isIphone5s ? 10 : 12)),
                                    ]),
                                  ),
                                  // SizedBox(height: 22, width: 22),
                                ],
                              ),
                            ),
                          ),

                          divider(12),
                          modelTile(context,'远程控制',true,ControlModelCurrentStatus.remoteOn),
                          divider(40),
                          modelTile(context,'智能水位控制',true,ControlModelCurrentStatus.remoteOff),

                          // 分割线顶格
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.white12,
                          ),

                          // 底部扩展区
                          Expanded(
                            child: Center(
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    // 自动
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text('自          动',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15)),
                                              SizedBox(
                                                height: 14,
                                                width: 14,
                                                child: Image.asset(
                                                    'images/runtime/Time_list_icon_down.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 127),
                                    // 调功率
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(height: 22, width: 22),
                                            SizedBox(width: 4),
                                            Text('调功',
                                                style: TextStyle(
                                                    color: Colors.transparent,
                                                    fontSize: 15)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
}
