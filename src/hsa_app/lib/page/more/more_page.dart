import 'package:flutter/material.dart';
import 'package:hsa_app/model/runtimedata.dart';

class MorePageTileData {
  String leftString;
  String rightString;
  MorePageTileData(this.leftString,this.rightString);
}

class MorePage extends StatefulWidget {

  final RunTimeData data;
  const MorePage({Key key, this.data}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
  
}

class _MorePageState extends State<MorePage> {
 
  List<MorePageTileData> datas = [];

  List<MorePageTileData> buildMoreData() {
    var runtimeData = widget.data;
    var terminal = runtimeData.terminalInfo;
    var power = runtimeData.power;
    var volt = runtimeData.voltageAndCurrent;
    var support = runtimeData.workSupportData;

    List<MorePageTileData> datas = [];

    datas.add(MorePageTileData('主从模式',terminal.workModel));
    datas.add(MorePageTileData('控制模式',terminal.controlModel));
    datas.add(MorePageTileData('智能方案',terminal.intelligentControlScheme));

    datas.add(MorePageTileData('远程控制',terminal.isRemoteControl ? '允许' :'禁止'));
    
    datas.add(MorePageTileData('功率因数',power.tPf.toString()));
    datas.add(MorePageTileData('Uab(V)',volt.aV.toString()));
    datas.add(MorePageTileData('Ubc(V)',volt.bV.toString()));
    datas.add(MorePageTileData('Uac(V)',volt.cV.toString()));
    datas.add(MorePageTileData('la(A)',volt.aA.toString()));
    datas.add(MorePageTileData('lb(A)',volt.bA.toString()));
    datas.add(MorePageTileData('lc(A)',volt.cA.toString()));

    datas.add(MorePageTileData('总有功功率(KW)',power.tkW.toString()));
    datas.add(MorePageTileData('A相有功功率(KW)',power.akW.toString()));
    datas.add(MorePageTileData('B相有功功率(KW)',power.bkW.toString()));
    datas.add(MorePageTileData('C相有功功率(KW)',power.ckW.toString()));

    datas.add(MorePageTileData('总无功功率(kvar)',power.tkvar.toString()));
    datas.add(MorePageTileData('A相无功功率(kvar)',power.akvar.toString()));
    datas.add(MorePageTileData('B相无功功率(kvar)',power.bkvar.toString()));
    datas.add(MorePageTileData('C相无功功率(kvar)',power.ckvar.toString()));

    datas.add(MorePageTileData('电网电压(V)',volt.gV.toString()));
    datas.add(MorePageTileData('电网电压频率(HZ)',volt.gVHz.toString()));

    datas.add(MorePageTileData('励磁电流(A)',support.excitationCurrentA.toString()));

    datas.add(MorePageTileData('警戒水位(m)',support.waterStageAlarmValue.toString()));
    datas.add(MorePageTileData('水位(m)',support.waterStage.toString()));

    var openPercent = support.gateOpening * 100;
    datas.add(MorePageTileData('开度(%)',openPercent.toString()));
    
    datas.add(MorePageTileData('转速(rpm)',support.rPM.toString()));

    var dayGeneratedEnergy = terminal.dayGeneratedEnergys.first?.toString() ?? '';
    datas.add(MorePageTileData('当日正向总有功电能(kWh)',dayGeneratedEnergy));

    datas.add(MorePageTileData('当日正向总无功电能(kvarh)',''));

    var monthGeneratedEnergy = terminal.monthGeneratedEnergys.first?.toString() ?? '';
    datas.add(MorePageTileData('当月正向总有功电能(kWh)',monthGeneratedEnergy));

    datas.add(MorePageTileData('当月正向总无功电能(kvarh)',''));
    
    var acccumulatedGeneratedEnergy = terminal.accumulatedGeneratedEnergys.first?.toString() ?? '';

    datas.add(MorePageTileData('累计正向总有功电能(kWh)',acccumulatedGeneratedEnergy));
    datas.add(MorePageTileData('累计正向总无功电能(kvarh)',''));

    // 测量点拼接
    var temperatures =  support.temperatures;
    for (var temp in temperatures) {
      var left  = temp?.mItem1 ?? '' + '(℃)';
      var right = temp?.mItem2 ?? ''; 
       datas.add(MorePageTileData(left,right));
    } 
    // datas.add(MorePageTileData('测量点1(℃)',''));

    return datas;

  }

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    this.datas  = buildMoreData();
    return Scaffold( 
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('更多'), 
      ),
      body: Padding(
        padding: EdgeInsets.only(left:12.0,right: 12.0,bottom: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(27, 25, 35, 1),
          ),
          child: ListView.builder(
            itemCount: datas?.length ?? 0,
            itemBuilder: (context,index) => moreTile(datas[index],index),
          ),
        ),
      ),
    );
  }

  Widget moreTile(MorePageTileData data,int idnex){
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 16,right: 16),
      child: Stack(
        children:[
          Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('${data.leftString}'),
              Text('${data.rightString}'),
            ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Divider(height: 0.5,color: Colors.white24)
          )

        ]
      ),
    );
  }
}