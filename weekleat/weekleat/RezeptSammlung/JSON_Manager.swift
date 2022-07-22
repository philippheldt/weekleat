//
//  JSON_Manager.swift
//  weekleat
//
//  Created by Philipp Jenny on 21.07.22.
//

import Foundation

struct ImportRezept: Codable {
    let titel: String
    let zutaten: [Zutaten]
    let schritte: String
    
    static let allRecipies: [ImportRezept] = Bundle.main.decode(file: "https://recipiescraperapi.herokuapp.com/chefkoch/279982666451_Yogurtlu-Eriste")
    static let exampleRecipie: ImportRezept = allRecipies[0]
}

struct Zutaten: Codable {
    let menge, zutat: String
}

extension Bundle{
    func decode<T: Decodable>(file:String) -> T{
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load")
        }
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode")
        }
        return loadedData
    }
}
