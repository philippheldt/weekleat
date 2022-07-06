//
//  RezeptSammlung_ViewModel.swift
//  weekleat
//
//  Created by Philipp Jenny on 06.07.22.
//

import Foundation
import CoreData

extension RezeptSammlung {
    @MainActor class ViewModel: ObservableObject {
        @Published var passRecipie: Recipie? = nil
        @Published var showingAddScreen = false
        @Published var showingEditScreen = false
        @Published var currentLetter = ""
        @Published var searchText = ""
        
        @Published var dummyRezepte = Rezepte.dummyRezepte
        
        @Published var recipies: [Recipie] = []
        
        let container = NSPersistentContainer(name: "Weekleat")
        
        init() {
            container.loadPersistentStores{ description, error in
                if let error = error {
                    print("Core Data failed to load: \(error.localizedDescription)")
                }
            }
            fetchRecipies()
        }

        
        func fetchRecipies() {
            let request = NSFetchRequest<Recipie>(entityName: "Recipie")
            
            do{
                recipies = try container.viewContext.fetch(request)
            } catch let error {
                print("Error fetching. \(error)")
            }
            
        }
        
        func addRecipie() {
            // Alles, was ich vorher gemacht habe
            saveData()
        }
        
        func saveData() {
            do{
                try container.viewContext.save()
                fetchRecipies()
            } catch let error {
                print("Error saving. \(error)")
            }
          
        }
        
//        func deleteRecipie(recipie: Recipie) {
//                moc.delete(recipie)
//                try? moc.save()
//        }
        
        func editRecipie(recipie: Recipie) {
            passRecipie = recipie
            showingEditScreen.toggle()
        }
        
  
    }
}
