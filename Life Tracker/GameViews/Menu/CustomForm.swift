//
//  CustomForm.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/12/26.
//

import SwiftUI

struct CustomForm: View {
    @State var nameText: String = "Other"
    @State var color: Color = colors[40]
    @State var showColorPicker = false
    @FocusState private var isFocused: Bool
    @State private var selection: TextSelection? = nil
    
    @Binding var showCustomForm: Bool
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isFocused = false
                        showColorPicker = false
                    }
                }
            VStack(spacing: 0) {
                Text("Custom Form") //HEADING
                    .heading()
                    .foregroundStyle(.white)
                    .allowsHitTesting(false)
                VStack(alignment: .leading) {
                    //NAME SECTION
                    Text("Name: ")
                        .large()
                        .foregroundStyle(.white)
                        .allowsHitTesting(false)
                    NameField(nameText: $nameText, selection: $selection, isFocused: _isFocused)
                        .padding()
                        .background(Color(218,218,218))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    //COLOR SECTION
                    Text("Color: ")
                        .large()
                        .foregroundStyle(.white)
                        .allowsHitTesting(false)
                    HStack {
                        Text("Select a Color: ")
                            .body()
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        
                        Button(action: {
                            withAnimation {
                                showColorPicker.toggle()
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(color)
                                .stroke(.white, lineWidth: 2)
                                .frame(width: 50, height: 50)
                            
                        }
                        

                    }
                    
                    Spacer()
                    //PREVIEW
                    Text("Preview: ")
                        .large()
                        .foregroundStyle(.white)
                        .allowsHitTesting(false)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .stroke(.white, lineWidth: 4)
                        VStack(spacing: 0) {
                            UnevenRoundedRectangle(10,0,0,10)
                                .fill(color)
                            UnevenRoundedRectangle(0,10,10,0)
                                .fill(color)
                            
                        }
                        VStack(spacing: 0) {
                            Text("0")
                                .boldNumberStyle()
                            Image(systemName: "questionmark.circle")
                                .iconStyle()
                        }
                        VStack {
                            Spacer()
                            Text("\(nameText)")
                                .small()
                                .padding()
                        }
                            
                    }
                    .foregroundStyle(contrastTextColor(color))
                    .frame(maxHeight: 250)
                    .allowsHitTesting(false)
                    //CANCEL and SAVE
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showCustomForm = false
                            }
                        }) {
                            ButtonText(text: "Cancel")
                        }
                        .overlay(
                            ButtonBorder(text: "Cancel")
                        )
                        Spacer()
                        Button(action: {
                            ValueViewModel.shared.selectValue(name: String(nameText), count: 0, iconName: "customIcon", rgb: color.toRGB() ?? (125, 125, 125), custom: true)
                            withAnimation {
                                showCustomForm = false
                            }
                        }) {
                            Text("Save")
                                .body()
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxHeight: 65)
                                .background(.blue)
                                .cornerRadius(25)
                        }
                        .overlay(
                            ButtonBorder(text: "Save")
                        )
                        Spacer()
                    }
                    Spacer()
                        .allowsHitTesting(false)
                }
                .padding()
            }
            .onChange(of: color) {
                withAnimation {
                    showColorPicker = false
                }
            }
            .sheet(isPresented: $showColorPicker) {
                CustomColorPicker(selectedColor: $color)
                    .offset(y: 10)
                    .presentationDetents([.height(328)])
                   
            }
        }
        .padding(.top)
        .ignoresSafeArea(edges: .bottom)
    }
    
}

struct NameField: View {
    @Binding var nameText: String
    @Binding var selection: TextSelection?
    @FocusState var isFocused: Bool
    let characterLimit = 10
    var body: some View {
        
        
        
        TextField("Name", text: $nameText, prompt: (Text("Enter name...")))
            .focused($isFocused)
            .onChange(of: isFocused) { oldValue, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        UIApplication.shared.sendAction(#selector(UIResponder.selectAll(_:)), to: nil, from: nil, for: nil)
                    }
                }
            }
            .onChange(of: nameText) { oldValue, newValue in
                if newValue.count > characterLimit {
                    self.nameText = String(newValue.prefix(characterLimit))
                }
            }
            .autocorrectionDisabled(true)
            .submitLabel(.done)
    }
}

#Preview {
    CustomForm(showCustomForm: .constant(true))
}
