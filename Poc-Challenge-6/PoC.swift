//
//  PoC.swift
//  Poc-Challenge-6
//
//  Created by Leonardo Gonçalves da Silva on 29/10/26.
//

import AppIntents
import SwiftUI

struct AddWaterIntent: AppIntent{
    static let title: LocalizedStringResource = "Adicionar agua"
    static let description = IntentDescription("Registra uma quantidade de água bebida.")
    
    @Parameter(
        title: "Quantidade(ml)",
        requestValueDialog: "Quantos ml de água você bebeu?"
    )
    var quantidade: Int
    
    init() {}
    init(quantidade: Int) { self.quantidade = quantidade }
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView{
        print("💧 AddWaterIntent executado: \(quantidade) ml")
        //let mensagem = "Sucesso! Registrados \(quantidade) ml de agua"
        //return .result(dialog: IntentDialog(stringLiteral: mensagem))
        try await requestConfirmation(
            actionName: .add, dialog: "Registrar \(quantidade) ml de água?"
        ){
            HidratacaoSnippetView(quantidade: quantidade, confirmado: false)
        }
        
        return .result(
            dialog: "Sucesso! Registrados \(quantidade) ml de água.",
            view: HidratacaoSnippetView(quantidade: quantidade)
        )
    }
    
}

struct ShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddWaterIntent(),
            phrases: [
                "Registrar água no \(.applicationName)",
                "Bebi água no \(.applicationName)"
            ],
            shortTitle: "Registrar Água",
            systemImageName: "drop.fill"
        )
    }
}
