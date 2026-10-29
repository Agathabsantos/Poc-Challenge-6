//
//  PoC.swift
//  Poc-Challenge-6
//
//  Created by Leonardo Gonçalves da Silva on 29/10/26.
//
import AppIntents
import SwiftUI
import HealthKit

struct PoC {
   private let intents: AddWaterIntent
   
}
struct AddWaterIntent: AppIntent{
    
    static let title: LocalizedStringResource = "Adicionar agua"
    
    @Parameter(title: "Quantidade(ml)", default: 0)
    var quantidade: Double
    
    func perform() async throws -> some IntentResult {
        let mensagem = "Sucesso! Registrados \(quantidade) ml de agua"
        return .result(dialog: IntentDialog(stringLiteral: mensagem))
    }
    
}

struct ShortcutsProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddWaterIntent(),
            phrases: [
                "Registrar agua no \(.applicationName)",
                "Bebi agua no \(.applicationName)"
            ],
            shortTitle: "Registrar Água",
            systemImageName: "drop.fill"
        )
    }
}
