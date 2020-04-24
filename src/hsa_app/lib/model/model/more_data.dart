
import 'package:hsa_app/model/model/all_model.dart';

class MoreItem {
  String nameZh;
  String nameEn;
  String dataStr;

  MoreItem({this.nameZh, this.nameEn, this.dataStr});

  MoreItem.fromJson(Map<String, dynamic> json) {
    nameZh = json['m_Item1'] ?? '';
    nameEn = json['m_Item2'] ?? '';
    dataStr = json['m_Item3'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['m_Item1'] = this.nameZh;
    data['m_Item2'] = this.nameEn;
    data['m_Item3'] = this.dataStr;
    return data;
  }
}

class MoreData{

  List<MoreItem> fromData(DeviceTerminal deviceTerminal){
    List<MoreItem> list = List<MoreItem>();

    list.add( MoreItem(nameZh: '主从模式',nameEn: 'isMaster',dataStr:deviceTerminal.isMaster ? '主机':'从机'));
    list.add( MoreItem(nameZh: '控制模式',nameEn: 'controlType',dataStr:deviceTerminal?.controlType ?? '未知'));
    list.add( MoreItem(nameZh: '远程控制',nameEn: 'isAllowRemoteControl',dataStr:deviceTerminal.isAllowRemoteControl ? '允许':'禁止'));
    list.add( MoreItem(nameZh: '功率因数',nameEn: 'powerFactor',
              dataStr:(deviceTerminal?.nearestRunningData?.powerFactor ?? 0.0).toString()));

    list.add( MoreItem(nameZh: 'Uab(V)',nameEn: 'voltage',
              dataStr:(deviceTerminal?.nearestRunningData?.voltage ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'Ubc(V)',nameEn: 'voltageB',
              dataStr:(deviceTerminal?.nearestRunningData?.voltageB ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'Uca(V)',nameEn: 'voltageC',
              dataStr:(deviceTerminal?.nearestRunningData?.voltageC ?? 0.0).toString()));

    list.add( MoreItem(nameZh: 'Ia(A)',nameEn: 'current',
              dataStr:(deviceTerminal?.nearestRunningData?.current ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'Ib(A)',nameEn: 'currentB',
              dataStr:(deviceTerminal?.nearestRunningData?.currentB ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'Ic(A)',nameEn: 'currentC',
              dataStr:(deviceTerminal?.nearestRunningData?.currentC ?? 0.0).toString()));

    list.add( MoreItem(nameZh: '总有功功率(kW)',nameEn: 'power',
              dataStr:(deviceTerminal?.nearestRunningData?.power ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'A相有功功率(kW)',nameEn: 'powerA',
              dataStr:(deviceTerminal?.nearestRunningData?.powerA ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'B相有功功率(kW)',nameEn: 'powerB',
              dataStr:(deviceTerminal?.nearestRunningData?.powerB ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'C相有功功率(kW)',nameEn: 'powerC',
              dataStr:(deviceTerminal?.nearestRunningData?.powerC ?? 0.0).toString()));

    list.add( MoreItem(nameZh: '总无功功率(kvar)',nameEn: 'reactivePower',
              dataStr:(deviceTerminal?.nearestRunningData?.reactivePower ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'A相无功功率(kvar)',nameEn: 'reactivePowerA',
              dataStr:(deviceTerminal?.nearestRunningData?.reactivePowerA ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'B相无功功率(kvar)',nameEn: 'reactivePowerB',
              dataStr:(deviceTerminal?.nearestRunningData?.reactivePowerB ?? 0.0).toString()));
    list.add( MoreItem(nameZh: 'C相无功功率(kvar)',nameEn: 'reactivePowerC',
              dataStr:(deviceTerminal?.nearestRunningData?.reactivePowerC ?? 0.0).toString()));

    list.add( MoreItem(nameZh: '电网电压(V)',nameEn: 'netVoltage',
              dataStr:(deviceTerminal?.nearestRunningData?.netVoltage ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '电网电压频率(Hz)',nameEn: 'netFrequency',
              dataStr:(deviceTerminal?.nearestRunningData?.netFrequency ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '励磁电流(A)',nameEn: 'fieldCurrent',
              dataStr:(deviceTerminal?.nearestRunningData?.fieldCurrent ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '警戒水位(m)',nameEn: 'reservoirAlarmWaterStage',
              dataStr:(deviceTerminal?.stationInfo?.reservoirAlarmWaterStage ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '水位(m)',nameEn: 'waterStage',
              dataStr:(deviceTerminal?.nearestRunningData?.waterStage ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '开度(%)',nameEn: 'openAngle',
              dataStr:(deviceTerminal?.nearestRunningData?.openAngle ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '转速(rpm)',nameEn: 'speed',
              dataStr:(deviceTerminal?.nearestRunningData?.speed ?? 0.0).toString()));

    list.add( MoreItem(nameZh: '当日正向总有功电能(kWh)',nameEn: 'dayActivePower',
              dataStr:(deviceTerminal?.nearestRunningData?.dayActivePower ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '当日正向总无功电能(kvarh)',nameEn: 'dayReactivePower',
              dataStr:(deviceTerminal?.nearestRunningData?.dayReactivePower ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '当月正向总有功电能(kWh)',nameEn: 'monthActivePower',
              dataStr:(deviceTerminal?.nearestRunningData?.monthActivePower ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '当月正向总无功电能(kvarh)',nameEn: 'monthReactivePower',
              dataStr:(deviceTerminal?.nearestRunningData?.monthReactivePower ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '累计正向总有功电能(kWh)',nameEn: 'totalActivePower',
              dataStr:(deviceTerminal?.nearestRunningData?.totalActivePower ?? 0.0).toString()));
    list.add( MoreItem(nameZh: '累计正向总无功电能(kvarh)',nameEn: 'totalReactivePower',
              dataStr:(deviceTerminal?.nearestRunningData?.totalReactivePower ?? 0.0).toString()));

    return list;
  }
}