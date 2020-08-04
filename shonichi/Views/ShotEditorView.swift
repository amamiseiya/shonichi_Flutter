//
//  ShotEditorView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/7/9.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//struct ShotEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShotEditorView()
//    }
//}


struct ShotEditorView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var projectViewModel: ProjectViewModel
    @ObservedObject var shotViewModel: ShotViewModel
    @ObservedObject var songViewModel: SongViewModel
    @State private var shotTableEditSheetIsShowing: Bool = false
    @FetchRequest var allShotTablesForProjectResults: FetchedResults<SNShotTable>
    @FetchRequest var allShotsForProjectResults: FetchedResults<SNShot>
    
    init(projectViewModel: ProjectViewModel, shotViewModel: ShotViewModel, songViewModel: SongViewModel) {
        self.projectViewModel = projectViewModel
        self.shotViewModel = shotViewModel
        self.songViewModel = songViewModel
        self._allShotTablesForProjectResults = FetchRequest(fetchRequest: shotViewModel.allShotTablesForSongRequest)
        self._allShotsForProjectResults = FetchRequest(fetchRequest: shotViewModel.allShotsForProjectRequest)
    }
    
    var body: some View {
        NavigationView{
            shotTableList
            Divider()
            shotList.navigationBarItems(trailing: HStack {
                Button(action:{self.shotTableEditSheetIsShowing = true}) {Image(systemName: "plus").imageScale(.large)}.fixedSize()
                Button(action:{self.shotViewModel.addShot()}) {Image(systemName: "plus").imageScale(.large)}.fixedSize()
            })
        }.sheet(isPresented: $shotTableEditSheetIsShowing) { ShotTableEditSheet(isShowing: self.$shotTableEditSheetIsShowing, projectViewModel: self.projectViewModel,shotViewModel: self.shotViewModel, songViewModel: self.songViewModel, shotTable: nil).environment(\.managedObjectContext, self.context)
        }
    }
    
    var shotTableList: some View {
        GeometryReader{ geometry in
            List {
                ForEach(self.allShotTablesForProjectResults) { (shotTable: SNShotTable) in
                    Text(shotTable.name ?? "Undefined")
                    .onTapGesture {
                        self.shotViewModel.selectCurrentShotTable(currentShotTable: shotTable)
                    }
                }
                .onDelete { indexSet in indexSet.map {
                    self.allShotTablesForProjectResults[$0]
                    }.forEach{ self.shotViewModel.deleteShotTable(shotTable: $0) }
                }
            }
        }
    }
    
    var shotList: some View {
        List {
            ForEach(self.allShotsForProjectResults) { shot in
                ShotItem(shot: shot)
            }.onDelete { indexSet in indexSet.map {
                self.allShotsForProjectResults[$0]
                }.forEach{ self.shotViewModel.deleteShot(shot: $0) }
            }
        }
    }
}

struct ShotTableEditSheet: View {
    @Environment(\.managedObjectContext) var context
    
    @Binding var isShowing: Bool
//    @State private var isEditing: Bool
    @FetchRequest var allSongsResults: FetchedResults<SNSong>
    var projectViewModel: ProjectViewModel
    var shotViewModel: ShotViewModel
    var songViewModel: SongViewModel
    
    @State private var name: String = ""
    @State private var author: String = ""
    @State private var aggregatedBy: NSSet?
    @State private var madeFor: SNSong?
    
    
    init(isShowing: Binding<Bool>, projectViewModel: ProjectViewModel,shotViewModel: ShotViewModel, songViewModel: SongViewModel, shotTable: SNShotTable?) {
        self._isShowing = isShowing
        self.projectViewModel = projectViewModel
        self.shotViewModel = shotViewModel
        self.songViewModel = songViewModel
        self._allSongsResults = FetchRequest(fetchRequest: songViewModel.allSongsRequest)
        if shotTable != nil {
            self.name = shotTable!.name!
            self.author = shotTable!.author!
            self.aggregatedBy = shotTable!.aggregatedBy
            self.madeFor = shotTable!.madeFor
        }
    }
       
    var body: some View {
        NavigationView {
           Form {
            Section(header: Text("Properties")) {
                TextField("ShotTable Name", text: $name)
                TextField("Author Name", text: $author)
            }
            Section(header: Text("Related Entities"), footer: EditButton()) {
                Group {
                    Text("Undefined")
                }.onTapGesture {
                    self.madeFor = nil
                }
                Group {
                    Text("Use project setting: " + (projectViewModel.currentProject?.aggregatesSong?.name ?? "Undefined") )
                }.onTapGesture {
                    self.madeFor = self.projectViewModel.currentProject?.aggregatesSong
                }
                HStack {
                    NavigationLink(destination: EditSongSheet(songViewModel: songViewModel)){
                        Text("Add song")
                    }
                }
                List {
                    ForEach(allSongsResults) {song in
                        NormalSongViewLite(name: song.name).onTapGesture {
                            print("relatedSong selected.")
                            self.madeFor = song
                        }
                    }
                }
            }
           }.navigationBarItems(leading: Button(action: {self.isShowing = false}){Text("Cancel")}, trailing: Button(action: {
            if !self.name.isEmpty && !self.author.isEmpty {
                self.shotViewModel.addShotTable(name: self.name, author: self.author, aggregatedBy: self.aggregatedBy, madeFor: self.madeFor)
                self.isShowing = false
            }
           }) { Text("Done")})
        }
    }
}


struct ShotItem: View {
    var shot: SNShot
    
    var body: some View {
        HStack {
            Text(shot.startTime!.description)
            Text(shot.id!.description)
        }
    }
}
