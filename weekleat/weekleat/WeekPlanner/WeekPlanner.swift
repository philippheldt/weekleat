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
    @State private var showingSettingsScreen = false
    
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
            ScrollView{
                HStack{
                    HStack{
                        Button{
                            montag.toggle()
                            generateShoppinglist()
                        } label: {
                            Text("M")
                                .font(.caption)
                        }
                        .frame(width: 40, height: 40)
                        .background(montag ? Color.black : Color.white)
                        .cornerRadius(5)
                        .foregroundColor(montag ? Color.white : Color.black)
                        .buttonStyle(BorderlessButtonStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        Spacer()
                        
                    }
                    
                    HStack{
                        Button{
                            dienstag.toggle()
                            generateShoppinglist()
                        } label: {
                            Text("D")
                                .font(.caption)
                        }
                        .frame(width: 40, height: 40)
                        .background(dienstag ? Color.black : Color.white)
                        .cornerRadius(5)
                        .foregroundColor(dienstag ? Color.white : Color.black)
                        .buttonStyle(BorderlessButtonStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        Spacer()
                        
                    }
                    
                    
                    HStack{
                        Button{
                            mittwoch.toggle()
                            generateShoppinglist()
                        } label: {
                            Text("M")
                                .font(.caption)
                        }
                        .frame(width: 40, height: 40)
                        .background(mittwoch ? Color.black : Color.white)
                        .cornerRadius(5)
                        .foregroundColor(mittwoch ? Color.white : Color.black)
                        .buttonStyle(BorderlessButtonStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        Spacer()
                        
                    }
                    
                    HStack{
                        Button{
                            donnerstag.toggle()
                            generateShoppinglist()
                        } label: {
                            Text("D")
                                .font(.caption)
                        }
                        .frame(width: 40, height: 40)
                        .background(donnerstag ? Color.black : Color.white)
                        .cornerRadius(5)
                        .foregroundColor(donnerstag ? Color.white : Color.black)
                        .buttonStyle(BorderlessButtonStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        Spacer()
                        
                    }
                    
                    
                    
                    HStack{
                        Button{
                            freitag.toggle()
                            generateShoppinglist()
                        } label: {
                            Text("F")
                                .font(.caption)
                        }
                        .frame(width: 40, height: 40)
                        .background(freitag ? Color.black : Color.white)
                        .cornerRadius(5)
                        .foregroundColor(freitag ? Color.white : Color.black)
                        .buttonStyle(BorderlessButtonStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        Spacer()
                        
                    }
                    
                    
                    HStack{
                        Button{
                            samstag.toggle()
                            generateShoppinglist()
                        } label: {
                            Text("S")
                                .font(.caption)
                        }
                        .frame(width: 40, height: 40)
                        .background(samstag ? Color.black : Color.white)
                        .cornerRadius(5)
                        .foregroundColor(samstag ? Color.white : Color.black)
                        .buttonStyle(BorderlessButtonStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        Spacer()
                        
                    }
                    
                    
                    HStack{
                        Button{
                            sonntag.toggle()
                            generateShoppinglist()
                        } label: {
                            Text("S")
                                .font(.caption)
                        }
                        .frame(width: 40, height: 40)
                        .background(sonntag ? Color.black : Color.white)
                        .cornerRadius(5)
                        .foregroundColor(sonntag ? Color.white : Color.black)
                        .buttonStyle(BorderlessButtonStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 0.5)
                        )
                        
                    }
                    
                    
                    
                }
                .padding()
                
                VStack(alignment: .leading){
                    if recipies.count > 0 {
                        ForEach(recipies, id:\.self){ recipie in
                            if recipie.picked == 1 && montag{
                                WeekPlannerItems(recipie: recipie, dayPicked: "montag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen)
                            }
                            if recipie.picked == 2 && dienstag{
                                WeekPlannerItems(recipie: recipie, dayPicked: "dienstag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen)
                            }
                            if recipie.picked == 3 && mittwoch{
                                WeekPlannerItems(recipie: recipie, dayPicked: "mittwoch", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen)
                            }
                            if recipie.picked == 4 && donnerstag{
                                WeekPlannerItems(recipie: recipie, dayPicked: "donnerstag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen)
                            }
                            if recipie.picked == 5 && freitag{
                                WeekPlannerItems(recipie: recipie, dayPicked: "freitag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen)
                            }
                            if recipie.picked == 6 && samstag{
                                WeekPlannerItems(recipie: recipie, dayPicked: "samstag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen)
                            }
                            if recipie.picked == 7 && sonntag{
                                WeekPlannerItems(recipie: recipie, dayPicked: "sonntag", passRecipie: $passRecipie, showingEditScreen: $showingEditScreen)
                            }
                        }     }
                }
                
                HStack(spacing: 10){
                    Button{
                        showingSettingsScreen.toggle()
                    } label: {
                        Image("settings.icon.black")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 0.5)
                    )
                    
                    
                    Button{
                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                        impactMed.impactOccurred()
                        generateRecipies()
                        
                        
                    } label: {
                        Image(systemName: "arrow.clockwise")
                        Text("Rezepte generieren")
                    }
                    .padding()
                    .background(Color.black)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
   
                 
                }
                .padding(.top)
                
            }
            
            .onAppear {
                days = daysArray(montag: montag, dienstag: dienstag, mittwoch: mittwoch, donnerstag: donnerstag, freitag: freitag, samstag: samstag, sonntag: sonntag)
                numberofSelectedDays = days.count
                for recipie in recipies {
                    if recipie.picked > 0 {
                        generatedRecipies.append(recipie)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: RezeptSammlung(passRecipie: recipies[0])){
                        Image("book.icon.black")
                            .resizable()
                            .padding(5)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ShoppinglistView()){
                        Image("cart.icon.black")
                            .resizable()
                            .padding(5)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                    }
                }
                
            }
            .sheet(isPresented: $showingEditScreen){
                EditRecipieView(rezept: passRecipie ?? recipies[0])
            }
            .sheet(isPresented: $showingSettingsScreen){
                SettingsView()
            }
            .navigationTitle("Wochenplan")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
    
    
    
    func generateRecipies(){
        
        generatedRecipies = []
        
        for recipie in recipies{
            recipie.picked = 0
            try? moc.save()
        }
        //Array within the function in which all the picked recipies are stored and later on saved to genaratedRecipies
        var tempGeneratedRecipies: [Recipie] = []
        
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
            pastasveg = pastasveg.shuffled()
            pastasmeat = pastasmeat.shuffled()
            for index in 1...numberOfRecepies(amount: nudeln, days: 7){
                vegs.append(pastasveg[index-1])
                meats.append(pastasmeat[index-1])
            }
        }
        
        if ricesveg.count >= numberOfRecepies(amount: reis, days: 7) && ricesmeat.count >= numberOfRecepies(amount: reis, days: 7) {
            ricesveg = ricesveg.shuffled()
            ricesmeat = ricesmeat.shuffled()
            for index in 1...numberOfRecepies(amount: reis, days: 7){
                vegs.append(ricesveg[index-1])
                meats.append(ricesmeat[index-1])
            }
        }
        
        if potatoesveg.count >= numberOfRecepies(amount: kartoffeln, days: 7) && potatoesmeat.count >= numberOfRecepies(amount: kartoffeln, days: 7) {
            potatoesveg = potatoesveg.shuffled()
            potatoesmeat = potatoesmeat.shuffled()
            for index in 1...numberOfRecepies(amount: kartoffeln, days: 7){
                vegs.append(potatoesveg[index-1])
                meats.append(potatoesmeat[index-1])
            }
        }
        
        if bakingsveg.count >= numberOfRecepies(amount: gebackenes, days: 7) && bakingsmeat.count >= numberOfRecepies(amount: gebackenes, days: 7) {
            bakingsveg = bakingsveg.shuffled()
            bakingsmeat = bakingsmeat.shuffled()
            for index in 1...numberOfRecepies(amount: gebackenes, days: 7){
                vegs.append(bakingsveg[index-1])
                meats.append(bakingsmeat[index-1])
            }
        }
        
        if othersveg.count >= 2 && othersmeat.count >= 2 {
            othersveg = othersveg.shuffled()
            othersmeat = othersmeat.shuffled()
            for index in 1...2{
                vegs.append(othersveg[index-1])
                meats.append(othersmeat[index-1])
            }
        }
        
        
        //Adding recipies depending on Veggi/meat wheighting to tempArray
        
        if !vegetarisch {
            vegs = vegs.shuffled()
            meats = meats.shuffled()
            if vegs.count >= (7 - numberOfRecepies(amount: fleisch, days: 7)) {
                for index in 1...(7 - numberOfRecepies(amount: fleisch, days: 7)){
                    tempGeneratedRecipies.append(vegs[index-1])
                }
            }
           
            if meats.count >= (numberOfRecepies(amount: fleisch, days: 7)) {
                for index in 1...(numberOfRecepies(amount: fleisch, days: 7)){
                    tempGeneratedRecipies.append(meats[index-1])
                }
            }
        } else {
            for index in 1...7{
                tempGeneratedRecipies.append(vegs[index-1])
            }
        }
        
        tempGeneratedRecipies = tempGeneratedRecipies.shuffled()
        print("Temp: \(tempGeneratedRecipies.count)")
        
        // incase there are too less recipies it will just randomly generate without weighting
        if tempGeneratedRecipies.count >= 7{
            for index in 1...7{
                generatedRecipies.append(tempGeneratedRecipies[index-1])
                generatedRecipies[index-1].picked = Int16(index)
                try? moc.save()
            }
            print("Gen: \(generatedRecipies.count)")
            for recipie in generatedRecipies{
                print(recipie.wrappedTitle)
                print(recipie.picked)
            }
            print("_________________")
            
        } else {
            var allRecipies: [Recipie] = []
            for recipie in recipies {
                allRecipies.append(recipie)
            }
            
            tempGeneratedRecipies = allRecipies.shuffled()
            for index in 1...7{
                generatedRecipies.append(tempGeneratedRecipies[index-1])
                generatedRecipies[index-1].picked = Int16(index)
                try? moc.save()
            }
        }
        
        for(index1, recipie1) in generatedRecipies.enumerated() {
            for(index2, recipie2) in generatedRecipies.enumerated() {
                if recipie1 == recipie2 && index1 != index2{
                    generateRecipies()
                }
            }
        }
        
        generateShoppinglist()
    }
    
    func generateShoppinglist() {
        //before adding new shopping Items, delete all the old Items
        for shoppingItem in shoppingItems {
            moc.delete(shoppingItem)
            try? moc.save()
        }
        
        print(generatedRecipies.count)
        for (index, generatedRecipie) in generatedRecipies.enumerated() {
            //Takes all the recipies which are picked (In The Data Model they have an Index indecating which day they are)
            if index == 0 && montag {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
            }
            if index == 0 && montag {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
            }
            if index == 1 && dienstag {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
            }
            if index == 2 && mittwoch {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
            }
            if index == 3 && donnerstag {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
            }
            if index == 4 && freitag {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
            }
            if index == 5 && samstag {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
            }
            if index == 6 && sonntag {
                for ingredient in generatedRecipie.ingredientsArray{
                    let newShoppingItem = BuyIngr(context: moc)
                    newShoppingItem.amount = ingredient.amount
                    newShoppingItem.bought = false
                    newShoppingItem.unit = ingredient.unit
                    newShoppingItem.title = ingredient.wrappedTitle
                    try? moc.save()
                }
                
            }
            
            
        }
        
        
        //Sorting Shoppingitems, if there is already one existing if they are already in the system they are marked „bought“ and the values added to the already existing
        for (index1, shoppingItem1) in shoppingItems.enumerated() {
            for (index2, shoppingItem2) in shoppingItems.enumerated(){
                if index1 != index2 {
                    if shoppingItem1.title ?? "" == shoppingItem2.title ?? "" && shoppingItem1.unit ?? "" ==
                        shoppingItem2.unit ?? "" && !shoppingItem1.bought && !shoppingItem2.bought {
                        shoppingItem1.amount = shoppingItem1.amount + shoppingItem2.amount
                        shoppingItem2.bought = true
                        try? moc.save()
                    }
                }
            }
        }
        //Now all the existing Items are deleted from the shoppinglist
        for shoppingItem in shoppingItems{
            if shoppingItem.bought {
                moc.delete(shoppingItem)
                try? moc.save()
            }
        }
    }
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        WeekPlanner()
        
    }
}
