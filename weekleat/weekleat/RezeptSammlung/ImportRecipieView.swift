//
//  ImportRecipieView.swift
//  weekleat
//
//  Created by Philipp Jenny on 21.07.22.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var titel: String
    var zutaten: [String]
}

struct ImportRecipieView: View {
    @State private var results = [Result]()
    @State private var url = ""
    var body: some View {
        VStack {
            HStack{
                TextField("Hier URL einfügen", text: $url)
                    .padding()
                    .background(Color("BlueLight"))
                    .cornerRadius(10)
                Button{
//                    Task{
//                        await loadData()
//                    }
                } label: {
                    Text("Importieren")
                }
            }
            .padding()
            List(results, id:\.titel){ result in
                Text(result.titel)
            }
        }.task {
            print("running")
            await loadData()
            print("ran")
        }
       
    }
    func loadData() async {
        guard let url = URL(string: "https://recipiescraperapi.herokuapp.com/chefkoch/279982666451_Yogurtlu-Eriste") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
                print(results)
            }
            print("Nothing to do")
        } catch {
            print("Invalid data")
        }
             
    }
}

struct ImportRecipieView_Previews: PreviewProvider {
    static var previews: some View {
        ImportRecipieView()
    }
}
