//
//  GameSet.swift
//  Who is It?
//
//  Created by Jakub Górka on 20/08/2023.
//

import Foundation
import SwiftUI
import Firebase

class System: ObservableObject {
    @Published var sets: [GameSet] = []
    @AppStorage("storedSets") private var storedSets: String = ""

    @MainActor
    func saveSets() {
        
        self.storedSets = ""
        
        self.sets.forEach { set in
            if storedSets != ""{
                storedSets += ","
            }
            storedSets += set.id
        }
        
        print(self.storedSets)
        
    }

    func loadSets(){
        
        let setsIDs = storedSets.split(separator: ",")
        
        setsIDs.forEach { id in
            print("Set id: \(id)")
            self.sets.append(GameSet(id: String(id)))
        }
        
    }
    
    func findSetByShortenedId(shortenedId: String, foundSet: @escaping (GameSet) -> Void) async{

        let db = Firestore.firestore()
        do{
            let docs = try await db.collection("Sets").getDocuments()
            docs.documents.forEach { data in
                let checkedId = data.documentID.prefix(shortenedId.count)
                if checkedId == shortenedId{
                    print("Found set: \(data.documentID)")

                    let found: GameSet = GameSet(id: data.documentID)
                    foundSet(found)
                }
            }

//            print("User not found")
//            userId("") //if use wasnt found
            
        }
        catch{
            print("Error while trying ")
        }
    }
    
    
    func createNewSet(setName: String) async{
        
        let newId = UUID().uuidString
        let newImage = UIImage(systemName: "person.fill")?.jpegData(compressionQuality: 0.1)!.base64EncodedString()

        self.sets.append(GameSet(id: newId, name: setName))
        
        let db = Firestore.firestore()
        let setPath = db.collection("Sets").document(newId)

        do{
            try await setPath.setData([
                "name": setName
            ])
            
            for i in 1...32{
                try await setPath.collection("Persons").document(String(i)).setData([
                    "name" : "Person \(i)",
                    "imageBlob": newImage
                ])
            }
        }
        catch{
            print("Error, while trying to add new set to Firebase\n\(newId)")
        }
        Task{
            await self.saveSets()
        }
    }
    
    func deleteSet(setId: String) async{
        let db = Firestore.firestore()
        do{
//            try await db.collection("Sets").document(setId).delete()
            
            let newSetsArray = self.sets.filter { $0.id != setId }
            self.sets = newSetsArray
            await self.saveSets()
        }
        catch{
            print("Error, while trying to delete set \(setId)")
        }

    }
    
    init() {
        loadSets() // Load sets when the System is initialized
    }
}

class GameSet: ObservableObject, Identifiable {
    @Published var name: String
    let id: String
    @Published var persons: [Person] = []
    
    init(id: String, name: String) { //init new Set
        self.id = id
        self.name = name
        
        let newImage = UIImage(systemName: "person.fill")?.jpegData(compressionQuality: 1.0)!.base64EncodedString()
        
        Task{
            for i in 1...32{
                await self.addPerson(image: newImage!, name: "Person \(i)", id: String(i))
            }
        }
    }
    
    init(id: String){
        self.id = id
        self.name = ""
        
        Task{
            await self.fetchData()
        }
    }
    
    @MainActor
    func modifySetName(newName: String) async{
        
        let db = Firestore.firestore()
        do{
            try await db.collection("Sets").document(self.id).setData([
                "name": newName
            ], merge: true)
            self.name = newName

        }
        catch{
            print("Error, while modifying name of set \(self.id)")
        }
    }
    
    @MainActor
    func fetchData() async{
        
        let errorImage = UIImage(systemName: "person.crop.circle.badge.exclamationmark.fill")?.jpegData(compressionQuality: 0.1)!.base64EncodedString()

        let db = Firestore.firestore()
        
        let setPath = db.collection("Sets").document(self.id)
        
        self.persons = []
        
        do{
            try await setPath.getDocument().data().map { data in
                self.name = data["name"] as? String ?? "name missing"
            }
            
            self.persons = try await setPath.collection("Persons").getDocuments().documents.map({ data in
                return Person(name: data["name"] as? String ?? "name missing",
                              imageData: data["imageBlob"] as? String ?? errorImage!,
                              id: data.documentID)
            })
            
        }
        catch{
            print("Error, while trying to fetch set \(self.id)")
        }
        
        
    }
    
    @MainActor
    func addPerson(image: String, name: String, id: String){
        persons.append(Person(name: name, imageData: image, id: id))
    }
    
}




class Person: Identifiable, ObservableObject, Hashable {
        
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    @Published var name: String
    @Published var imageData: String
    let id: String
    var choosen: Bool = false
    var hidden: Bool = false
    
    init(name: String, imageData: String, id: String) {
        self.name = name
        self.imageData = imageData
        self.id = id
    }
    
    @MainActor
    func modifyPerson(setId: String) async{
        
        let db = Firestore.firestore()
        do{
            try await db.collection("Sets").document(setId).collection("Persons").document(self.id).setData([
                "name": self.name,
                "imageBlob": self.imageData
            ])
        }
        catch{
            print("Error, while trying to modify person \(self.id) in set \(setId)")
        }
        
    }
    
    func getUIImage() -> UIImage{
        if let imgData = Data(base64Encoded: self.imageData, options: .ignoreUnknownCharacters){
            return UIImage(data: imgData)!
        }
        else{
            return UIImage(systemName: "person.fill")!
        }
    }
    
}

enum Views{
    case setView
    case listView
}

class ViewController: ObservableObject{
    
    @Published var view: Views = Views.listView
    @Published var set: GameSet?
    
    func setView(set: GameSet){
        self.view = Views.setView
        self.set = set
    }
    
    func listView(){
        self.view = Views.listView
        self.set = nil
    }
    
}
