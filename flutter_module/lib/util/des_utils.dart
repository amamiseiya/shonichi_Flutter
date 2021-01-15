List<int> permute(List<int> text, List<int> table)
/*
    @param text: 原始text
    @param table: 置换用table
    @return: 置换后的text
    */
{
  List<int> result = List.filled(table.length, 0);
  for (int i = 0; i < table.length; i++) {
    result[i] = text[table[i] - 1];
  }
  return result;
}

List<int> xor(List<int> text1, List<int> text2)
/*
    两个列表的异或
    */
{
  List<int> result = List.filled(text1.length, 0);
  for (int i = 0; i < text1.length; i++) {
    result[i] = text1[i] ^ text2[i];
    assert(result[i] == 0 || result[i] == 1);
  }

  return result;
}

List<int> keyToBitList(String key) {
  List<int> result = [];
  for (int codeUnit in key.codeUnits) {
    String codeUnitBin = codeUnit.toRadixString(2).padLeft(8, '0');
    for (String bit in codeUnitBin.split('')) {
      result.add(int.parse(bit));
    }
  }
  return result;
}

List<int> utf16ToBitList(String text) {
  assert(text.length == 4);
  List<int> result = [];
  for (int codeUnit in text.codeUnits) {
    String codeUnitBin = codeUnit.toRadixString(2).padLeft(16, '0');
    for (String bit in codeUnitBin.split('')) {
      result.add(int.parse(bit));
    }
  }
  assert(result.length == 64);
  return result;
}

String bitListToUtf16(List<int> bitList) {
  assert(bitList.length == 64);
  String result = '';
  for (int i = 0; i < 4; i++) {
    String charBin = '';
    for (int bit in bitList.sublist(i * 16, (i + 1) * 16)) {
      charBin += bit.toRadixString(2);
    }
    result += String.fromCharCode(int.parse(charBin, radix: 2));
  }
  assert(result.length == 4);
  return result;
}

List<int> bitStringToBitList(String text) {
  List<int> result = [];
  for (String s in text.split('')) {
    result.add(int.parse(s));
  }
  return result;
}

String bitListToBitString(List<int> binList) {
  assert(binList.length % 8 == 0);
  String result = '';
  for (int i in binList) {
    result += i.toString();
  }
  return result;
}

List<int> int2bin(int num)
/*
    将0~15的整数转换为4位二进制整数
    @param num:
    @return:
    */
{
  List<int> l = [];
  for (int i = 0; i < 4; i++) {
    l.insert(0, num % 2);
    num = num ~/ 2;
  }
  return l;
}

List<int> leftShift(List<int> text, int i)
/*
    @param text: 原始列表
    @param i: 当前迭代计数，以获取需要左移的步数
    @return: 左移后的列表
    */
{
  int step = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1][i];
  return text.sublist(step + 1) + text.sublist(0, step + 1);
}

// if __name__ == '__main__':
//     plaintext = input('Please input your plaintext:')
//     out1 = string2bin(plaintext)
//     out2 = bin2string(out1)
//     out3 = bin2string(
//         [0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0,
//          1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1])
//     print(out1)
//     print(out2)
//     print(out3)
