//
//  MovementViewModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

class MovementViewModel: ObservableObject {

    var context: NSManagedObjectContext
    @ObservedObject var projectViewModel: ProjectViewModel
    
    var currentFormation: SNFormation? {
        projectViewModel.currentProject?.aggregatesFormation
    }
    
    var charactersRequest: NSFetchRequest<SNCharacter> {
        let charactersRequest = NSFetchRequest<SNCharacter>(entityName: "SNCharacter")
        if self.projectViewModel.currentProject != nil && self.projectViewModel.currentProject?.aggregatesFormation != nil {
            charactersRequest.predicate = NSPredicate(format: "subordinates = %@", argumentArray: [projectViewModel.currentProject!.aggregatesFormation!.madeFor!.subordinatesKikaku!])
        } else {
             charactersRequest.predicate = NSPredicate(format: "FALSEPREDICATE")
        }
        charactersRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return charactersRequest
    }
    
    var allFormationsRequest: NSFetchRequest<SNFormation> {
        let allFormationsRequest = NSFetchRequest<SNFormation>(entityName: "SNFormation")
        allFormationsRequest.predicate = NSPredicate(format: "TRUEPREDICATE")
        allFormationsRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return allFormationsRequest
    }

    var allMovementsForProjectRequest: NSFetchRequest<SNMovement> {
        let allMovementsForProjectRequest = NSFetchRequest<SNMovement>(entityName: "SNMovement")
        allMovementsForProjectRequest.predicate = NSPredicate(format: "compositedBy = %@", argumentArray: [currentFormation])
        allMovementsForProjectRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        return allMovementsForProjectRequest
    }
    
    
    
    init(context: NSManagedObjectContext, projectViewModel: ProjectViewModel) {
        self.context = context
        self.projectViewModel = projectViewModel
        
    }
    
    func addFormation(name: String, author: String, aggregatedBy: NSSet?, madeFor: SNSong?) -> SNFormation {
            let formation = SNFormation(context: self.context)
            formation.id = UUID()
            formation.name = name
            formation.author = author
            
    //        if aggregatedBy != nil {
    //            formation.addToAggregatedBy(aggregatedBy!)
    //        } else {
    //            print("Error")
    //        }
            
            formation.aggregatedBy = aggregatedBy
            formation.madeFor = madeFor
            
            try? self.context.save()
            return formation
        }
        
        func updateFormation(formation: SNFormation) -> Void {
        }
        
        func deleteFormation(formation: SNFormation) -> Void {
            context.delete(formation)
            try? self.context.save()
        }
        
        func selectCurrentFormation(currentFormation: SNFormation?) -> Void {
            if self.projectViewModel.currentProject?.aggregatesFormation == currentFormation {
                self.projectViewModel.currentProject?.aggregatesFormation = nil
                print("currentFormation unselected.")
            } else {
                self.projectViewModel.currentProject?.aggregatesFormation = currentFormation
                print("currentFormation selected.")
            }
        }
        
        func addMovement() -> SNMovement? {
            if currentFormation != nil {
                let movement = SNMovement(context: self.context)
                movement.id = UUID()
                movement.startTime = Date()
                movement.compositedBy = currentFormation
                try? self.context.save()
                return movement
            } else {
                return nil
            }
        }
        
        func deleteMovement(movement: SNMovement) -> Void {
            context.delete(movement)
            try? context.save()
        }

}
