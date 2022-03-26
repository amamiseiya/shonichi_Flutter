import 'des_tables.dart';
import 'des_utils.dart';

String desEncrypt(String plaintext, String key) {
  assert(key.length == 8);

  final int times = (plaintext.length % 4 == 0)
      ? plaintext.length ~/ 4
      : plaintext.length ~/ 4 + 1;
  plaintext = plaintext.padRight(times * 4, ' ');
  final List<int> keyBin = keyToBitList(key);

  String cipherText = '';
  for (int i = 0; i < times; i++) {
    final cipherTextBin = encrypt(
        utf16ToBitList(plaintext.substring(i * 4, (i + 1) * 4)), keyBin);
    cipherText += bitListToUtf16(cipherTextBin);
  }
  print('The cipherText is $cipherText');
  return cipherText;
}

String desDecrypt(String cipherText, String key) {
  assert(cipherText.length % 4 == 0);
  assert(key.length == 8);

  final int times = cipherText.length ~/ 4;
  final List<int> keyBin = keyToBitList(key);

  String decrypted = '';
  for (int i = 0; i < times; i++) {
    final decryptedBin = decrypt(
        utf16ToBitList(cipherText.substring(i * 4, (i + 1) * 4)), keyBin);
    decrypted += bitListToUtf16(decryptedBin);
  }
  decrypted = decrypted.trimRight();
  print('The decrypted text is $decrypted');
  return decrypted;
}

List<int> encrypt(List<int> text, List<int> key)
/*
    加密功能
    @param text: 待加密的64位二进制文本
    @param key: 64位二进制密钥
    @return:
    */
{
  List<int> plain1 = permute(text, IP_TABLE);
  List<int> plainL = plain1.sublist(0, 32);
  List<int> plainR = plain1.sublist(32, 64);
  List<List<int>> keyList = getSubKey(key);
  for (int i = 0; i < 16; i++) {
    List<int> tmp = xor(f(plainR, keyList[i]), plainL);
    plainL = plainR;
    plainR = tmp;
  }
  List<int> plain2 = plainR + plainL;
  plain2 = permute(plain2, INV_IP_TABLE);
  return plain2;
}

List<int> decrypt(List<int> text, List<int> key)
/*
    解密功能
    @param text: 待解密的64位二进制文本
    @param key: 64位二进制密钥
    @return:
    */
{
  List<int> plain1 = permute(text, IP_TABLE);
  List<int> plainL = plain1.sublist(0, 32);
  List<int> plainR = plain1.sublist(32, 64);
  List<List<int>> keyList = getSubKey(key);
  for (int i = 0; i < 16; i++) {
    List<int> tmp = xor(f(plainR, keyList[15 - i]), plainL);
    plainL = plainR;
    plainR = tmp;
  }
  List<int> plain2 = plainR + plainL;
  plain2 = permute(plain2, INV_IP_TABLE);
  return plain2;
}

List<List<int>> getSubKey(List<int> key)
/*
    生成全部子密钥
    @param key: 原始密钥值
    @return: 16次计算不同的子密钥的列表
    */
{
  List<List<int>> result = [];
  // 置换选择表1置换
  List<int> key1 = permute(key, PC_1_TABLE);
  for (int i = 0; i < 16; i++) {
    List<int> key2 = List.filled(48, 0);
    // 分为左右两部分
    List<int> keyL = key1.sublist(0, 28);
    List<int> keyR = key1.sublist(28, 56);
    // 两部分分别循环左移
    keyL = leftShift(keyL, i);
    keyR = leftShift(keyR, i);
    // 将左右两部分连接
    key1 = keyL + keyR;
    // 置换选择表2置换
    key2 = permute(key1, PC_2_TABLE);
    // 生成密钥
    result.add(key2);
  }
  return result;
}

List<int> f(List<int> text, List<int> subKey)
/*
    f函数
    @param sub_key: 本次迭代的子密钥
    */
{
  text = permute(text, E_TABLE);
  text = xor(text, subKey);
  text = sBox(text);
  text = permute(text, P_TABLE);
  return text;
}

List<int> sBox(List<int> text)
/*
    S盒代替
    为f函数中的一个操作，因较为复杂而单独定义。
    */
{
  List<int> result = List.filled(32, 0);
  for (var i = 0; i < 8; i++) {
    int row = 2 * text[i * 6] + text[i * 6 + 5];
    int column = 8 * text[i * 6 + 1] +
        4 * text[i * 6 + 2] +
        2 * text[i * 6 + 3] +
        text[i * 6 + 4];
    int record = S_BOXES[i][row * 16 + column];
    for (var j = 0; j < 4; j++) {
      result[4 * i + j] = int2bin(record)[j];
    }
  }
  return result;
}

// def checkValid(text):
//     /*
//     检测输入的文本是否合法
//     使用输入字符的ASCII值来判断，48-122之间视为合法。
//     @param text: 待测试文本
//     @return: bool
//     */
//     if len(text) != 8:
//         return False
//     for i in range(len(text)):
//         if not ((ord(text[i]) >= 48) and (ord(text[i]) <= 122)):
//             return False
//     return True

// if __name__ == '__main__':
//     plaintext = input('Please input your plaintext(must be 8 letters or digits):')
//     if check_valid(plaintext):
//         plaintext_b = string2bin(plaintext)
//     else:
//         print('Invalid parameter! Please try again!')
//         print('老师我做了非法输入检测的:)')
//         python = sys.executable
//         os.execl(python, python, *sys.argv)
//     key = input('Please input your key(must be 8 letters or digits):')
//     if check_valid(key):
//         key_b = string2bin(key)
//     else:
//         print('Invalid parameter! Please try again!')
//         print('老师我做了非法输入检测的:)')
//         python = sys.executable
//         os.execl(python, python, *sys.argv)
//     cipher_text = bin2string(encrypt(plaintext_b, key_b))
//     print('The cipher text is:' + cipher_text)
//     print('There\'s no character after colon.')
//     print('You can use clipboard in order to avoid exceptions caused by special character.')

//     cipher_text_dec = input('Please input your cipher text:')
//     cipher_text_dec_b = string2bin(cipher_text)
//     key_dec = input('Please input your key:')
//     if check_valid(key):
//         key_dec_b = string2bin(key)
//     else:
//         print('Invalid parameter! Please try again!')
//         python = sys.executable
//         os.execl(python, python, *sys.argv)
//     plaintext_dec = decrypt(cipher_text_dec_b, key_dec_b)
//     print('The plaintext is:' + bin2string(plaintext_dec))
