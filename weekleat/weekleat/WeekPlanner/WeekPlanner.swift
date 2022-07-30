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
            ScrollView{
            VStack(alignment: .leading){
                if recipies.count > 0 {
                    
           
                ForEach(recipies, id:\.self){ recipie in
                    if Int(recipie.picked)  > 0 && Int(recipie.picked) <= numberofSelectedDays{
                        if getTodayWeekDay().lowercased() == days[Int(recipie.picked)-1].lowercased() {
                            
                            VStack(alignment: .leading){
                                Text("Heute")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(getDates())
                                    .textCase(.uppercase)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            ListElementLarge(recipie: recipie)
                                .onTapGesture{
                                    passRecipie = recipie
                                    showingEditScreen.toggle()
                                }
                                .padding(.bottom)
                        } else {
                            Text(days[Int(recipie.picked)-1])
                                .font(.caption)
                                .textCase(.uppercase)
                                .foregroundColor(.gray)
                                .padding([.leading, .top])
                            ListElement(recipie: recipie)
                            
                                .onTapGesture{
                                    passRecipie = recipie
                                    showingEditScreen.toggle()
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
                }     }
            }
            
            }
            .onAppear {
                days = daysArray(montag: montag, dienstag: dienstag, mittwoch: mittwoch, donnerstag: donnerstag, freitag: freitag, samstag: samstag, sonntag: sonntag)
                numberofSelectedDays = days.count
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
                               .navigationTitle("Wochenplan")
            .navigationBarTitleDisplayMode(.inline)
            
        }
       
    }
    
    func getTodayWeekDay()-> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           let weekDay = dateFormatter.string(from: Date())
           return weekDay
     }
    
    func getDates()-> String{
           let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
           let dateToday = dateFormatter.string(from: Date())
           return dateToday
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
   
        //Array within the function in which all the picked recipies are stored and later on saved to genaratedRecipies
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
        

        
   
     // If the Position matters, when generating (This is the case when generating single recipies) Do this:
        if positionQuery {
            //filteredGeneratedRecipies is the Array, where all the Recipies are stored, that dont already exist in generated Recipies
            var filteredGeneratedRecipies: [Recipie] = []
            for tempGeneratedRecipe in tempGeneratedRecipies {
                if !generatedRecipies.contains(tempGeneratedRecipe){
                    filteredGeneratedRecipies.append(tempGeneratedRecipe)
                } 
            }
            tempGeneratedRecipies = filteredGeneratedRecipies
           //Set picked value of current recipie to 0 (This indicates to the system, that it is no longer used by the weekplanner)
            generatedRecipies[position-1].picked = Int16(0)
            //Replace the position of generatedRecipies with the new recipie and then in the next line set the picked value to the position in the week.
            generatedRecipies[position-1] = tempGeneratedRecipies[0]
            generatedRecipies[position-1].picked = Int16(position)
            //Take the whole new Array and generate a new shoppinglist
            generateShoppinglist()

            try? moc.save()
        } else {
            //Save all the temporary recipies to the generatedRecipies Array
            generatedRecipies = tempGeneratedRecipies
            generatedRecipies = generatedRecipies.shuffled()
            //genrate shoppinglist from picked recipies
            generateShoppinglist()

        }
    }
    
    func generateShoppinglist() {
        //before adding new shopping Items, delete all the old Items
        for shoppingItem in shoppingItems {
            moc.delete(shoppingItem)
            try? moc.save()
        }

        
        for (index, generatedRecipie) in generatedRecipies.enumerated() {
            //Takes all the recipies which are picked (In The Data Model they have an Index indecating which day they are)
            if index < days.count {
                generatedRecipie.picked = Int16(index+1)

                for ingredient in generatedRecipie.ingredientsArray{
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
