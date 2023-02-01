//
//  ContentView.swift
//  EdurtainmentApp
//
//  Created by Dev on 31/01/2023.
//

import SwiftUI

enum Difficulty: String, CaseIterable{
    case easy, medium, hard
}

enum AppState: String, CaseIterable{
    case Setting, Game, Result
}

struct ContentView: View {
    @State private var number = 2
    @State private var answer = 0
    @State private var range = 10
    @State private var difficulty = Difficulty.easy
    @State private var result = true
    @State private var numberOfQuestions = 0
    @State private var correctAnswers = [String]()
    @State private var wrongAnswers = [String]()
    @State private var maxQuestions = 10
    @State private var multiplier = 1
    @State private var showCorrectEq = false
    @State private var gameState = AppState.Setting

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                switch gameState {
                case .Result:
                    Text("Result")
                        .font(.largeTitle)
                    
                    Section{
                        HStack{
                            Text("Number of Questions Asked:")
                                .foregroundColor(.white)
                                .font(.system(size: 24).bold())
                            Spacer()
                            Text("\(maxQuestions)")
                                .foregroundColor(.gray)
                                .font(.system(size: 36).bold())
                        }
                        .padding()
                        
                        HStack{
                            Text("Correct Answers: ")
                                .foregroundColor(.white)
                                .font(.system(size: 24).bold())
                            Spacer()
                            Text("\(correctAnswers.count)")
                                .foregroundColor(.indigo)
                                .font(.system(size: 36).bold())
                        }
                        .padding()
                        
                        HStack{
                            Text("Wrong Answers: ")
                                .foregroundColor(.white)
                                .font(.system(size: 24).bold())
                            Spacer()
                            Text("\(wrongAnswers.count)")
                                .foregroundColor(.red)
                                .font(.system(size: 36).bold())
                        }
                        .padding()
                    }
                    HStack {
                        Text("Difficutly: \(difficulty.rawValue)")
                        Spacer()
                        Button("Play Again") {
                            resetGame()
                        }
                    }
                    .padding()
                    
                    
                    HStack {
                        Button("Wrong Answers") {
                            showCorrectEq = false
                        }
                        .foregroundColor(showCorrectEq ? .gray : .blue)
                        
                        Spacer()
                        
                        Button("Correct Answers") {
                            showCorrectEq = true
                        }
                        .foregroundColor(showCorrectEq ? .blue : .gray)
                    }
                    .padding()
                    
                    if showCorrectEq{
                        ForEach(correctAnswers, id: \.self) { equation in
                            Text(equation)
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                                .background(.ultraThinMaterial)
                        }
                    } else {
                        ForEach(wrongAnswers, id: \.self) { equation in
                            Text(equation)
                                .font(.system(size: 24))
                                .foregroundColor(.red)
                                .background(.ultraThinMaterial)
                        }
                    }
                    
                    Spacer()

                case .Game:
                    VStack {
                        Text("GAME")
                            .font(.headline)
                        
                        Spacer()
                        
                        if result {
                            Image(systemName: "circle")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                        } else  {
                            Image(systemName: "circle")
                                .imageScale(.large)
                                .foregroundColor(.red)
                        }
                        
                        HStack {
                            Text("\(number) x \(multiplier) = ")
                                .font(.system(size: 36).bold())
                            Spacer()
                            
                            TextField("Answer", value: $answer, format: .number)
                                .frame(width: 100)
                                .font(.system(size: 36).bold())
                                .foregroundColor(.white)
                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                        }
                        .onSubmit {
                            nextQuestion(multi1: multiplier)
                        }
                        Text("Remining Questions: \(maxQuestions - numberOfQuestions)")
                        Spacer()
                        Button("Setting") {
                            resetGame()
                        }
                    }
                    .padding()
                case .Setting:
                    VStack{
                        Section {
                            Text("Setting")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Section {
                            Stepper("Number:  \(number)", value: $number, in: 1...10)
//                                Stepper("Toughness:  \(toughness)", value: $toughness, in: 0...20, step: 5)
                            
                            Stepper("MaxQuestions:  \(maxQuestions)", value: $maxQuestions, in: 10...(difficulty == Difficulty.easy ? 10 : 30), step: 10)
                            HStack {
                                Text("Select Difficulty")
                                Spacer()
                                Picker("Select Difficulty", selection: $difficulty) {
                                    ForEach(Difficulty.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                            }
                            
                        }
                        Spacer()
                    }
                    .padding()
                    Button("Start") {
                        gameState = AppState.Game
                        setRange()
                        multiplier = Int.random(in: 1...range)
                    }
                }
            }
        }
    }
    
    func generateQuestions() {
        
    }
    
    func setRange () {
        switch difficulty{
        case .easy:
            range = 10
        case .medium:
            range = 50
        case .hard:
            range = 100
        }
    }
    
    func nextQuestion(multi1: Int) {
        result = checkAnswer(multi: multi1)
        multiplier = Int.random(in: 1...range)
        answer = 0
        numberOfQuestions += 1
        
        result ? (correctAnswers.insert("\(number) times \(multi1) is equals to \(number*multi1)", at: 0)) : (wrongAnswers.insert("\(number) times \(multi1) is not \(answer), its equals to \(number*multi1)", at: 0))
        checkRange()
    }
    
    func checkRange() {
        if numberOfQuestions == maxQuestions {
//            showingReuslts.toggle()
            gameState = AppState.Result
        }
    }
    
    func checkAnswer(multi: Int) -> Bool {
        return number * multi == answer
    }
    
    func resetGame() {
        number = 2
        answer = 0
        range = 3
        gameState = AppState.Setting
        difficulty = Difficulty.easy
        result = true
        numberOfQuestions = 1
        correctAnswers = [String]()
        wrongAnswers = [String]()
        maxQuestions = 10
        multiplier = 1
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
