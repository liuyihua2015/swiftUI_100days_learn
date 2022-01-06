//
//  ContentView.swift
//  WeSplit
//
//  Created by liuyihua on 2021/12/30.
//

import SwiftUI

struct ContentView: View {

    @FocusState private var amountIsFocused:Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]

    @State private var checkAmount = 0.0//支票金额
    @State private var numberOfPeople = 2//人数
    @State private var tipPercentage = 20//百分比
    
    
    //总金额
    var totalAmount: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue  = checkAmount/100 * tipSelection
        let grandTotal = checkAmount + tipValue
        return grandTotal
    }
    
    //每个人金额
    var totalPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
//        let tipSelection = Double(tipPercentage)
//        let tipValue  = checkAmount/100 * tipSelection
//        let grandTotal = checkAmount + tipValue
        let amountPerPerson = totalAmount / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form{
                Section{
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                } header: {
                    Text("Amount")
                }
                Section{
                    Text(totalPerson,format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                    Picker("Nember of people",selection: $numberOfPeople){
                        ForEach(2 ..< 100){
                            Text("\($0) people")
                        }
                    }
                } header: {
                    Text("Amount per person")
                }
                
                Section{
                    Text(totalAmount,format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total Amount")
                }
               
                Section{
                    Picker("Tip percentage",selection: $tipPercentage) {
//                        ForEach(tipPercentages,id: \.self){
//                            Text($0,format: .percent)
//                        }
                        ForEach(0..<101){
                            Text($0,format: .percent)
                        }
                    }
//                    .pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }
            }
            .navigationTitle("WeSplit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
