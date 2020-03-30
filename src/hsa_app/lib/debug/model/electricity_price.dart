// 电价
class ElectricityPrice {
  
  num peakElectricityPrice     = 0.0;    // 尖电价
  num spikeElectricityPrice    = 0.0;    // 峰电价
  num flatElectricityPrice     = 0.0;    // 平电价 
  num valleyElectricityPrice   = 0.0;    // 谷电价

  ElectricityPrice({this.spikeElectricityPrice,this.peakElectricityPrice,this.flatElectricityPrice,this.valleyElectricityPrice});

}

// 电量
class ElectricityEnergy {

  num peakElectricityEnergy    = 0.0;   // 尖电量
  num spikeElectricityEnergy   = 0.0;   // 峰电量
  num flatElectricityEnergy    = 0.0;   // 平电量 
  num valleyElectricityEnergy  = 0.0;   // 谷电量

  num totalElectricityEnergy   = 0.0;     // 正向有功电能电量
  bool isMultipleRateEnabled      = false;   // 复费率启用标志

  ElectricityPrice price;                    // 电价

  ElectricityEnergy(
    { this.price,
    this.spikeElectricityEnergy,
    this.peakElectricityEnergy,
    this.flatElectricityEnergy,
    this.valleyElectricityEnergy,
    this.isMultipleRateEnabled = false,
    this.totalElectricityEnergy = 0});

  // 计算收益值
  double get money => caculateMoney();

  double caculateMoney() {
    if(price == null) return 0.0;
    // 单费率 = 平电价 x 正向总有功电能
    if(isMultipleRateEnabled == false) {
      return price.flatElectricityPrice * totalElectricityEnergy;
    }
    // 复费率 
    else {
      return price.spikeElectricityPrice * spikeElectricityEnergy + 
      price.peakElectricityPrice * peakElectricityEnergy +
      price.flatElectricityPrice * flatElectricityEnergy +
      price.valleyElectricityPrice * valleyElectricityEnergy ;
    }
  }

  
}