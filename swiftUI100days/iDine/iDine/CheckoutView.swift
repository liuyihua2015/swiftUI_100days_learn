//
//  CheckoutView.swift
//  iDine
//
//  Created by liuyihua on 2021/12/29.
//

import SwiftUI

struct CheckoutView: View {
    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    let tipAmounts = [10, 15, 20, 25, 30]
    let pickupTimes = ["Now", "Tonight", "Tomorrow Morning"]

    
    @EnvironmentObject var order: Order
    @State private var paymentType:String = "Cash"
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 15
    @State private var showingPaymentAlert = false
    @State private var pickupTimeType:String = "Now"
    
    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        let total = Double(order.total)
        let tipValue = total / 100 * Double(tipAmount)

        return formatter.string(from: NSNumber(value: total + tipValue)) ?? "$0"
    }
    
    var body: some View {
        Form{
            Section{
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self){
                        Text($0)
                    }
                }
            }
            Section{
                Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
                if addLoyaltyDetails {
                    TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
            }
            Section(header: Text("Add a tip ?")) {
                Picker("Percentage:", selection: $tipAmount) {
                    ForEach(tipAmounts, id: \.self){
                        Text("\($0)%")
                    }
                }
                .pickerStyle(.segmented)
            }
            Section{
                Picker("Pickup time?", selection: $pickupTimeType) {
                    ForEach(pickupTimes, id: \.self){
                        Text($0)
                    }
                }
            }
            Section(header:
                Text("TOTAL: \(totalPrice)")
                        .font(.largeTitle)
            ) {
                Button("Confirm order") {
                    // place the order
                    
                    showingPaymentAlert.toggle()

                }
            }
            
        }
        .alert(isPresented: $showingPaymentAlert) {
            // more to come
            Alert(title: Text("Order confirmed"), message: Text("Your total was \(totalPrice) – thank you!"), dismissButton: .default(Text("OK")))

        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView().environmentObject(Order())
    }
}
