//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by liuyihua on 2022/1/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!")
//            .padding()
//            .background(.red)
//        Text("Hello, world!")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(.red)
//        Button("Hello, world!") {
//            // do nothing
//            print(type(of: self.body))
//        }
//        .frame(width: 200, height: 200)
//        .background(.red)
        
        Text("Hello, world!")
            .padding()
            .background(.red)
            .padding()
            .background(.blue)
            .padding()
            .background(.green)
            .padding()
            .background(.yellow)
        
    }
//    ModifiedContent<ModifiedContent<Button<Text>, _BackgroundStyleModifier<Color>>, _FrameLayout>

//    ModifiedContent<Button<Text>, _FrameLayout>
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
