//
//  RezeptSammlungElement.swift
//  weekleat
//
//  Created by Philipp Jenny on 02.08.22.
//

import SwiftUI

struct RezeptSammlungElement: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var recipies: FetchedResults<Recipie>
    
    @State var recipie: Recipie
    
    @State var offset: CGFloat = 0.0
    @State var opacity: CGFloat = 1.0
    @State var scale: CGFloat = 1.0
    
    
    var body: some View {
        ZStack{
            Image("bin.icon.white")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 21, height: 21)
                .padding()
                .background(Color.black)
                .cornerRadius(5)
                .foregroundColor(Color.white)
                .scaleEffect(getLoaderScaleAmount())
                .offset(x: getLoaderOffset())
            
            VStack{
                HStack{
                    ZStack{
                        Image("backgroundRed")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Image("lasagne")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                    }
                    VStack(alignment: .leading, spacing: 3){
                        Text(recipie.wrappedTitle)
                            .font(.title3)
                            .fontWeight(.bold)
                            .lineLimit(1)
                             .truncationMode(.tail)
                        HStack{
                            TagView(tagName: String(recipie.portion), tagIcon: "portion.icon.black")
                            ForEach(recipie.wrappedTags.components(separatedBy: ","), id: \.self){ tag in
                                TagSingle(tagIcon: "")
                            }
                        }
                       
                    }.padding(.leading)
                    Spacer()
                    Image(systemName: "chevron.forward")
                        .font(Font.system(size: 15, weight: .light))
                        .foregroundColor(.gray)
                        .padding()
                }
                
            }
            .cornerRadius(5)
            .background(Color.white)
            .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 0.5)
                )
            .padding(.horizontal)
            
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
                                    withAnimation(){
                                        scale = 0.0
                                        offset = 0.0
                                    }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation(){
                                        moc.delete(recipie)
                                        try? moc.save()
                                    }
                                }
                            } else {
                                offset = 0.0
                            }
                            
                        }
                    }
            )
        }
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
    
}

//struct RezeptSammlungElement_Previews: PreviewProvider {
//    static var previews: some View {
//        RezeptSammlungElement()
//    }
//}
