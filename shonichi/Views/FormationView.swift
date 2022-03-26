//
//  MovementEditorView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//struct MovementEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovementEditorView(movementViewModel: MovementViewModel(projectViewModel: ProjectViewModel()))
//    }
//}


struct MovementEditorView: View {

    @Environment(\.managedObjectContext) var context
    @ObservedObject var movementViewModel: MovementViewModel
    @State private var popoverAddIsShowing: Bool = false
    @FetchRequest var allMovementsForProjectResults: FetchedResults<SNMovement>
    @FetchRequest var charactersResults: FetchedResults<SNCharacter>
    
    init(movementViewModel: MovementViewModel) {
        self.movementViewModel = movementViewModel
        self._allMovementsForProjectResults = FetchRequest(fetchRequest: movementViewModel.allMovementsForProjectRequest)
        self._charactersResults = FetchRequest(fetchRequest: movementViewModel.charactersRequest)
    }
    
    var body: some View {
        HStack {
            CharacterSelector
            MovementSelector
        }
    }


    private var CharacterSelector: some View {
        List {
            if movementViewModel.currentFormation != nil {
                ForEach(charactersResults) { character in
                    Button(action: {}){
                        Text(character.name!)
                    }
                }
            }
        }
    }


    private var MovementSelector: some View {
        List {
            ForEach(allMovementsForProjectResults) { (movement: SNMovement) in
                Button(action: {}){
                    Text(movement.startTime!.description)
                }
            }
        }

    }
}

    
