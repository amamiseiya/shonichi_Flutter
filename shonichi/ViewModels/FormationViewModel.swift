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
    
    func addFormationTable(name: String, author: String, aggregatedBy: NSSet?, madeFor: SNSong?) -> SNFormationTable {
            let formationTable = SNFormationTable(context: self.context)
            formationTable.id = UUID()
            formationTable.name = name
            formationTable.author = author
            
    //        if aggregatedBy != nil {
    //            formationTable.addToAggregatedBy(aggregatedBy!)
    //        } else {
    //            print("Error")
    //        }
            
            formationTable.aggregatedBy = aggregatedBy
            formationTable.madeFor = madeFor
            
            try? self.context.save()
            return formationTable
        }
        
        func updateFormationTable(formationTable: SNFormationTable) -> Void {
        }
        
        func deleteFormationTable(formationTable: SNFormationTable) -> Void {
            context.delete(formationTable)
            try? self.context.save()
        }
        
        func selectCurrentFormationTable(currentFormationTable: SNFormationTable?) -> Void {
            if self.projectViewModel.currentProject?.aggregatesFormationTable == currentFormationTable {
                self.projectViewModel.currentProject?.aggregatesFormationTable = nil
                print("currentFormationTable unselected.")
            } else {
                self.projectViewModel.currentProject?.aggregatesFormationTable = currentFormationTable
                print("currentFormationTable selected.")
            }
        }
        
        func addFormation() -> SNFormation? {
            if currentFormationTable != nil {
                let formation = SNFormation(context: self.context)
                formation.id = UUID()
                formation.startTime = Date()
                formation.compositedBy = currentFormationTable
                try? self.context.save()
                return formation
            } else {
                return nil
            }
        }
        
        func deleteFormation(formation: SNFormation) -> Void {
            context.delete(formation)
            try? context.save()
        }

}
