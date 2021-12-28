//
//  ContentView.swift
//  iDine
//
//  Created by liuyihua on 2021/12/28.
//

import SwiftUI

struct ContentView: View {
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    var body: some View {
        NavigationView{
            List{
                ForEach(menu.indices,id:\.self){ i in
                    let secton = self.menu[i]
                    Section(header:Text(secton.name)) {
                        ForEach(secton.items.indices,id:\.self){ j in
                            let item = secton.items[j]
                            Text(item.name)
                        }
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
