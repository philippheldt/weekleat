//
//  RezeptSammlung.swift
//  weekleat
//
//  Created by Philipp Jenny on 24.06.22.
//

import SwiftUI

struct RezeptSammlung: View {
    

//    @Environment(\.managedObjectContext) var moc
//
//    @FetchRequest(sortDescriptors: [SortDescriptor(\.title)]) var recipies: FetchedResults<Recipie>
//
    @StateObject private var vm = ViewModel()

    
    
    
    var body: some View {
        NavigationView{
            if vm.recipies.count > 0{
                List(vm.recipies) {recipie in
                    if vm.searchText == "" {
                        ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: tagConverter(tagString: recipie.wrappedTags), backgroundColor: "PureWhite", portion: Int(recipie.portion))
                            .contextMenu{
                                Button{
                                    vm.editRecipie(recipie: recipie)
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                    Text("Bearbeiten")
                                }
                                Button{
                                    // Action
                                } label: {
                                    Image(systemName: "star")
                                    Text("Favorit")
                                }
                                Button{
                                    withAnimation{
                       //                 vm.deleteRecipie(recipie: recipie)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                    Text("Löschen")
                                }
                            }
                            .onTapGesture{
                                vm.editRecipie(recipie: recipie)
                            }
                            .swipeActions{
                                Button{
                                    withAnimation{
                             //           vm.deleteRecipie(recipie: recipie)
                                    }
                                    
                                } label: {
                                    Label("", systemImage: "trash")
                                }
                                .tint(Color("RedLight"))
                            }
                            .swipeActions(edge: .leading){
                                Button{
                                    print("Star")
                                } label: {
                                    Label("", systemImage: "star")
                                }
                                .tint(Color("YellowLight"))
                            }
                        
                        
                        
                    } else {
                        if recipie.wrappedTitle.lowercased().contains(vm.searchText.lowercased()) {
                            ListItemElement(titleText: recipie.wrappedTitle , titleImage: recipie.wrappedFoodType, color: intToColorTheme(colorInt: Int(recipie.colorTheme)), tags: [.Veggi, .Schnell], backgroundColor: "PureWhite", portion: Int(recipie.portion))
                            
                                .onTapGesture{
                                    vm.passRecipie = recipie
                                    vm.showingEditScreen.toggle()
                                }
                                .swipeActions{
                                    Button{
                                   //     moc.delete(recipie)
                                   //     try? moc.save()
                                    } label: {
                                        Label("", systemImage: "trash")
                                    }
                                    .tint(Color("RedLight"))
                                }
                                .swipeActions(edge: .leading){
                                    Button{
                                        print("Star")
                                    } label: {
                                        Label("", systemImage: "star")
                                    }
                                    .tint(Color("YellowLight"))
                                }
                            
                        }
                    }
                    
                    
                    
                }
                .searchable(text: $vm.searchText)
                .navigationTitle("Rezepte")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            vm.showingAddScreen.toggle()
                        } label: {
                            Label("", systemImage: "plus")
                        }
                    }
                    
                }
                .sheet(isPresented: $vm.showingAddScreen) {
                    AddRecipieView()
                }
                
                .sheet(isPresented: $vm.showingEditScreen){
                    EditRecipieView(rezept: vm.passRecipie ?? vm.recipies[0])
                }
            }
            
        }
    }
    
}

//struct RezeptSammlung_Previews: PreviewProvider {
//    static var previews: some View {
//        RezeptSammlung()
//    }
//}
