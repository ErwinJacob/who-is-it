//
//  EditView.swift
//  who is it
//
//  Created by Jakub Górka on 22/05/2023.
//

import SwiftUI

struct EditView: View {
        
    @ObservedObject var system: System
    @ObservedObject var view: ViewController
    @ObservedObject var gameSet: GameSet
//    @Environment(\.colorScheme) var colorScheme
    
    @State var showChangeNameAlert = false
    @State var newName: String = ""

    @State var showDeleteConfimation: Bool = false
    
    var body: some View {
        NavigationView{
            GeometryReader{ proxy in
                VStack{
                    HStack{
                        
                        Button {
                            view.listView()
                        } label: {
                            Image(systemName: "arrowshape.backward.fill")
                                .resizable()
                        }
                        .frame(width: proxy.size.height*0.035, height: proxy.size.height*0.035)
                        .foregroundColor(Color.primary)
                        
                        Spacer()
                        
                        Button {
                            showChangeNameAlert = true
                        } label: {
                            Text(gameSet.name)
                                .font(.title)
                                .bold()
                                .foregroundStyle(Color.primary)
                        }
                        .alert("Enter new name", isPresented: $showChangeNameAlert) {
                            TextField("Enter your name", text: $newName)
                            Button("OK", action: {
                                Task{
                                    await gameSet.modifySetName(newName: newName)
                                }
                            })
                        }
                        
                        Spacer()
                        
                        Button {
                            showDeleteConfimation = true
                            
                        } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                        }
                        .frame(width: proxy.size.height*0.035, height: proxy.size.height*0.035)
                        .foregroundColor(Color.primary)
                        .confirmationDialog("Are you sure?",isPresented: $showDeleteConfimation) {
                            Button("Are you sure to delete this set?", role: .destructive) {
                                Task{
                                    await system.deleteSet(setId: gameSet.id)
                                    view.listView()
                                }
                            }
                        }
                    }
                    .frame(width: proxy.size.width*0.85, height: proxy.size.height*0.075)
                    
                    ScrollView {
                        ForEach(gameSet.persons.sorted(by: { Int($0.id)! < Int($1.id)! })) { person in
                            NavigationLink(destination: ProfileEditorView(person: person, setId: gameSet.id)) {
                                PersonEditorView(person: person)
                                    .padding(.horizontal, proxy.size.width * 0.05)
                            }
                            .frame(width: proxy.size.width, height: proxy.size.width * 0.4)
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height*0.925)
                    .refreshable {
                        await gameSet.fetchData()
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
    }
    
}

struct PersonEditorView: View{
    
    @ObservedObject var person: Person
    @Environment(\.colorScheme) var colorScheme

    var body: some View{
        GeometryReader{ proxy in
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .opacity(0.05)
                
                HStack{
                    Image(uiImage: person.getUIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(width: proxy.size.width*0.35, height: proxy.size.width*0.35)
                    Spacer()
                    Text(person.name)
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    Spacer()
                }
                .padding(.horizontal, proxy.size.width*0.05)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}
