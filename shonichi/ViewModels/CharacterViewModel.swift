//
//  CharacterViewModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/13.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

class CharacterViewModel: ObservableObject {
    var context: NSManagedObjectContext
    
    var allKikakusRequest: NSFetchRequest<SNKikaku> {
        let allKikakusRequest = NSFetchRequest<SNKikaku>(entityName: "SNKikaku")
        allKikakusRequest.predicate = NSPredicate(format: "TRUEPREDICATE")
        allKikakusRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return allKikakusRequest
    }
    
    var allCharactersRequest: NSFetchRequest<SNCharacter> {
        let allCharactersRequest = NSFetchRequest<SNCharacter>(entityName: "SNCharacter")
        allCharactersRequest.predicate = NSPredicate(format: "TRUEPREDICATE")
        allCharactersRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return allCharactersRequest
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        try? context.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "SNKikaku")))
        try? context.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "SNCharacter")))
        initKikaku(context: context)
        initCharacter(context: context)
    }
    
    func initKikaku(context: NSManagedObjectContext) -> Void {
        let ll = SNKikaku(context: context)
        ll.name = "ラブライブ！"
        ll.teamName = "μ's"
        let llss = SNKikaku(context: context)
        llss.name = "ラブライブ！サンシャイン!!"
        llss.teamName = "Aqours"
        let shoujokageki = SNKikaku(context: context)
        shoujokageki.name = "少女☆歌劇 レヴュー・スタァライト"
        shoujokageki.teamName = "スタァライト九九組"
        let akb48 = SNKikaku(context: context)
        akb48.name = "AKB48"
        akb48.teamName = "AKB48"
        
        if context.hasChanges{
            try? context.save()
        }
    }
    
    func initCharacter(context: NSManagedObjectContext) -> Void {
        
        let allKikakus: [SNKikaku] = try! context.fetch(allKikakusRequest)
        
        let ll = allKikakus.filter { $0.name == "ラブライブ！" }.first
        let llss = allKikakus.filter { $0.name == "ラブライブ！サンシャイン!!" }.first
        let shoujokageki = allKikakus.filter { $0.name == "少女☆歌劇 レヴュー・スタァライト" }.first
        
        let honoka = SNCharacter(context: context)
        honoka.name = "高坂 穂乃果"
        honoka.nameAbbr = "果"
        honoka.memberColor = UIColor(hex: "FFA500")
        honoka.grade = "2年生"
        honoka.group = "Printemps"
        honoka.subordinates = ll
        
        let eli = SNCharacter(context: context)
        eli.name = "絢瀬 絵里"
        eli.nameAbbr = "绘"
        eli.memberColor = UIColor(hex: "00FFFF")
        eli.grade = "3年生"
        eli.group = "BiBi"
        eli.subordinates = ll
        
        let kotori = SNCharacter(context: context)
        kotori.name = "南 ことり"
        kotori.nameAbbr = "鸟"
        kotori.memberColor = UIColor(hex: "808080")
        kotori.grade = "2年生"
        kotori.group = "Printemps"
        kotori.subordinates = ll
        
        let umi = SNCharacter(context: context)
        umi.name = "園田 海未"
        umi.nameAbbr = "海"
        umi.memberColor = UIColor(hex: "0000FF")
        umi.grade = "2年生"
        umi.group = "lily white"
        umi.subordinates = ll
        
        let rin = SNCharacter(context: context)
        rin.name = "星空 凛"
        rin.nameAbbr = "凛"
        rin.memberColor = UIColor(hex: "FFFF00")
        rin.grade = "1年生"
        rin.group = "lily white"
        rin.subordinates = ll
        
        let maki = SNCharacter(context: context)
        maki.name = "西木野 真姫"
        maki.nameAbbr = "姬"
        maki.memberColor = UIColor(hex: "FF0000")
        maki.grade = "1年生"
        maki.group = "BiBi"
        maki.subordinates = ll
        
        let nozomi = SNCharacter(context: context)
        nozomi.name = "東條 希"
        nozomi.nameAbbr = "希"
        nozomi.memberColor = UIColor(hex: "800080")
        nozomi.grade = "3年生"
        nozomi.group = "lily white"
        nozomi.subordinates = ll
        
        let hanayo = SNCharacter(context: context)
        hanayo.name = "小泉 花陽"
        hanayo.nameAbbr = "花"
        hanayo.memberColor = UIColor(hex: "008000")
        hanayo.grade = "1年生"
        hanayo.group = "Printemps"
        hanayo.subordinates = ll
        
        let nico = SNCharacter(context: context)
        nico.name = "矢澤 にこ"
        nico.nameAbbr = "妮"
        nico.memberColor = UIColor(hex: "FFC0CB")
        nico.grade = "3年生"
        nico.group = "BiBi"
        nico.subordinates = ll
        
        let chika = SNCharacter(context: context)
        chika.name = "高海 千歌"
        chika.nameAbbr = "千"
        chika.memberColor = UIColor(hex: "F08300")
        chika.grade = "2年生"
        chika.group = "CYaRon!"
        chika.subordinates = llss
        
        let riko = SNCharacter(context: context)
        riko.name = "桜内 梨子"
        riko.nameAbbr = "梨"
        riko.memberColor = UIColor(hex: "FF9999")
        riko.grade = "2年生"
        riko.group = "Guilty Kiss"
        riko.subordinates = llss
        
        let kanan = SNCharacter(context: context)
        kanan.name = "松浦 果南"
        kanan.nameAbbr = "南"
        kanan.memberColor = UIColor(hex: "229977")
        kanan.grade = "3年生"
        kanan.group = "AZALEA"
        kanan.subordinates = llss
        
        let dia = SNCharacter(context: context)
        dia.name = "黒澤 ダイヤ"
        dia.nameAbbr = "黛"
        dia.memberColor = UIColor(hex: "FF4A4A")
        dia.grade = "3年生"
        dia.group = "AZALEA"
        dia.subordinates = llss
        
        let you = SNCharacter(context: context)
        you.name = "渡辺 曜"
        you.nameAbbr = "曜"
        you.memberColor = UIColor(hex: "68D1FF")
        you.grade = "2年生"
        you.group = "CYaRon!"
        you.subordinates = llss
        
        let yoshiko = SNCharacter(context: context)
        yoshiko.name = "津島 善子"
        yoshiko.nameAbbr = "善"
        yoshiko.memberColor = UIColor(hex: "7A7A7A")
        yoshiko.grade = "1年生"
        yoshiko.group = "Guilty Kiss"
        yoshiko.subordinates = llss
        
        let hanamaru = SNCharacter(context: context)
        hanamaru.name = "国木田 花丸"
        hanamaru.nameAbbr = "丸"
        hanamaru.memberColor = UIColor(hex: "DBB623")
        hanamaru.grade = "1年生"
        hanamaru.group = "AZALEA"
        hanamaru.subordinates = llss
        
        let mari = SNCharacter(context: context)
        mari.name = "小原 鞠莉"
        mari.nameAbbr = "鞠"
        mari.memberColor = UIColor(hex: "D47AFF")
        mari.grade = "3年生"
        mari.group = "Guilty Kiss"
        mari.subordinates = llss
        
        let ruby = SNCharacter(context: context)
        ruby.name = "黒澤 ルビィ"
        ruby.nameAbbr = "露"
        ruby.memberColor = UIColor(hex: "FF5599")
        ruby.grade = "1年生"
        ruby.group = "CYaRon!"
        ruby.subordinates = llss
        
        let karen = SNCharacter(context: context)
        karen.name = "愛城 華恋"
        karen.nameAbbr = "恋"
        karen.memberColor = UIColor(hex: "FB5458")
        karen.subordinates = shoujokageki
        
        let hikari = SNCharacter(context: context)
        hikari.name = "神楽 ひかり"
        hikari.nameAbbr = "光"
        hikari.memberColor = UIColor(hex: "6292E9")
        hikari.subordinates = shoujokageki
        
        let maya = SNCharacter(context: context)
        maya.name = "天堂 真矢"
        maya.nameAbbr = "真"
        maya.memberColor = UIColor(hex: "CBC6CC")
        maya.subordinates = shoujokageki
        
        let junna = SNCharacter(context: context)
        junna.name = "星見 純那"
        junna.nameAbbr = "纯"
        junna.memberColor = UIColor(hex: "95CAEE")
        junna.subordinates = shoujokageki
        
        let mahiru = SNCharacter(context: context)
        mahiru.name = "露崎 まひる"
        mahiru.nameAbbr = "露"
        mahiru.memberColor = UIColor(hex: "61BF99")
        mahiru.subordinates = shoujokageki
        
        let nana = SNCharacter(context: context)
        nana.name = "大場 なな"
        nana.nameAbbr = "蕉"
        nana.memberColor = UIColor(hex: "FDD162")
        nana.subordinates = shoujokageki
        
        let kuro = SNCharacter(context: context)
        kuro.name = "西條 クロディーヌ"
        kuro.nameAbbr = "克"
        kuro.memberColor = UIColor(hex: "FE9952")
        kuro.subordinates = shoujokageki
        
        let futaba = SNCharacter(context: context)
        futaba.name = "石動 双葉"
        futaba.nameAbbr = "叶"
        futaba.memberColor = UIColor(hex: "8C67AA")
        futaba.subordinates = shoujokageki
        
        let kaoruko = SNCharacter(context: context)
        kaoruko.name = "花柳 香子"
        kaoruko.nameAbbr = "花"
        kaoruko.memberColor = UIColor(hex: "E08696")
        kaoruko.subordinates = shoujokageki
        
        
        if context.hasChanges{
            try? context.save()
        }
    }
}


