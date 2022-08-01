//
//  DayPickerView.swift
//  weekleat
//
//  Created by Philipp Jenny on 01.08.22.
//

import SwiftUI

struct DayPickerView: View {
    @AppStorage("montag") private var montag: Bool = true
    @AppStorage("dienstag") private var dienstag: Bool = true
    @AppStorage("mittwoch")  private var mittwoch: Bool = true
    @AppStorage("donnerstag")  private var donnerstag: Bool = true
    @AppStorage("freitag") private var freitag: Bool = true
    @AppStorage("samstag")  private var samstag: Bool = true
    @AppStorage("sonntag")  private var sonntag: Bool = true
    
    var body: some View {
        HStack{
            HStack{
                Button{
                    montag.toggle()
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
    }
}

struct DayPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DayPickerView()
    }
}
