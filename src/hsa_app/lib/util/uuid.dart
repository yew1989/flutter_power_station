import 'dart:math';
import 'package:convert/convert.dart' as convert;

class UUID {

  List<String> _byteToHex;
  Map<String, int> _hexToByte;

  UUID() {
    _byteToHex = List<String>(256);
    _hexToByte = Map<String, int>();

    for (var i = 0; i < 256; i++) {
      var hex = List<int>();
      hex.add(i);
      _byteToHex[i] = convert.hex.encode(hex);
      _hexToByte[_byteToHex[i]] = i;
    }

  }

  String unparse(List<int> buffer, {int offset = 0}) {
    var i = offset;
    return '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}-'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}'
        '${_byteToHex[buffer[i++]]}${_byteToHex[buffer[i++]]}';
  }

  String create() {
    var rng =  mathRNG();
    var rnds =  rng;
    rnds[6] = (rnds[6] & 0x0f) | 0x40;
    rnds[8] = (rnds[8] & 0x3f) | 0x80;
    return unparse(rnds);
  }

    static List<int> mathRNG({int seed = -1}) {
    var rand, b = List<int>(16);

    var _rand = (seed == -1) ? Random() : Random(seed);
    for (var i = 0; i < 16; i++) {
      if ((i & 0x03) == 0) {
        rand = (_rand.nextDouble() * 0x100000000).floor().toInt();
      }
      b[i] = rand >> ((i & 0x03) << 3) & 0xff;
    }

    return b;
  }
  
}
