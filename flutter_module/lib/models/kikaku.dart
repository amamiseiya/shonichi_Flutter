class SNKikaku {
  String name;
  String teamName;

  SNKikaku({required this.name, required this.teamName});

  SNKikaku.ll() : this(name: 'ラブライブ！', teamName: 'μ\'s');
  SNKikaku.llss() : this(name: 'ラブライブ！サンシャイン!!', teamName: 'Aqours');
  SNKikaku.nijigaku()
      : this(name: 'ラブライブ！虹ヶ咲学園スクールアイドル同好会', teamName: '虹ヶ咲学園スクールアイドル同好会');
  SNKikaku.shoujokageki()
      : this(name: '少女☆歌劇 レヴュー・スタァライト', teamName: 'スタァライト九九組');
  SNKikaku.nananiji() : this(name: '22/7', teamName: '22/7');
  SNKikaku.akb48() : this(name: 'AKB48', teamName: 'AKB48');
}
