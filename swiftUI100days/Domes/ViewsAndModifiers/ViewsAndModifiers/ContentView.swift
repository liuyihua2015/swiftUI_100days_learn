//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by liuyihua on 2022/1/4.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
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
//
//        Text("Hello, world!")
//            .padding()
//            .background(.red)
//            .padding()
//            .background(.blue)
//            .padding()
//            .background(.green)
//            .padding()
//            .background(.yellow)
        
//        VStack {
//            Text("Gryffindor")
//                .font(.largeTitle)
//            Text("Hufflepuff")
//            Text("Ravenclaw")
//            Text("Slytherin")
//        }
//        .font(.title)
        
//        VStack {
//            Text("Gryffindor")
//                .blur(radius: 0)
//            Text("Hufflepuff")
//            Text("Ravenclaw")
//            Text("Slytherin")
//        }
//        .blur(radius: 5)
        
        
        
        
//    }
//    ModifiedContent<ModifiedContent<Button<Text>, _BackgroundStyleModifier<Color>>, _FrameLayout>

//    ModifiedContent<Button<Text>, _FrameLayout>
//}
//
//struct ContentView: View {
//    var body: some View {
//        VStack(spacing: 10) {
////            CapsuleText(text: "First")
////                .foregroundColor(.yellow)
////            CapsuleText(text: "Second")
////                .foregroundColor(.red)
//            Text("Hello world")
//                .titleStyle()
////                .modifier(Title())
//
//            Color.blue
//                .frame(width: 300, height: 200)
//                .watermarked(with: "Hacking with Swift")
//        }
//    }
//}


//自定义视图
struct ContentView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
//                Text("R\(row) C\(col)")
//            HStack {
                    Image(systemName: "\(row * 4 + col).circle")
                    Text("R\(row) C\(col)")
                }
            
//            }
        }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content

    var body: some View {
        VStack {
                ForEach(0..<rows, id: \.self) { row in
                    HStack {
                        ForEach(0..<columns, id: \.self) { column in
                            content(row, column)
                        }
                    }
                }
            }
    }
}

struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
    }
}

//view拓展
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

//自定义修饰符
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
