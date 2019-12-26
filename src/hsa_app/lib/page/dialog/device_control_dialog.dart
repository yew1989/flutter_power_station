import 'package:flutter/material.dart';
import 'package:hsa_app/api/remote_task.dart';

class DeviceControlDialog extends Dialog {
  final void Function(TaskName taskName) onSelectTask;

  DeviceControlDialog(this.onSelectTask);

  // 设备控制单元
  Widget controlTile(
      BuildContext context, String left, String right, void Function() onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 43,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(left,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  Text(right,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                if (onTap != null) onTap();
              },
            ),
          ],
        ),
      ),
    );
  }

  // 分割线
  Widget dividerLine() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 12),
      height: 1,
      color: Colors.white12,
    );
  }

  // 设备控制
  Widget bottomTile(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // 设备控制
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('设备控制',
                            style: TextStyle(color: Colors.white, fontSize: 15)),
                        SizedBox(
                          height: 14,
                          width: 14,
                          child: Image.asset(
                              'images/runtime/Time_list_icon_down.png'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 127),
              // 更多
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 22,
                          width: 22,
                        ),
                        SizedBox(width: 4),
                        Text('更多',
                            style: TextStyle(
                                color: Colors.transparent, fontSize: 15)),
                      ],
                    ),
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
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 323,
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
                          controlTile(context, '主      阀', '开', () {
                            if (onSelectTask != null)
                              onSelectTask(TaskName.mainValveOn);
                          }),
                          dividerLine(),
                          controlTile(context, '主      阀', '关', () {
                            if (onSelectTask != null)
                              onSelectTask(TaskName.mainValveOff);
                          }),
                          dividerLine(),
                          controlTile(context, '旁通阀', '开', () {
                            if (onSelectTask != null)
                              onSelectTask(TaskName.sideValveOn);
                          }),
                          dividerLine(),
                          controlTile(context, '旁通阀', '关', () {
                            if (onSelectTask != null)
                              onSelectTask(TaskName.sideValveOff);
                          }),
                          dividerLine(),
                          controlTile(context, '清污机', '开', () {
                            if (onSelectTask != null)
                              onSelectTask(TaskName.clearRubbishOn);
                          }),
                          dividerLine(),
                          controlTile(context, '清污机', '关', () {
                            if (onSelectTask != null)
                              onSelectTask(TaskName.clearRubbishOff);
                          }),
                          dividerLine(),
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
