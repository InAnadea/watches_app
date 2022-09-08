//
//  ContentView.swift
//  watches WatchKit Extension
//
//  Created by Ivan Nazarov on 07.09.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    
    fileprivate func sendScore() {
        viewModel.sendDataMessage(
            for: .sendScoreToFlutter,
            data: ["score": viewModel.score]
        )
    }
    
    fileprivate func sendHole() {
        viewModel.sendDataMessage(
            for: .sendHoleToFlutter,
            data: ["hole": viewModel.hole]
        )
    }
    
    var body: some View {
        HStack{
            VStack {
                Text("Score: \(viewModel.score)")
                    .padding()
                Button(action: {
                    viewModel.score += 1
                    sendScore()
                }) {
                    Text("+")
                }
                Button(action: {
                    viewModel.score -= 1
                    sendScore()
                }) {
                    Text("-")
                }.disabled(viewModel.score <= 0)
            }
            VStack {
                Text("Hole: \(viewModel.hole)")
                    .padding()
                Button(action: {
                    viewModel.hole += 1
                    sendHole()
                }) {
                    Text("+")
                }
                Button(action: {
                    viewModel.hole -= 1
                    sendHole()
                }) {
                    Text("-")
                }.disabled(viewModel.hole <= 1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
