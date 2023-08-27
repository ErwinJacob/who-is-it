//
//  HelpView.swift
//  who is it
//
//  Created by Jakub Górka on 24/05/2023.
//

import SwiftUI

struct HelpView: View {
    
    @AppStorage("showhelp") var showHelpStorage: Bool = true
    @State var showHelp: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if showHelp && showHelpStorage{
            GeometryReader{ proxy in
                ZStack{
                    colorScheme == .dark ? Color.black : Color.white
//                        .opacity(0.1)
                    VStack{
                                                
                        Spacer()
                        
                        Image(systemName: "iphone.gen2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: proxy.size.width*0.1)
                        Text("In Portrait mode You can modify your set")
                        
                        
                        Image(systemName: "iphone.gen2.landscape")
                            .resizable()
                            .scaledToFit()
                            .frame(height: proxy.size.width*0.1)
                        Text("Use Landscape mode to play")
                        Text("Tap Person to hide it")
                        Text("Hold Person to pick it as yours")
                        
                        Spacer()
                        
                        Button {
                            //ok, hide help
                            showHelp = false
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: proxy.size.width*0.65, height: proxy.size.height*0.05)
                                Text("Ok :)")
                                    .foregroundColor(.white)
                                    .bold()
                                
                            }
                        }
                        
                        Button {
                            //dont show again
                            showHelpStorage = false
                            showHelp = false
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: proxy.size.width*0.65, height: proxy.size.height*0.05)
                                Text("Don't show again :)")
                                    .foregroundColor(.white)
                                    .bold()
                                
                            }                    }
                        .padding(.bottom, proxy.size.height*0.05)
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .ignoresSafeArea()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
