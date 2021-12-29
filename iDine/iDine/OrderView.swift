//
//  OrderView.swift
//  iDine
//
//  Created by liuyihua on 2021/12/29.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order: Order

    func deleteItems(at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    ForEach(order.items,id:\.self){
                        item in
                        HStack{
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                Section {
                    NavigationLink(destination: CheckoutView()) {
                        Text("Place Order")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                    }
                }
               
            }
            .disabled(order.items.isEmpty)
            .navigationTitle("Order")
            .listStyle(.insetGrouped)
            .toolbar {
                EditButton()
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView().environmentObject(Order())
    }
}
