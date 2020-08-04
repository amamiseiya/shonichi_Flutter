//
//  FormationEditorView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//struct FormationEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormationEditorView(formationViewModel: FormationViewModel(projectViewModel: ProjectViewModel()))
//    }
//}


struct FormationEditorView: View {

    @Environment(\.managedObjectContext) var context
    @ObservedObject var formationViewModel: FormationViewModel
    @State private var popoverAddIsShowing: Bool = false
    @FetchRequest var allFormationsForProjectResults: FetchedResults<SNFormation>
    @FetchRequest var charactersResults: FetchedResults<SNCharacter>
    
    init(formationViewModel: FormationViewModel) {
        self.formationViewModel = formationViewModel
        self._allFormationsForProjectResults = FetchRequest(fetchRequest: formationViewModel.allFormationsForProjectRequest)
        self._charactersResults = FetchRequest(fetchRequest: formationViewModel.charactersRequest)
    }
    
    var body: some View {
        HStack {
            CharacterSelector
            FormationSelector
        }
    }


    private var CharacterSelector: some View {
        List {
            if formationViewModel.currentFormationTable != nil {
                ForEach(charactersResults) { character in
                    Button(action: {}){
                        Text(character.name!)
                    }
                }
            }
        }
    }


    private var FormationSelector: some View {
        List {
            ForEach(allFormationsForProjectResults) { (formation: SNFormation) in
                Button(action: {}){
                    Text(formation.startTime!.description)
                }
            }
        }

    }
}

    
