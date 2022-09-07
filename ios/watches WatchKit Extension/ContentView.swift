//
//  ContentView.swift
//  watches WatchKit Extension
//
//  Created by Ivan Nazarov on 07.09.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    
    var body: some View {
        VStack {
            Text("Counter: \(viewModel.counter)")
                .padding()
            Button(action: {
                viewModel.counter += 1
                viewModel.sendDataMessage(
                    for: .sendCounterToFlutter,
                    data: ["counter": viewModel.counter]
                )
            }) {
                Text("+")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
