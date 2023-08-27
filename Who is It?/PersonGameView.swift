//
//  PersonView.swift
//  whos that
//
//  Created by Jakub Górka on 24/07/2022.
//

import SwiftUI

struct PersonImage: View{
    @State var image: UIImage
    var body: some View{
        GeometryReader{ proxy in
            HStack{
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: proxy.size.height, height: proxy.size.height)
                Spacer()
            }
        }
    }
}

struct PersonView: View {
    
    @ObservedObject var person: Person
    @State var choosen: Bool
    @State var hidden: Bool

    init(person: Person) {
        self.person = person
        choosen = person.choosen
        hidden = person.hidden
    }

    var body: some View {
        GeometryReader{ proxy in
        
            VStack(alignment: .center){
                ZStack{
                    if choosen{
                        Circle()
                            .stroke(Color.green, lineWidth: 4)
                    }
                    
                    if !hidden{
                        PersonImage(image: person.getUIImage())
                    }
                    else{
                        Circle()
                            .foregroundColor(Color.secondary)
                    }
                }
                Text(person.name)
                    .font(.system(size: 10))
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            
        }
        .onTapGesture {
            print("Zamknięto \(person.name)")
            person.hidden.toggle()
            hidden.toggle()
        }
    
        .onLongPressGesture(perform: {
            print("Wybrano \(person.name)")
            person.choosen.toggle()
            choosen.toggle()
        })

    }
}
