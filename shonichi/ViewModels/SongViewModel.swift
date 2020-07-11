//
//  SongViewModel.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

class SongViewModel: ObservableObject {
    
    var context: NSManagedObjectContext
    @ObservedObject var projectViewModel: ProjectViewModel
    var currentSong: SNSong?
    
    var allSongsRequest: NSFetchRequest<SNSong> {
        let allSongsRequest = NSFetchRequest<SNSong>(entityName: "SNSong")
        allSongsRequest.predicate = NSPredicate(format: "TRUEPREDICATE")
        allSongsRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return allSongsRequest
    }

    var allLyricsForSongRequest: NSFetchRequest<SNLyric> {
        let allLyricsForSongRequest = NSFetchRequest<SNLyric>(entityName: "SNLyric")
        allLyricsForSongRequest.predicate = NSPredicate(format: "compositedBy = %@", argumentArray: [projectViewModel.currentProject?.aggregatesSong])
        allLyricsForSongRequest.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: true)]
        return allLyricsForSongRequest
    }
    
    
    init(context: NSManagedObjectContext, projectViewModel: ProjectViewModel) {
        self.context = context
        self.projectViewModel = projectViewModel
    }
    
    func addSong(name: String) -> Void {
        let song = SNSong(context: context)
        song.id = UUID()
        song.name = name
        
        try? self.context.save()
        
    }
    
    func deleteSong() -> Void {
        
        
    }
}
