//
//  ItemRow.swift
//  iDine
//
//  Created by liuyihua on 2021/12/29.
//

import SwiftUI

struct ItemRow: View {
    let colors: [String: Color] = ["D": .purple, "G": .black, "N": .red, "S": .blue, "V": .green]

    let item: MenuItem
    var body: some View {
        HStack{
            Image(item.thumbnailImage)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray,lineWidth: 2))
            VStack(alignment: .leading){
                
                Text(item.name)
                    .font(.headline)
                Text(String("$\(item.price)"))
            }
            Spacer()
            ForEach(item.restrictions,id: \.self) { restriction in
                Text(restriction)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(5)
                    .background(colors[restriction,default: .black])
                    .clipShape(Circle())
                    .foregroundColor(.white)
                
            }
        }
    }
}

struct ItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemRow(item: MenuItem.example)
    }
}
