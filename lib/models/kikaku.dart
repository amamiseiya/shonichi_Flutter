class SNKikaku {
  String name;
  String teamName;
  String nameEng;

  SNKikaku({required this.name, required this.teamName, required this.nameEng});

  SNKikaku.ll() : this(name: 'ラブライブ！', teamName: 'μ\'s', nameEng: 'LoveLive');
  SNKikaku.llss()
      : this(
            name: 'ラブライブ！サンシャイン!!',
            teamName: 'Aqours',
            nameEng: 'LoveLive Sunshine');
  SNKikaku.nijigaku()
      : this(
            name: 'ラブライブ！虹ヶ咲学園スクールアイドル同好会',
            teamName: '虹ヶ咲学園スクールアイドル同好会',
            nameEng: 'LoveLive Nijigasaki');
  SNKikaku.shoujokageki()
      : this(
            name: '少女☆歌劇 レヴュー・スタァライト',
            teamName: 'スタァライト九九組',
            nameEng: 'Revue Starlight');
  SNKikaku.nananiji() : this(name: '22/7', teamName: '22/7', nameEng: '22_7');
  SNKikaku.akb48() : this(name: 'AKB48', teamName: 'AKB48', nameEng: 'AKB48');
}
