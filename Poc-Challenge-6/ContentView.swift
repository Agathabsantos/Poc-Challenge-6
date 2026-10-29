//
//  ContentView.swift
//  Poc-Challenge-6
//
//  Created by Agatha Barbosa Marinho dos Santos on 29/10/26.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "drop.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("Registo de Água")
                .font(.title)
            
            // Este botão chama diretamente a tua AddWaterIntent
            Button("Registrar 250 ml", intent: AddWaterIntent(quantidade: 250))
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
