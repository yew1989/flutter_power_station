import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter/cupertino.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class LDEncrypt{
  
  static const publicKeyPath = 'lib/key/public.pem';

  static Future<String> encryptedRSA(BuildContext context,String plain) async {
    final publicKeyFile = await DefaultAssetBundle.of(context).loadString(LDEncrypt.publicKeyPath);
    final parser = Encrypt.RSAKeyParser();
    final RSAPublicKey publicKey = parser.parse(publicKeyFile);
    final encrypter = Encrypt.Encrypter(Encrypt.RSA(publicKey: publicKey));
    final encrypted = encrypter.encrypt(plain);
    return encrypted.base64;
  }

  static Future<String> encryptedAES(BuildContext context,String plain) async { 
    String cryptoKey= "a23deb1b79f344068a345995fb2fafc7";
    final key = Encrypt.Key.fromUtf8(cryptoKey);
    var  ivstring =  '';
    for(int i = 0; i < cryptoKey.length ; i ++) {
        if(i %2 ==0) ivstring += cryptoKey[i];
    }
    final iv = Encrypt.IV.fromUtf8(ivstring);
    var aes = Encrypt.AES(key,mode:Encrypt.AESMode.cbc);
    final encrypter = Encrypt.Encrypter(aes);
    final encrypted = encrypter.encrypt(plain, iv: iv);
    print(encrypted.base64); 
    // final s = 'MjODiF5eXcn/EyOfjSRwn8YlNZXNlJXoDKW6GC/QUqw=';
    final decrypted = encrypter.decrypt64(plain,iv: iv);

    print(decrypted); // Lore

    return  encrypted.base64;
  }


  static String encryptedMD5Sign(BuildContext context,String plain)  {
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
    debugPrint(string);
    return string;
  }


  static String encryptedMd5Pwd(String plain) {
    var content = Utf8Encoder().convert(plain);
    var digest = md5.convert(content);
    final res = hex.encode(digest.bytes)?.substring(8, 8 + 16);
    return res;
  }


}