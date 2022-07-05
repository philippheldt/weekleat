//
//  SettingsView.swift
//  weekleat
//
//  Created by Philipp Jenny on 29.06.22.
//
import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    let options: [String] = ["selten", "mittel", "häufig"]
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
    
    @AppStorage("vegetarisch") private var vegetarisch: Bool = false
    @AppStorage("vegan") private var vegan: Bool = false
    @AppStorage("fleisch")  private var fleisch: String = "selten"
    
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    HStack{
                        Text("Tage")
                        Spacer()
                        HStack{
                            Button{
                                montag.toggle()
                            } label: {
                                Text("M")
                                    .font(.caption)
                            }
                            .frame(width: 28, height: 28)
                            .background(montag ? Color("BlueDark") : Color("Gray"))
                            .cornerRadius(100)
                            .foregroundColor(montag ? Color("BlueLight") : Color("BlueDark"))
                            .buttonStyle(BorderlessButtonStyle())
                            
                            
                            Button{
                                dienstag.toggle()
                            } label: {
                                Text("D")
                                    .font(.caption)
                            }
                            .frame(width: 28, height: 28)
                            .background(dienstag ? Color("BlueDark") : Color("Gray"))
                            .cornerRadius(100)
                            .foregroundColor(dienstag ? Color("BlueLight") : Color("BlueDark"))
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button{
                                mittwoch.toggle()
                            } label: {
                                Text("M")
                                    .font(.caption)
                            }
                            .frame(width: 28, height: 28)
                            .background(mittwoch ? Color("BlueDark") : Color("Gray"))
                            .cornerRadius(100)
                            .foregroundColor(mittwoch ? Color("BlueLight") : Color("BlueDark"))
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button{
                                donnerstag.toggle()
                            } label: {
                                Text("D")
                                    .font(.caption)
                            }
                            .frame(width: 28, height: 28)
                            .background(donnerstag ? Color("BlueDark") : Color("Gray"))
                            .cornerRadius(100)
                            .foregroundColor(donnerstag ? Color("BlueLight") : Color("BlueDark"))
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button{
                                freitag.toggle()
                            } label: {
                                Text("F")
                                    .font(.caption)
                            }
                            .frame(width: 28, height: 28)
                            .background(freitag ? Color("BlueDark") : Color("Gray"))
                            .cornerRadius(100)
                            .foregroundColor(freitag ? Color("BlueLight") : Color("BlueDark"))
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button{
                                samstag.toggle()
                            } label: {
                                Text("S")
                                    .font(.caption)
                            }
                            .frame(width: 28, height: 28)
                            .background(samstag ? Color("BlueDark") : Color("Gray"))
                            .cornerRadius(100)
                            .foregroundColor(samstag ? Color("BlueLight") : Color("BlueDark"))
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button{
                                sonntag.toggle()
                            } label: {
                                Text("S")
                                    .font(.caption)
                            }
                            .frame(width: 28, height: 28)
                            .background(sonntag ? Color("BlueDark") : Color("Gray"))
                            .cornerRadius(100)
                            .foregroundColor(sonntag ? Color("BlueLight") : Color("BlueDark"))
                            .buttonStyle(BorderlessButtonStyle())
                            
                        }
                        
                    }
                } header: {
                Text("Häufigkeit")
            }
            Section {
                    HStack{
                        Text("Nudeln")
                        Spacer()
                        Picker("Nudeln", selection: $nudeln) {
                            ForEach(options, id:\.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    
                    HStack{
                        Text("Reis")
                        Spacer()
                        Picker("Nudeln", selection: $reis) {
                            ForEach(options, id:\.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    
                    HStack{
                        Text("Kartoffeln")
                        Spacer()
                        Picker("Kartoffeln", selection: $kartoffeln) {
                            ForEach(options, id:\.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    
                    HStack{
                        Text("Gebackenes")
                        Spacer()
                        Picker("Gebackenes", selection: $gebackenes) {
                            ForEach(options, id:\.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                   
                    
                } header: {
                    Text("Rezeptgenerierung")
                }
                
                Section{
                    HStack{
                        Text("Vegetarisch")
                        Spacer()
                        Toggle("", isOn: $vegetarisch)
                            .onChange(of: vegetarisch) { value in
                                if vegetarisch == true {
                                    vegan = false
                                    }
                                }
                    }
                    HStack{
                        Text("Vegan")
                        Spacer()
                        Toggle("", isOn: $vegan)
                            .onChange(of: vegan) { value in
                                if vegan == true {
                                    vegetarisch = false
                                    }
                                }
                    }
                    HStack{
                        Text("Fleisch")
                        Spacer()
                        Picker("Fleisch", selection: $fleisch) {
                            ForEach(options, id:\.self) { option in
                                Text(option)
                            }
                        }
                        .disabled(vegetarisch == true || vegan == true )
                        .pickerStyle(.segmented)
                        .fixedSize()
                    }
                    
                } header: {
                    Text("Ernährungsweise")
                }
                
                
            }
            .navigationTitle("Einstellungen")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
