//
//  CharacterModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData
import UIKit


enum Kikaku: String {
    case loveLive
    case loveLiveSunshine
    case revueStarlight
    case akb48
}

enum Grade {
    case ichi
    case ni
    case san
}

enum LLGroup {
    case printemps
    case bibi
    case lilyWhite
}

enum LLSSGroup {
    case cyaron
    case azalea
    case guiltyKiss
}

extension SNKikaku: Identifiable {
    
}

extension SNCharacter: Identifiable {
    
}

class characterTransformer: ValueTransformer {
    
}

// https://qiita.com/Kyome/items/eae6216b13c651254f64
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}
