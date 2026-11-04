//
//  PoC.swift
//  Poc-Challenge-6
//
//  Created by Leonardo Gonçalves da Silva on 29/10/26.
//

import AppIntents
import SwiftUI

struct AddWaterIntent: AppIntent {
    static let title: LocalizedStringResource = "Adicionar água"
    static let description = IntentDescription("Registra a quantidade de água consumida pelo usuário no histórico de saúde.")

    @Parameter(
        title: "Quantidade (ml)",
        inclusiveRange: (1, 5000),
        requestValueDialog: IntentDialog("Quantos ml de água você tomou?")
    )
    var quantidade: Int

    init() {}
    init(quantidade: Int) { self.quantidade = quantidade }

    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        try await requestConfirmation(
            actionName: .add,
            dialog: "Registrar \(quantidade) ml de água?"
        ) {
            HidratacaoSnippetView(quantidade: quantidade, confirmado: false)
        }

        // TODO: salvar no HealthKit aqui

        return .result(
            dialog: "Sucesso! Registrados \(quantidade) ml de água.",
            view: HidratacaoSnippetView(quantidade: quantidade, confirmado: true)
        )
    }
}

struct ShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddWaterIntent(),
            phrases: [
                "Registrar água no \(.applicationName)",
                "Bebi água no \(.applicationName)",
                "Tomei água no \(.applicationName)",
                "Adicionar água no \(.applicationName)",
                "\(.applicationName) registrar água"
            ],
            shortTitle: "Registrar Água",
            systemImageName: "drop.fill"
        )
    }
}
