class SNKikaku {
  String name;
  String teamName;

  SNKikaku({this.name, this.teamName});

  SNKikaku.ll() : this(name: 'ラブライブ！', teamName: 'μ\'s');
  SNKikaku.llss() : this(name: 'ラブライブ！サンシャイン!!', teamName: 'Aqours');
  SNKikaku.shoujokageki()
      : this(name: '少女☆歌劇 レヴュー・スタァライト', teamName: 'スタァライト九九組');
  SNKikaku.akb48() : this(name: 'AKB48', teamName: 'AKB48');
}
