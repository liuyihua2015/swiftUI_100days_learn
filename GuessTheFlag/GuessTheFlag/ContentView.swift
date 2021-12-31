//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by liuyihua on 2021/12/30.
//

import SwiftUI

struct ContentView: View {
    

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false

    @State private var scoreTitle = ""
    
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    var body: some View {
        ZStack {
//            Color.blue
//                .ignoresSafeArea()
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
            
//            RadialGradient(stops: [
//                .init(color: .blue, location: 0.4),
//                .init(color: .red, location: 0.4),
//            ], center: .top, startRadius: 200, endRadius: 700)
//                .ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Spacer()
                Spacer()
                Text("Score: ???")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                VStack(spacing: 15) {

                    VStack {
                            Text("Tap the flag of")
                                .font(.subheadline.weight(.heavy))
                                .foregroundStyle(.secondary)
//                                .foregroundColor(.white)
                            Text(countries[correctAnswer])
                                .font(.largeTitle.weight(.semibold))
//                                .foregroundColor(.white)
                        }
                    
                    ForEach(0..<3) { number in
                        Button {
                           // flag was tapped
                            flagTapped(number)
                        } label: {
                            ZStack{
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .clipShape(Capsule())
                                    .shadow(radius: 5)
                                Text(countries[number])
                                    .foregroundColor(.black)
                            }
                           
                        }
                        
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(countries[correctAnswer])")
            }
        }
        
    }
    
    
    
       
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
