import 'package:test/test.dart';

import '../lib/utils/des.dart';

void main() {
  group('', () {
    test('编码转换测试', () {
      final String text1 = 'yeah tiger';
      final String text2 = '液态噶';
      print(text1.codeUnits);
      print(text2.codeUnits);
    });
    test('单行文本加密测试', () {
      final String plaintext = 'yeahyeahyeahtigerfaibowaipajyajya!!!';
      final String key = 'faibowai';
      print('The plaintext is $plaintext');
      print('The key is $key');
      final String cipherText = desEncrypt(plaintext, key);
      final decrypted = desDecrypt(cipherText, key);
      expect(decrypted, plaintext);
    });
    test('实用Markdown加密测试', () {
      final String plaintext = r'''# 待定 Star Diamond 拍摄计划

拍摄日期：
# 分镜表
| 镜号 | 起始时间 | 歌词内容 | 场号 | 角色 | 景别 | 运动 | 角度 | 拍摄内容 | 画面 | 备注 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 7 | 0:17.547 | yarimasune | 1010 | 恋,光, | MEDIUMSHOT | 逆时针环绕 | 略仰 | taiga!waiya!saiba!faiba! |  | No additional comment. |''';
      final String key = 'faibowai';
      print('The plaintext is $plaintext');
      print('The key is $key');
      final String cipherText = desEncrypt(plaintext, key);
      final decrypted = desDecrypt(cipherText, key);
      expect(decrypted, plaintext);
    });
  });
}
