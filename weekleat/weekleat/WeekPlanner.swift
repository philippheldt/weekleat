//
//  ListView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct WeekPlanner: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var recipies: FetchedResults<Recipie>
    
    
    @State var showSheet: Bool = false
    @State var selected: Rezept = Rezepte.dummyRezepte[0]
    
    @State var generatedRecipies: [Recipie] = []
    
    
    @AppStorage("nudeln") private var nudeln: String = "häufig"
    @AppStorage("reis") private var reis: String = "mittel"
    @AppStorage("kartoffeln") private var kartoffeln: String = "selten"
    @AppStorage("gebackenes") private var gebackenes: String = "selten"
    
    @AppStorage("montag") private var montag: Bool = true
    @AppStorage("dienstag") private var dienstag: Bool = true
    @AppStorage("mittwoch")  private var mittwoch: Bool = true
    @AppStorage("donnerstag")  private var donnerstag: Bool = true
    @AppStorage("freitag") private var freitag: Bool = true
    @AppStorage("samstag")  private var samstag: Bool = true
    @AppStorage("sonntag")  private var sonntag: Bool = true
    @State private var days: [String] = []
    
    @AppStorage("vegetarisch") private var vegetarisch: Bool = false
    @AppStorage("vegan") private var vegan: Bool = false
    @AppStorage("fleisch")  private var fleisch: String = "selten"
    
    var body: some View {
        NavigationView{
            
            VStack{
                List{
                  
                    if generatedRecipies.count >= 1{
                            Section(header: Text(days[0])){
                                ListItemElement(titleText: generatedRecipies[0].wrappedTitle , titleImage: generatedRecipies[0].wrappedFoodType, color: intToColorTheme(colorInt: Int(generatedRecipies[0].colorTheme)), tags: tagConverter(tagString: generatedRecipies[0].wrappedTags), backgroundColor: "PureWhite", portion: Int(generatedRecipies[0].portion))
                            }
                          
                            .swipeActions{
                                Button{
                                    generateRecipies(positionQuery: true, position: 0)
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        }
                        
                        if generatedRecipies.count >= 2{
                            Section(header: Text(days[1])){
                                ListItemElement(titleText: generatedRecipies[1].wrappedTitle , titleImage: generatedRecipies[1].wrappedFoodType, color: intToColorTheme(colorInt: Int(generatedRecipies[1].colorTheme)), tags: tagConverter(tagString: generatedRecipies[1].wrappedTags), backgroundColor: "PureWhite", portion: Int(generatedRecipies[1].portion))
                            }
                            .swipeActions{
                                Button{
                                    generateRecipies(positionQuery: true, position: 1)
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        }
                        
                        if generatedRecipies.count >= 3{
                            Section(header: Text(days[2])){
                                ListItemElement(titleText: generatedRecipies[2].wrappedTitle , titleImage: generatedRecipies[2].wrappedFoodType, color: intToColorTheme(colorInt: Int(generatedRecipies[2].colorTheme)), tags: tagConverter(tagString: generatedRecipies[2].wrappedTags), backgroundColor: "PureWhite", portion: Int(generatedRecipies[2].portion))
                            }
                            .swipeActions{
                                Button{
                                    generateRecipies(positionQuery: true, position: 2)
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        }
                        
                        if generatedRecipies.count >= 4{
                            Section(header: Text(days[3])){
                                ListItemElement(titleText: generatedRecipies[3].wrappedTitle , titleImage: generatedRecipies[3].wrappedFoodType, color: intToColorTheme(colorInt: Int(generatedRecipies[3].colorTheme)), tags: tagConverter(tagString: generatedRecipies[3].wrappedTags), backgroundColor: "PureWhite", portion: Int(generatedRecipies[3].portion))
                            }
                            .swipeActions{
                                Button{
                                    generateRecipies(positionQuery: true, position: 3)
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        }
                        
                        if generatedRecipies.count >= 5{
                            Section(header: Text(days[4])){
                                ListItemElement(titleText: generatedRecipies[4].wrappedTitle , titleImage: generatedRecipies[4].wrappedFoodType, color: intToColorTheme(colorInt: Int(generatedRecipies[4].colorTheme)), tags: tagConverter(tagString: generatedRecipies[4].wrappedTags), backgroundColor: "PureWhite", portion: Int(generatedRecipies[4].portion))
                            }
                            .swipeActions{
                                Button{
                                    generateRecipies(positionQuery: true, position: 4)
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        }
                        
                        if generatedRecipies.count >= 6{
                            Section(header: Text(days[5])){
                                ListItemElement(titleText: generatedRecipies[5].wrappedTitle , titleImage: generatedRecipies[5].wrappedFoodType, color: intToColorTheme(colorInt: Int(generatedRecipies[5].colorTheme)), tags: tagConverter(tagString: generatedRecipies[5].wrappedTags), backgroundColor: "PureWhite", portion: Int(generatedRecipies[5].portion))
                            }
                            .swipeActions{
                                Button{
                                    generateRecipies(positionQuery: true, position: 5)
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        }
                        if generatedRecipies.count >= 7{
                            Section(header: Text(days[6])){
                                ListItemElement(titleText: generatedRecipies[6].wrappedTitle , titleImage: generatedRecipies[6].wrappedFoodType, color: intToColorTheme(colorInt: Int(generatedRecipies[6].colorTheme)), tags: tagConverter(tagString: generatedRecipies[6].wrappedTags), backgroundColor: "PureWhite", portion: Int(generatedRecipies[6].portion))
                            }
                            .swipeActions{
                                Button{
                                    generateRecipies(positionQuery: true, position: 6)
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        
                    }
                   
                }
                .listStyle(.plain)
            }
            .navigationTitle("Wochenplan")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                  generateRecipies(positionQuery: false, position: 0)
                    } label: {
                        Label("Neu generieren", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showSheet, content: {
                RezeptDetailView(rezeptDetails: selected)
            })
            
            
            
            
            
        }
    }
    func generateRecipies(positionQuery: Bool, position: Int) {
        var tempGeneratedRecipies: [Recipie] = []
        
        days = daysArray(montag: montag, dienstag: dienstag, mittwoch: mittwoch, donnerstag: donnerstag, freitag: freitag, samstag: samstag, sonntag: sonntag)
        
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
        
        var used: String = ""
        
        for pasta in pastas {
            let tagString = pasta.wrappedTags
            let tagArray = tagString.components(separatedBy: ",")
            for tag in tagArray{
                switch tag.lowercased(){
                case "vegetarisch":
                    pastasveg.append(pasta)
                    used = pasta.wrappedTitle
                default:
                    if pasta.wrappedTitle != used {
                        pastasmeat.append(pasta)
                    }
                }
            }
        }
        
        for rice in rices {
            let tagString = rice.wrappedTags
            let tagArray = tagString.components(separatedBy: ",")
            for tag in tagArray{
                switch tag.lowercased(){
                case "vegetarisch":
                    ricesveg.append(rice)
                    used = rice.wrappedTitle
                default:
                    if rice.wrappedTitle != used {
                        ricesmeat.append(rice)
                    }
                }
            }
        }
        
        for potatoe in potatoes {
            let tagString = potatoe.wrappedTags
            let tagArray = tagString.components(separatedBy: ",")
            for tag in tagArray{
                switch tag.lowercased(){
                case "vegetarisch":
                    potatoesveg.append(potatoe)
                    used = potatoe.wrappedTitle
                default:
                    if potatoe.wrappedTitle != used {
                        potatoesmeat.append(potatoe)
                    }
                }
            }
        }
        
        for baking in bakings {
            let tagString = baking.wrappedTags
            let tagArray = tagString.components(separatedBy: ",")
            for tag in tagArray{
                switch tag.lowercased(){
                case "vegetarisch":
                    bakingsveg.append(baking)
                    used = baking.wrappedTitle
                default:
                    if baking.wrappedTitle != used {
                        bakingsmeat.append(baking)
                    }
                }
            }
        }
        
        for other in others {
            let tagString = other.wrappedTags
            let tagArray = tagString.components(separatedBy: ",")
            for tag in tagArray{
                switch tag.lowercased(){
                case "vegetarisch":
                    othersveg.append(other)
                    used = other.wrappedTitle
                default:
                    if other.wrappedTitle != used {
                        othersmeat.append(other)
                    }
                }
            }
        }
        
        var vegs: [Recipie] = []
        var meats: [Recipie] = []
        
        //adding pasta
        for _ in 1...numberOfRecepies(amount: nudeln, days: days.count){
            if let index = pastasveg.indices.randomElement() {
                vegs.append(pastasveg[index])
                pastasveg.remove(at: index)
            }
            
            if let index = pastasmeat.indices.randomElement() {
                meats.append(pastasmeat[index])
                pastasmeat.remove(at: index)
            }
        }
        
        //adding rice
        for _ in 1...numberOfRecepies(amount: reis, days: days.count){
            if let index = ricesveg.indices.randomElement() {
                vegs.append(ricesveg[index])
                ricesveg.remove(at: index)
            }
            
            if let index = ricesmeat.indices.randomElement() {
                meats.append(ricesmeat[index])
                ricesmeat.remove(at: index)
            }
        }
        
        //adding baking
        for _ in 1...numberOfRecepies(amount: gebackenes, days: days.count){
            if let index = bakingsveg.indices.randomElement() {
                vegs.append(bakingsveg[index])
                bakingsveg.remove(at: index)
            }
            
            if let index = bakingsmeat.indices.randomElement() {
                meats.append(bakingsmeat[index])
                bakingsmeat.remove(at: index)
            }
        }
        
        //adding other
        for _ in 1...1{
            if let index = othersveg.indices.randomElement() {
                vegs.append(othersveg[index])
                othersveg.remove(at: index)
            }
            
            if let index = othersmeat.indices.randomElement() {
                meats.append(othersmeat[index])
                othersmeat.remove(at: index)
            }
        }
      
        
        if !vegetarisch {
        for _ in 1...(days.count - numberOfRecepies(amount: fleisch, days: days.count)){
            if let index = vegs.indices.randomElement() {
                tempGeneratedRecipies.append(vegs[index])
                
                vegs.remove(at: index)
            }
        }
        
            for _ in 1...(numberOfRecepies(amount: fleisch, days: days.count)){
                if let index = meats.indices.randomElement() {
                    tempGeneratedRecipies.append(meats[index])
                    
                    meats.remove(at: index)
                }
            }
        } else {
            for _ in 1...days.count{
                if let index = vegs.indices.randomElement() {
                    tempGeneratedRecipies.append(vegs[index])
                    
                    vegs.remove(at: index)
                }
            }
        }
        
       
   
        if positionQuery {
            var filteredGeneratedRecipies: [Recipie] = []
            for tempGeneratedRecipe in tempGeneratedRecipies {
                if !generatedRecipies.contains(tempGeneratedRecipe){
                    filteredGeneratedRecipies.append(tempGeneratedRecipe)
                } 
            }
            generatedRecipies[position] = filteredGeneratedRecipies[0]

        } else {
            generatedRecipies = tempGeneratedRecipies
            generatedRecipies = generatedRecipies.shuffled()
        }
        
        
        
      
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner()
        
    }
}
