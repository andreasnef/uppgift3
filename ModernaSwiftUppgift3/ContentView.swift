//
//  ContentView.swift
//  ModernaSwiftUppgift3
//
//  Created by Andreas Nef on 05.11.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var result : String = ""
    @State var counter : Int = 0
    @State var imageLoc : String = ""

    var body: some View {
        
        VStack {
            Text("What's your next guess?")
            
            HStack {
                Button("Yes") {
                    Task {
                        await check(guess: "yes")
                    }
                }
                Button("No") {
                    Task {
                        await check(guess: "no")
                    }
                }
            }

            Text(result)

            AsyncImage(url: URL(string: imageLoc))

            Text("Try number: " + String(counter))

        }
        .padding()
        
    }
        
    func check(guess: String) async {
        let yesnoapi = "https://yesno.wtf/api"
        
        let apiUrl = URL(string: yesnoapi)
        
        counter = counter + 1
        
        do {
            let (answerdata, _) = try await URLSession.shared.data(from: apiUrl!)
            
            if let answerObject = try? JSONDecoder().decode(Answer.self, from: answerdata) {

                if (guess == answerObject.answer) {
                    result = "Correct!"
                }
                else {
                    result = "Better luck next time..."
                }
                
                // Should be improved with a class that supports animated GIFs...
                imageLoc = answerObject.image
            }
            else {
                print("Could not decode JSON")
            }
            
            
        } catch {
            print("Could not get data")
        }
    }
    
}

#Preview {
    ContentView()
}

struct Answer : Codable {
    var answer : String
    var forced : Bool
    var image : String
}
