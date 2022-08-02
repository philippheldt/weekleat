//
//  WeekPlannerItems.swift
//  weekleat
//
//  Created by Philipp Jenny on 01.08.22.
//

import SwiftUI

struct WeekPlannerSwitch: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.picked)]) var recipies: FetchedResults<Recipie>
    
    var recipie: Recipie
    var dayPicked: String
    @Binding var passRecipie: Recipie?
    @Binding var showingEditScreen: Bool
    @Binding var generatedRecipies: [Recipie]
    
    @AppStorage("nudeln") private var nudeln: String = "häufig"
    @AppStorage("reis") private var reis: String = "mittel"
    @AppStorage("kartoffeln") private var kartoffeln: String = "selten"
    @AppStorage("gebackenes") private var gebackenes: String = "selten"
    @AppStorage("fleisch")  private var fleisch: String = "selten"
    @AppStorage("vegetarisch") private var vegetarisch: Bool = false
    
    @State var offset: CGFloat = 0.0
    @State var opacity: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        if getTodayWeekDay().lowercased() == dayPicked {
            
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
            ZStack{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
                    .background(Color.black)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .scaleEffect(getLoaderScaleAmount())
                    .offset(x: getLoaderOffset())
            
                ListElementLarge(recipie: recipie)
                    .offset(x: offset)
                    .scaleEffect(getCardScaleAmount())
                    .rotationEffect(Angle(degrees: getRotationAmount()))
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.spring()){
                                    offset = value.translation.width
                                    
                                }
                            }
                            .onEnded{ value in
                                withAnimation(.spring()){
                                    if offset <= -250.0 {
                                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                        impactMed.impactOccurred()
                                        offset = -600.0
                                        opacity = 0.0
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                           generateRecipie(postition: Int(recipie.picked))
                                            withAnimation(){
                                                scale = 0.0
                                                offset = 0.0
                                            }
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            withAnimation(){
                                                scale = 1.0
                                                opacity = 1.0
                                            }
                                        }
                                    } else {
                                        offset = 0.0
                                    }
                                    
                                }
                            }
                    )
                    .onTapGesture{
                        passRecipie = recipie
                        showingEditScreen.toggle()
                    }
            }
   
            
                .padding(.bottom)
        } else {
            Text(dayPicked)
                .font(.caption)
                .textCase(.uppercase)
                .foregroundColor(.gray)
                .padding([.leading, .top])
            ZStack{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
                    .background(Color.black)
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .scaleEffect(getLoaderScaleAmount())
                    .offset(x: getLoaderOffset())
            
                
                ListElement(recipie: recipie)
                    .offset(x: offset)
                    .scaleEffect(getCardScaleAmount())
                    .rotationEffect(Angle(degrees: getRotationAmount()))
                    .opacity(opacity)
                    .scaleEffect(scale)
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.spring()){
                                    offset = value.translation.width
                                    
                                }
                            }
                            .onEnded{ value in
                                withAnimation(.spring()){
                                    if offset <= -300.0 {
                                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                                        impactMed.impactOccurred()
                                        offset = -600.0
                                        opacity = 0.0
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                       
                                            withAnimation(){
                                                scale = 0.0
                                                offset = 0.0
                                            }
                                        }
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            generateRecipie(postition: Int(recipie.picked))
                                            withAnimation(){
                                                scale = 1.0
                                                opacity = 1.0
                                            }
                                            
                                        }
                                    } else {
                                        offset = 0.0
                                    }
                                    
                                }
                            }
                    )
                
                    .onTapGesture{
                        passRecipie = recipie
                        showingEditScreen.toggle()
                    }
            }
            
            
        }
    }
    
    func getTodayWeekDay()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de")
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: Date())
        return weekDay
    }
    
    func getDates()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de")
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let dateToday = dateFormatter.string(from: Date())
        return dateToday
    }
    
    func getLoaderScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset)
        let percentage = currentAmount / max
        return 0.0 + min(percentage, 0.5) * 2
    }
    
    func getLoaderOffset() -> CGFloat {
        let max = 600.0
        let start = (UIScreen.main.bounds.width / 2) - 50
        let currentAmount = abs(offset)
        let percentage = currentAmount / max
        return start - start * percentage
    }
    
    func getCardScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5) * 0.5
    }
    
    
    func getRotationAmount() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = offset
        let percentage = currentAmount / max
        let percentageAsDouble = Double(percentage)
        let maxAngle: Double = 5
        return percentageAsDouble * maxAngle
    }
    
    func generateRecipie(postition: Int) {

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
        
       
        var countNoMatches: Int = 0
        for recipie1 in generatedRecipies{
            if recipie1 == tempGeneratedRecipies[0]{
                    generateRecipie(postition: postition)
                } else {
                    countNoMatches = countNoMatches + 1
                    if countNoMatches == 7 {
                        // incase there are too less recipies it will just randomly generate without weighting
                        if tempGeneratedRecipies.count >= 7{
                            generatedRecipies[postition-1].picked = 0
                            tempGeneratedRecipies[0].picked = Int16(postition)
                            generatedRecipies[postition-1] = tempGeneratedRecipies[0]
                            
                        } else {
                            var allRecipies: [Recipie] = []
                            for recipie in recipies {
                                allRecipies.append(recipie)
                            }
                            
                            tempGeneratedRecipies = allRecipies.shuffled()
                            
                            generatedRecipies[postition-1].picked = 0
                            tempGeneratedRecipies[0].picked = Int16(postition)
                            generatedRecipies[postition-1] = tempGeneratedRecipies[0]

                        }
                        try? moc.save()
                    }
                  
                }
            
        }
        
    }
}

