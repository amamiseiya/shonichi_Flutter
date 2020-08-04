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

    // ! 有问题
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
    
// MARK: Intent
    
    func addSong(name: String) -> SNSong {
        let song = SNSong(context: context)
        song.id = UUID()
        song.name = name
        
        try? self.context.save()
        return song
        
    }
    
    func updateSong(song: SNSong) -> Void {
        
    }
    
    func deleteSong(song: SNSong) -> Void {
        context.delete(song)
        try? context.save()
    }
    
    func selectCurrentSong(currentSong: SNSong?) -> Void {
        if self.projectViewModel.currentProject?.aggregatesSong == currentSong {
            self.currentSong = nil
            print("currentSong unselected.")
        } else {
            self.currentSong = currentSong
            print("currentSong selected.")
        }
    }
    
    func addLyric(text: String) -> SNLyric {
        let lyric = SNLyric(context: context)
        lyric.id = UUID()
        lyric.text = text
        
        try? self.context.save()
        return lyric
        
    }
    
    func updateLyric(lyric: SNLyric) -> Void {
        
    }
    
    func deleteLyric(lyric: SNLyric) -> Void {
        context.delete(lyric)
        try? context.save()
    }
    
}
