//
//  ProfileEditorView.swift
//  who is it
//
//  Created by Jakub Górka on 22/05/2023.
//

import SwiftUI
import PhotosUI

struct ProfileEditorView: View {

    @ObservedObject var person: Person
    @State var setId: String

    @Environment(\.presentationMode) var presentationMode
    @State private var pickerImageData: PhotosPickerItem?
    @State var pickerImage: Image?
    @State var name: String = ""


    var body: some View {
        GeometryReader{ proxy in
            VStack(alignment: .center){
                
                Spacer()
                
                PhotosPicker(selection: $pickerImageData, matching: .images) {
                    if let pickerImage{
                        pickerImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                    else{
                        Image(uiImage: person.getUIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                }
                .frame(width: proxy.size.width*0.5, height: proxy.size.width*0.5)
                .onChange(of: pickerImageData) { _ in
                            Task {
                                if let data = try? await pickerImageData?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        pickerImage = Image(uiImage: uiImage)
                                        return
                                    }
                                    
                                }

                                print("Failed")
                            }
                        }
                
                Spacer()
                
                TextField("Imię", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .bold()
                    .font(.title)
                    .frame(width: proxy.size.width*0.7)
                    .multilineTextAlignment(.center)
                    .onAppear{
                        self.name = person.name
                    }

                Spacer()
                                
                Button {

                    Task{
                        if let data = try? await pickerImageData?.loadTransferable(type: Data.self) {
                            
                            let compressedImage = UIImage(data: data)?.jpegData(compressionQuality: 0.1)
                            person.imageData = compressedImage!.base64EncodedString()
                            person.name = name
                            await person.modifyPerson(setId: setId)
//                            personsStorageManager.updateAppStorage()
                            presentationMode.wrappedValue.dismiss()

                        }
                        else{
                            person.name = name
//                            personsStorageManager.updateAppStorage()
                            await person.modifyPerson(setId: setId)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: proxy.size.width*0.65, height: proxy.size.height*0.05)
                            .foregroundColor(.green)
                        Text("Save :)")
                            .foregroundColor(.white)
                            .bold()

                    }
                        .padding(.bottom, proxy.size.height*0.05)

                }


                Spacer()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
//            .navigationBarBackButtonHidden(true)
        }
    }
}

