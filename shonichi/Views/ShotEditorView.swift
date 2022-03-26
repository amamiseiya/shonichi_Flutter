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
//
//    var context: NSManagedObjectContext
//    var projectViewModel: ProjectViewModel
//    var shotViewModel: ShotViewModel
//    var songViewModel: SongViewModel
//    var shotEditorView_Previews: ShotEditorView
//
//    static var previews: some View {
//        shotEditorView_Previews
//    }
//
//    init() {
//        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        projectViewModel = ProjectViewModel(context: context)
//        shotViewModel = ShotViewModel(context: context, projectViewModel: projectViewModel)
//        songViewModel = SongViewModel(context: context, projectViewModel: projectViewModel)
//        shotEditorView_Previews = ShotEditorView(projectViewModel: projectViewModel, shotViewModel: shotViewModel, songViewModel: songViewModel)
//    }
//
//}


struct ShotEditorView: View {
    
    @Environment(\.managedObjectContext) var context
    @ObservedObject var projectViewModel: ProjectViewModel
    @ObservedObject var shotViewModel: ShotViewModel
    @ObservedObject var songViewModel: SongViewModel
    @State private var storyboardEditSheetIsShowing: Bool = false
    @FetchRequest var allStoryboardsForSongResults: FetchedResults<SNStoryboard>
    @FetchRequest var allShotsForProjectResults: FetchedResults<SNShot>
    @State private var storyboardSelection: SNStoryboard? = nil
    
    init(projectViewModel: ProjectViewModel, shotViewModel: ShotViewModel, songViewModel: SongViewModel) {
        self.projectViewModel = projectViewModel
        self.shotViewModel = shotViewModel
        self.songViewModel = songViewModel
        self._allStoryboardsForSongResults = FetchRequest(fetchRequest: shotViewModel.allStoryboardsForSongRequest)
        self._allShotsForProjectResults = FetchRequest(fetchRequest: shotViewModel.allShotsForProjectRequest)
    }
    
    var body: some View {
        NavigationView{
            storyboardList
            Divider()
            shotList.navigationBarItems(trailing: HStack {
                Button(action:{self.storyboardEditSheetIsShowing = true}) {Image(systemName: "plus").imageScale(.large)}.fixedSize()
                Button(action:{self.shotViewModel.addShot()}) {Image(systemName: "plus").imageScale(.large)}.fixedSize()
            })
        }.sheet(isPresented: $storyboardEditSheetIsShowing) { StoryboardEditSheet(isShowing: self.$storyboardEditSheetIsShowing, projectViewModel: self.projectViewModel,shotViewModel: self.shotViewModel, songViewModel: self.songViewModel, storyboard: nil).environment(\.managedObjectContext, self.context)
        }
    }
    
    var storyboardList: some View {
        GeometryReader{ geometry in
            List(selection: self.$storyboardSelection) {
                ForEach(self.allStoryboardsForSongResults) { (storyboard: SNStoryboard) in
                    Button(action:{
                        self.shotViewModel.selectCurrentStoryboard(currentStoryboard: storyboard)}){
                            GeometryReader { _ in
                                Text(storyboard.name ?? "Undefined")
                            }
                    }
//                    .onTapGesture {
//                        self.shotViewModel.selectCurrentStoryboard(currentStoryboard: storyboard)
//                    }
                    .buttonStyle(storyboardButtonStyle(currentStoryboard: self.shotViewModel.currentStoryboard, storyboard: storyboard))
                }
                .onDelete { indexSet in indexSet.map {
                    self.allStoryboardsForSongResults[$0]
                    }.forEach{ self.shotViewModel.deleteStoryboard(storyboard: $0) }
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


struct storyboardButtonStyle: ButtonStyle {
    
    @State var currentStoryboard: SNStoryboard?
    @State var storyboard: SNStoryboard
    
    public func makeBody(configuration: storyboardButtonStyle.Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 5).fill(currentStoryboard == storyboard ? Color.blue : Color.white))
            .padding(15)
            
    }
}

struct StoryboardEditSheet: View {
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
    
    
    init(isShowing: Binding<Bool>, projectViewModel: ProjectViewModel,shotViewModel: ShotViewModel, songViewModel: SongViewModel, storyboard: SNStoryboard?) {
        self._isShowing = isShowing
        self.projectViewModel = projectViewModel
        self.shotViewModel = shotViewModel
        self.songViewModel = songViewModel
        self._allSongsResults = FetchRequest(fetchRequest: songViewModel.allSongsRequest)
        if storyboard != nil {
            self.name = storyboard!.name!
            self.author = storyboard!.author!
            self.aggregatedBy = storyboard!.aggregatedBy
            self.madeFor = storyboard!.madeFor
        }
    }
       
    var body: some View {
        NavigationView {
           Form {
            Section(header: Text("Properties")) {
                TextField("Storyboard Name", text: $name)
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
                    NavigationLink(destination: EditSongSheet(songViewModel: songViewModel, isShowing: $isShowing)){
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
                self.shotViewModel.addStoryboard(name: self.name, author: self.author, aggregatedBy: self.aggregatedBy, madeFor: self.madeFor)
                self.isShowing = false
            }
           }) { Text("Done")})
        }
    }
}


struct ShotItem: View {
    var shot: SNShot
    
    @State private var text = ""
    
    init(shot: SNShot) {
        self.shot = shot
        text = shot.text ?? ""
    }
    
    var body: some View {
        HStack {
            Text(shot.startTime!.description)
            Text(shot.id!.description)
            TextField("Text", text: $text)
        }
    }
}
