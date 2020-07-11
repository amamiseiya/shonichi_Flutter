//
//  FormationViewModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

class FormationViewModel: ObservableObject {

    var context: NSManagedObjectContext
    @ObservedObject var projectViewModel: ProjectViewModel
    
    var currentFormationTable: SNFormationTable? {
        projectViewModel.currentProject?.aggregatesFormationTable
    }
    
    var charactersRequest: NSFetchRequest<SNCharacter> {
        let charactersRequest = NSFetchRequest<SNCharacter>(entityName: "SNCharacter")
        if self.projectViewModel.currentProject != nil && self.projectViewModel.currentProject?.aggregatesFormationTable != nil {
            charactersRequest.predicate = NSPredicate(format: "subordinates = %@", argumentArray: [projectViewModel.currentProject!.aggregatesFormationTable!.madeFor!.subordinatesKikaku!])
        } else {
             charactersRequest.predicate = NSPredicate(format: "FALSEPREDICATE")
        }
        charactersRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return charactersRequest
    }
    
    var allFormationTablesRequest: NSFetchRequest<SNFormationTable> {
        let allFormationTablesRequest = NSFetchRequest<SNFormationTable>(entityName: "SNFormationTable")
        allFormationTablesRequest.predicate = NSPredicate(format: "TRUEPREDICATE")
        allFormationTablesRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return allFormationTablesRequest
    }

    var allFormationsForProjectRequest: NSFetchRequest<SNFormation> {
        let allFormationsForProjectRequest = NSFetchRequest<SNFormation>(entityName: "SNFormation")
        allFormationsForProjectRequest.predicate = NSPredicate(format: "compositedBy = %@", argumentArray: [currentFormationTable])
        allFormationsForProjectRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        return allFormationsForProjectRequest
    }
    
    
    
    init(context: NSManagedObjectContext, projectViewModel: ProjectViewModel) {
        self.context = context
        self.projectViewModel = projectViewModel
        
    }

}
