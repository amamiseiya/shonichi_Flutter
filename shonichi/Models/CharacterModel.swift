//
//  CharacterModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//// Deprecated
//struct SNCharacter: CustomStringConvertible {
//    var description: String {
//        return name
//    }
//
//    var name: String
//    var nameAbbr: String
//    var memberColor: Color
//    var subordinateKikaku: Kikaku
//
//}

struct LLCratacter {
    var grade: Grade
    var group: LLGroup
}


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

extension SNCharacter: Identifiable {
    
}

class characterTransformer: ValueTransformer {
    
}
