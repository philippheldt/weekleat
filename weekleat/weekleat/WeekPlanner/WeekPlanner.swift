//
//  ListView.swift
//  weekleat
//
//  Created by Philipp Jenny on 11.05.22.
//

import SwiftUI

struct WeekPlanner: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.picked)]) var recipies: FetchedResults<Recipie>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var shoppingItems: FetchedResults<BuyIngr>
    
    @State private var passRecipie: Recipie? = nil
    @State private var showingEditScreen = false
    
    @State var generatedRecipies: [Recipie] = []
    @State var selectedRecipie: [Recipie] = []
    
    
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
    @State var numberofSelectedDays: Int = 0
    
    @AppStorage("vegetarisch") private var vegetarisch: Bool = false
    @AppStorage("vegan") private var vegan: Bool = false
    @AppStorage("fleisch")  private var fleisch: String = "selten"
    
    var body: some View {
        NavigationView{
            
            VStack{
                List(recipies, id:\.self){ recipie in
 
                    if Int(recipie.picked)  > 0 && Int(recipie.picked) <= numberofSelectedDays{
                        Section(header: Text(days[Int(recipie.picked)-1])){
                                ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: tagConverter(tagString: recipie.wrappedTags), backgroundColor: "PureWhite", portion: Int(recipie.portion))
                            }
                            .swipeActions{
                                Button{
                                    withAnimation{
                                        generateRecipies(positionQuery: true, position: Int(recipie.picked), currentRecipie: recipie)
                                       
                                        try? moc.save()
                                    }

                                 
                                } label: {
                                    Label("", systemImage: "arrow.triangle.2.circlepath")
                                }
                                .tint(Color("BlueMedium"))
                            }
                        }
                }
                .listStyle(.insetGrouped)
            }
            .onAppear {
                days = daysArray(montag: montag, dienstag: dienstag, mittwoch: mittwoch, donnerstag: donnerstag, freitag: freitag, samstag: samstag, sonntag: sonntag)
              
                numberofSelectedDays = days.count
              
                
            }
            .navigationTitle("Wochenplan")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                  generateRecipies(positionQuery: false, position: 0, currentRecipie: recipies[0])
                    } label: {
                        Label("Neu generieren", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showingEditScreen){
                EditRecipieView(rezept: passRecipie ?? recipies[0])
            }
            
            
            
            
            
        }
    }
    func generateRecipies(positionQuery: Bool, position: Int, currentRecipie: Recipie) {
        
       
        
        if positionQuery == false{
            for recipie in recipies {
                recipie.picked = 0
                try? moc.save()
            }
           
        } else {
            selectedRecipie = []
            selectedRecipie.append(currentRecipie)
            selectedRecipie[0].picked = 0
            try? moc.save()
        }
   
        var tempGeneratedRecipies: [Recipie] = []
       
        
        

        
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
        
        //adding potatoes
        for _ in 1...numberOfRecepies(amount: kartoffeln, days: days.count){
            if let index = potatoesveg.indices.randomElement() {
                vegs.append(potatoesveg[index])
                potatoesveg.remove(at: index)
            }
            
            if let index = potatoesmeat.indices.randomElement() {
                meats.append(potatoesmeat[index])
                potatoesmeat.remove(at: index)
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
            for _ in 0...(numberOfRecepies(amount: fleisch, days: days.count)){
            if let index = vegs.indices.randomElement() {
                tempGeneratedRecipies.append(vegs[index])
            
                vegs.remove(at: index)
                
            }
        }
        
            for _ in 0...(numberOfRecepies(amount: fleisch, days: days.count)){
                if let index = meats.indices.randomElement() {
                    tempGeneratedRecipies.append(meats[index])
                
                    meats.remove(at: index)
                }
            }
        } else {
            for _ in 0...days.count{
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
            tempGeneratedRecipies = filteredGeneratedRecipies
            print(generatedRecipies[position-1].wrappedTitle)
            generatedRecipies[position-1].picked = Int16(0)
            generatedRecipies[position-1] = tempGeneratedRecipies[0]
           generatedRecipies[position-1].picked = Int16(position)

            try? moc.save()
        } else {
            generatedRecipies = tempGeneratedRecipies
            generatedRecipies = generatedRecipies.shuffled()
            
            for shoppingItem in shoppingItems {
                moc.delete(shoppingItem)
                try? moc.save()
            }

            
            for (index, generatedRecipie) in generatedRecipies.enumerated() {
              
                if index < days.count {
                    generatedRecipie.picked = Int16(index+1)

                    for ingredient in generatedRecipie.ingredientsArray{
                        print("\(ingredient.wrappedTitle)")
                        let newShoppingItem = BuyIngr(context: moc)
                        newShoppingItem.amount = ingredient.amount
                        newShoppingItem.bought = false
                        newShoppingItem.unit = ingredient.unit
                        newShoppingItem.title = ingredient.wrappedTitle
                        try? moc.save()
                    }
                    try? moc.save()
                }
        
           
            }
            
            
            for (index1, shoppingItem1) in shoppingItems.enumerated() {
                print("----")
                for (index2, shoppingItem2) in shoppingItems.enumerated(){
                    if index1 != index2 {
                      
                        if shoppingItem1.title ?? "" == shoppingItem2.title ?? "" && shoppingItem1.unit ?? "" ==
                            shoppingItem2.unit ?? "" && !shoppingItem1.bought && !shoppingItem2.bought {
                            print("Index1: \(index1) ")
                            
                                print("Index2: \(index2) ")
                            
                            print("shoppingItem1: \(shoppingItem1.title ?? "") \(shoppingItem1.amount)\(shoppingItem1.unit ?? "")")
                            print("shoppingItem2: \(shoppingItem2.title ?? "") \(shoppingItem2.amount)\(shoppingItem2.unit ?? "")")
                     
                            shoppingItem1.amount = shoppingItem1.amount + shoppingItem2.amount
                            shoppingItem2.bought = true
                            
                            print("shoppingItem1_2: \(shoppingItem1.title ?? "") \(shoppingItem1.amount)\(shoppingItem1.unit ?? "")")
                            print("shoppingItem2_2: \(shoppingItem2.title ?? "") \(shoppingItem2.amount)\(shoppingItem2.unit ?? "")")
                            
                            try? moc.save()
                            
                            print("shoppingItem1_3: \(shoppingItem1.title ?? "") \(shoppingItem1.amount)\(shoppingItem1.unit ?? "")")
                            print("shoppingItem2_3: \(shoppingItem2.title ?? "") \(shoppingItem2.amount)\(shoppingItem2.unit ?? "")")
                        }
                    }
                }
            }
            
            for shoppingItem in shoppingItems{
                if shoppingItem.bought {
                    moc.delete(shoppingItem)
                    try? moc.save()
                }
           }

        }
        
    
        
        
        
      
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner()
        
    }
}
