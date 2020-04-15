import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter/cupertino.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class LDEncrypt{
  
  static const publicKeyPath = 'keys/public.pem'; // 公钥路径

  // 用 RSA 加密 for LEAD
  static Future<String> encryptedRSA(BuildContext context,String plain) async {
    final publicKeyFile = await DefaultAssetBundle.of(context).loadString(LDEncrypt.publicKeyPath);
    final parser = Encrypt.RSAKeyParser();
    final RSAPublicKey publicKey = parser.parse(publicKeyFile);
    final encrypter = Encrypt.Encrypter(Encrypt.RSA(publicKey: publicKey));
    final encrypted = encrypter.encrypt(plain);
    return encrypted.base64;
  }

  // 用 AES 加密 for LEAD
  static Future<String> encryptedAES(BuildContext context,String plain,String cryptoKey) async { 

    final key = Encrypt.Key.fromUtf8(cryptoKey);
    var  ivstring =  '';
    for(int i = 0; i < cryptoKey.length ; i ++) {
        if(i %2 ==0) ivstring += cryptoKey[i];
    }
    final iv = Encrypt.IV.fromUtf8(ivstring);
    var aes = Encrypt.AES(key,mode:Encrypt.AESMode.cbc);
    final encrypter = Encrypt.Encrypter(aes);
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return encrypted.base64;
  }

  // Md5 加密 for LEAD
  static String encodeMd5(String plain) {
    var content = Utf8Encoder().convert(plain);
    var digest = md5.convert(content);
    final res = hex.encode(digest.bytes)?.substring(8, 8 + 16);
    return res;
  }

  // MD5 签名 For LEAD
  static String signMD5(BuildContext context,String plain)  {
    var content = Utf8Encoder().convert(plain);
    var digest = md5.convert(content);
    var res = hex.encode(digest.bytes);
    List<String> list = [];
    
    for(int i = 0 ; i < res.length ; i++,i++){
      var u = res.substring(i,i+2);
      list.add(u);
    }

    String string = '';

    for(int k = 0; k < list.length;k++) {
      var t = list[k];
      if(k%2==0){
        string += t.toUpperCase();
      }
      else {
        string += t.toLowerCase();
      }
    }
    return string;
  }

  // 十六进制 Byte Hex 转 Hex String
  static String byteToHexString(List<int> bytes) {
    final StringBuffer buffer = StringBuffer();
    for (int part in bytes) {
      if (part & 0xff != part) {
        throw FormatException("$part is not a byte integer");
      }
      buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
    }
    return buffer.toString().toUpperCase();
  }


}