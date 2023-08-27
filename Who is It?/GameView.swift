//
//  GameView.swift
//  who is it
//
//  Created by Jakub Górka on 23/05/2023.
//

import SwiftUI

struct GameView: View {
    
//    @ObservedObject var personsStorageManager: PersonsStorageManager
    @ObservedObject var gameSet: GameSet

    var body: some View {
        GeometryReader{ proxy in //jezeli zdjecie jest wieksze niz wielkosc personview to sie buguje
            VStack {
                Spacer()
                HStack(spacing: proxy.size.width*0.02){
                    ForEach(Array(gameSet.persons.sorted(by: { Int($0.id)! < Int($1.id)! }).enumerated()), id: \.element.id) { index, person in
                        if index%4 == 0{
                            PersonView(person: person)
                                .frame(width: proxy.size.width*0.1, height: proxy.size.height*0.2)
                        }
                    }
                }
                
                HStack(spacing: proxy.size.width*0.02){
                    ForEach(Array(gameSet.persons.sorted(by: { Int($0.id)! < Int($1.id)! }).enumerated()), id: \.element.id) { index, person in
                        if index%4 == 1{
                            PersonView(person: person)
                                .frame(width: proxy.size.width*0.1, height: proxy.size.height*0.2)
                        }
                    }
                }

                HStack(spacing: proxy.size.width*0.02){
                    ForEach(Array(gameSet.persons.sorted(by: { Int($0.id)! < Int($1.id)! }).enumerated()), id: \.element.id) { index, person in
                        if index%4 == 2{
                            PersonView(person: person)
                                .frame(width: proxy.size.width*0.1, height: proxy.size.height*0.2)
                        }
                    }
                }

                HStack(spacing: proxy.size.width*0.02){
                    ForEach(Array(gameSet.persons.sorted(by: { Int($0.id)! < Int($1.id)! }).enumerated()), id: \.element.id) { index, person in
                        if index%4 == 3{
                            PersonView(person: person)
                                .frame(width: proxy.size.width*0.1, height: proxy.size.height*0.2)
                        }
                    }
                }

                Spacer()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            
        }
    }
}

