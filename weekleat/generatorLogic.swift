//
//  generatorLogic.swift
//  weekleat
//
//  Created by Philipp Jenny on 01.08.22.
//

import Foundation
import SwiftUI

struct generatorLogic{
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.picked)]) var recipies: FetchedResults<Recipie>
    
    @AppStorage("nudeln") private var nudeln: String = "häufig"
    @AppStorage("reis") private var reis: String = "mittel"
    @AppStorage("kartoffeln") private var kartoffeln: String = "selten"
    @AppStorage("gebackenes") private var gebackenes: String = "selten"
    
    @AppStorage("vegetarisch") private var vegetarisch: Bool = false
    @AppStorage("vegan") private var vegan: Bool = false
    @AppStorage("fleisch")  private var fleisch: String = "selten"
    
    
    func generateRecipies(recipies: [Recipie]) -> [Recipie] {
        
        //Array within the function in which all the picked recipies are stored and later on saved to genaratedRecipies
        var tempGeneratedRecipies: [Recipie] = []
        var generatedRecipies: [Recipie] = []
        
        //All Arrays of food types
        var pastas: [Recipie] = []
        var pastasveg: [Recipie] = []
        var pastasmeat: [Recipie] = []
        
        var rices: [Recipie] = []
        var ricesveg: [Recipie] = []
        var ricesmeat: [Recipie] = []
        
        var potatoes: [Recipie] = []
        var potatoesveg: [Recipie] = []
        var potatoesmeat: [Recipie] = []
        
        var bakings: [Recipie] = []
        var bakingsveg: [Recipie] = []
        var bakingsmeat: [Recipie] = []
        
        var others: [Recipie] = []
        var othersveg: [Recipie] = []
        var othersmeat: [Recipie] = []
        
        //creating Array out of Tags -> adding the recipies to the correct array
        for recipie in recipies {
            let tagString = recipie.wrappedTags
            let tagArray = tagString.components(separatedBy: ",")
            
            for tag in tagArray{
                switch tag.lowercased() {
                case "nudeln":
                    pastas.append(recipie)
                    
                case "reis":
                    rices.append(recipie)
                    
                case "kartoffeln":
                    potatoes.append(recipie)
                    
                    
                case "gebackenes":
                    bakings.append(recipie)
                    
                default:
                    others.append(recipie)
                    
                }
            }
        }
        
        // Sorting Veggi and Meat
        
        if !pastas.isEmpty{
            for pasta in pastas {
                let tagString = pasta.wrappedTags
                if tagString.localizedCaseInsensitiveContains("vegetarisch") {
                    pastasveg.append(pasta)
                } else {
                    pastasmeat.append(pasta)
                }
            }
        }
        
        if !rices.isEmpty{
            for rice in rices {
                let tagString = rice.wrappedTags
                if tagString.localizedCaseInsensitiveContains("vegetarisch") {
                    ricesveg.append(rice)
                } else {
                    ricesmeat.append(rice)
                }
            }
        }
        
        if !potatoes.isEmpty{
            for potato in potatoes {
                let tagString = potato.wrappedTags
                if tagString.localizedCaseInsensitiveContains("vegetarisch") {
                    potatoesveg.append(potato)
                } else {
                    potatoesmeat.append(potato)
                }
            }
        }
        
        if !bakings.isEmpty{
            for baking in bakings {
                let tagString = baking.wrappedTags
                if tagString.localizedCaseInsensitiveContains("vegetarisch") {
                    bakingsveg.append(baking)
                } else {
                    bakingsmeat.append(baking)
                }
            }
        }
        
        if !others.isEmpty{
            for other in others {
                let tagString = other.wrappedTags
                if tagString.localizedCaseInsensitiveContains("vegetarisch") {
                    othersveg.append(other)
                } else {
                    othersmeat.append(other)
                }
            }
        }
        
        var vegs: [Recipie] = []
        var meats: [Recipie] = []
        
        //Adding Different food types to veggi or meat array depending on weighting
        
        if pastasveg.count >= numberOfRecepies(amount: nudeln, days: 7) && pastasmeat.count >= numberOfRecepies(amount: nudeln, days: 7) {
            for _ in 1...numberOfRecepies(amount: nudeln, days: 7){
                if let index = pastasveg.indices.randomElement() {
                    vegs.append(pastasveg[index])
                    pastasveg.remove(at: index)
                }
                
                if let index = pastasmeat.indices.randomElement() {
                    meats.append(pastasmeat[index])
                    pastasmeat.remove(at: index)
                }
            }
        }
        
        if ricesveg.count >= numberOfRecepies(amount: reis, days: 7) && ricesmeat.count >= numberOfRecepies(amount: reis, days: 7) {
            for _ in 1...numberOfRecepies(amount: reis, days: 7){
                if let index = ricesveg.indices.randomElement() {
                    vegs.append(ricesveg[index])
                    ricesveg.remove(at: index)
                }
                
                if let index = ricesmeat.indices.randomElement() {
                    meats.append(ricesmeat[index])
                    ricesmeat.remove(at: index)
                }
            }
        }
        
        if potatoesveg.count >= numberOfRecepies(amount: kartoffeln, days: 7) && potatoesmeat.count >= numberOfRecepies(amount: kartoffeln, days: 7) {
            for _ in 1...numberOfRecepies(amount: kartoffeln, days: 7){
                if let index = potatoesveg.indices.randomElement() {
                    vegs.append(potatoesveg[index])
                    potatoesveg.remove(at: index)
                }
                
                if let index = potatoesmeat.indices.randomElement() {
                    meats.append(potatoesmeat[index])
                    potatoesmeat.remove(at: index)
                }
            }
        }
        
        if bakingsveg.count >= numberOfRecepies(amount: gebackenes, days: 7) && bakingsmeat.count >= numberOfRecepies(amount: gebackenes, days: 7) {
            for _ in 1...numberOfRecepies(amount: gebackenes, days: 7){
                if let index = bakingsveg.indices.randomElement() {
                    vegs.append(bakingsveg[index])
                    bakingsveg.remove(at: index)
                }
                
                if let index = bakingsmeat.indices.randomElement() {
                    meats.append(bakingsmeat[index])
                    bakingsmeat.remove(at: index)
                }
            }
        }
        
        if othersveg.count >= 2 && othersmeat.count >= 2 {
            for _ in 1...2{
                if let index = othersveg.indices.randomElement() {
                    vegs.append(othersveg[index])
                    othersveg.remove(at: index)
                }
                
                if let index = othersmeat.indices.randomElement() {
                    meats.append(othersmeat[index])
                    othersmeat.remove(at: index)
                }
            }
        }
        
        
        //Adding recipies depending on Veggi/meat wheighting to tempArray
        
        if !vegetarisch {
            for _ in 1...(7 - numberOfRecepies(amount: fleisch, days: 7)){
                if let index = vegs.indices.randomElement() {
                    tempGeneratedRecipies.append(vegs[index])
                    
                    vegs.remove(at: index)
                    
                }
            }
            
            for _ in 1...(numberOfRecepies(amount: fleisch, days: 7)){
                if let index = meats.indices.randomElement() {
                    tempGeneratedRecipies.append(meats[index])
                    
                    meats.remove(at: index)
                }
            }
        } else {
            for _ in 1...7{
                if let index = vegs.indices.randomElement() {
                    tempGeneratedRecipies.append(vegs[index])
                    
                    vegs.remove(at: index)
                }
            }
        }
        
        tempGeneratedRecipies = tempGeneratedRecipies.shuffled()
        
        for index in 1...7{
            generatedRecipies.append(tempGeneratedRecipies[index])
            generatedRecipies[index].picked = Int16(index+1)
            try? moc.save()
        }
        
        return generatedRecipies
    }
}
