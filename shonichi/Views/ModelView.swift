//
//  ModelView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/13.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

struct ModelView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest var allKikakusResults: FetchedResults<SNKikaku>
    @FetchRequest var allCharactersResults: FetchedResults<SNCharacter>
    
    var characterViewModel: CharacterViewModel
    
    init(characterViewModel: CharacterViewModel) {
        self.characterViewModel = characterViewModel
        self._allKikakusResults = FetchRequest(fetchRequest: characterViewModel.allKikakusRequest)
        self._allCharactersResults = FetchRequest(fetchRequest: characterViewModel.allCharactersRequest)
    }
    
    var body: some View {
        List {
            ForEach(allKikakusResults){ (kikaku: SNKikaku) in
                Text(kikaku.name ?? "Error")
            }
            Divider()
            ForEach(allCharactersResults){ (character: SNCharacter) in
                VStack {
                    Text(character.name ?? "Error")
                    Text(character.subordinates!.name ?? "Error")
//                    Color(character.memberColor as! UIColor)
                }
            }
        }
    }
}
