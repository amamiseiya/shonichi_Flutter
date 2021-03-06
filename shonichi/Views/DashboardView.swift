//
//  ContentView.swift
//  shonichi
//
//  Created by 黄彦璋 on 2020/6/30.
//  Copyright © 2020 seiya studio. All rights reserved.
//

import SwiftUI
import CoreData

//struct ContentView_Previews: PreviewProvider {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let projectViewModel = ProjectViewModel(context: context)
//    let shotViewModel = ShotViewModel(context: context, projectViewModel: projectViewModel)
//    let songViewModel = SongViewModel(context: context, projectViewModel: projectViewModel)
//    let movementViewModel = MovementViewModel(context: context, projectViewModel: projectViewModel)
//    static var previews: some View {
//        DashboardView(projectViewModel: projectViewModel, shotViewModel: shotViewModel, songViewModel: songViewModel, movementViewModel: movementViewModel).environment(\.managedObjectContext, context)
//    }
//}

struct DashboardView: View {
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var projectViewModel: ProjectViewModel
    @ObservedObject var shotViewModel: ShotViewModel
    @ObservedObject var songViewModel: SongViewModel
    @ObservedObject var movementViewModel: MovementViewModel
    @ObservedObject var characterViewModel: CharacterViewModel
    @ObservedObject var migratorViewModel: MigratorViewModel
    
    @State private var editSheetIsShowing: Bool = false
    @FetchRequest var allProjectsResults: FetchedResults<SNProject>
    
    init(projectViewModel: ProjectViewModel, shotViewModel: ShotViewModel, songViewModel: SongViewModel, movementViewModel: MovementViewModel, characterViewModel: CharacterViewModel, migratorViewModel: MigratorViewModel) {
        self.projectViewModel = projectViewModel
        self.shotViewModel = shotViewModel
        self.songViewModel = songViewModel
        self.movementViewModel = movementViewModel
        self.characterViewModel = characterViewModel
        self.migratorViewModel = migratorViewModel
        self._allProjectsResults = FetchRequest(fetchRequest: projectViewModel.allProjectsRequest)
    }
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("お帰りなさい♪")
                LatestProjectView
                    .listRowBackground((self.projectViewModel.currentProject == self.allProjectsResults.first) ? Color.blue : Color.white)
                    .onTapGesture {
                        self.projectViewModel.selectCurrentProject(currentProject: self.allProjectsResults.first)
                    }
                List {
                    if allProjectsResults.count > 1 {
                        ForEach(self.allProjectsResults) { project in
                            Button(action: { self.projectViewModel.selectCurrentProject(currentProject: project)}){
                                NormalProjectView(project: project)}
//                            .onTapGesture {
//                                self.projectViewModel.selectCurrentProject(currentProject: project)
//                            }
                                .buttonStyle(projectButtonStyle(currentProject: self.projectViewModel.currentProject, project: project))
                        }.onDelete { indexSet in indexSet.map {
                        self.allProjectsResults[$0]
                        }.forEach{ self.projectViewModel.deleteProject(project: $0) }
                    }
                    }
                }
                List {
                    NavigationLink(destination: ShotEditorView(projectViewModel: projectViewModel, shotViewModel: shotViewModel, songViewModel: songViewModel)) {
                        Text("SNShot Editor")
                    }
                    NavigationLink(destination: SongEditorView(songViewModel: songViewModel)) {
                        Text("SNSong Editor")
                    }
                    NavigationLink(destination: MovementEditorView(movementViewModel: movementViewModel)) {
                        Text("SNMovement Editor")
                    }
                    NavigationLink(destination: ModelView(characterViewModel: characterViewModel)) {
                        Text("Model Viewer")
                    }
                    NavigationLink(destination: MigratorView(migratorViewModel: migratorViewModel)) {
                        Text("Migrator")
                    }
                }
            }.padding(.all, 15.0)
            .navigationBarItems(trailing: HStack {
                Button(action:{}){Image(systemName: "arrow.clockwise").imageScale(.large)}.fixedSize()
                Button(action:{self.editSheetIsShowing = true}){Image(systemName: "plus").imageScale(.large)}.fixedSize()
                }
            ).sheet(isPresented: $editSheetIsShowing) { ProjectEditSheet(isShowing: self.$editSheetIsShowing, projectViewModel: self.projectViewModel, songViewModel: self.songViewModel, project: nil).environment(\.managedObjectContext, self.context)
            }
        }
    }
    
    var LatestProjectView: some View {
        return Group {
            if !self.allProjectsResults.isEmpty {
                VStack {
                    Text("Current project:")
                    Text((allProjectsResults.first!.aggregatesSong?.name ?? "Undefined") + " with \(allProjectsResults.first!.dancerName!)")
                }
            } else {
                Text("No project.")
            }
        }
    }
    
    struct NormalProjectView: View {
        
        var project: SNProject
        
        var body: some View {
            GeometryReader { _ in
                VStack(alignment: .leading) {
                    Text((self.project.aggregatesSong?.name ?? "Undefined") + " with \(self.project.dancerName!)")
                   Text("Created:")
                    Text(self.project.createdTime!.description)
                }
            }
        }
    }
}

struct projectButtonStyle: ButtonStyle {
    
    @State var currentProject: SNProject?
    @State var project: SNProject
    
    public func makeBody(configuration: projectButtonStyle.Configuration) -> some View {
        configuration.label
            .background(RoundedRectangle(cornerRadius: 5).fill(currentProject == project ? Color.blue : Color.white))
            .padding(15)
    }
}

struct ProjectEditSheet: View {
    @Environment(\.managedObjectContext) var context
    
    @Binding var isShowing: Bool
//    @State private var isEditing: Bool
    @FetchRequest var allSongsResults: FetchedResults<SNSong>
    var projectViewModel: ProjectViewModel
    var songViewModel: SongViewModel
    
    @State private var dancerName: String = ""
    @State private var relatedSong: SNSong?
    
    
    init(isShowing: Binding<Bool>, projectViewModel: ProjectViewModel, songViewModel: SongViewModel, project: SNProject?) {
        self._isShowing = isShowing
        self.projectViewModel = projectViewModel
        self.songViewModel = songViewModel
        self._allSongsResults = FetchRequest(fetchRequest: songViewModel.allSongsRequest)
        if project != nil {
            self.dancerName = project!.dancerName!
        }
    }
       
    var body: some View {
        NavigationView {
           Form {
            Section(header: Text("Properties")) {
                TextField("Dancer Name", text: $dancerName)
            }
            Section(header: Text("Related Entities"), footer: EditButton()) {
                Group {
                    Text("Undefined")
                }.onTapGesture {
                    self.relatedSong = nil
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
                            self.relatedSong = song
                        }
                    }
                }
            }
           }.navigationBarItems(leading: Button(action: {self.isShowing = false}){Text("Cancel")}, trailing: Button(action: {
            if !self.dancerName.isEmpty {
                self.projectViewModel.addProject(dancerName: self.dancerName,relatedSong: self.relatedSong)
                self.isShowing = false
            }
           }) { Text("Done")})
        }
    }
}

struct NormalSongViewLite: View {
    var name: String?
    
    var body: some View {
        Group {
            VStack {
            Text(name!)
            }
        }
    }
}
