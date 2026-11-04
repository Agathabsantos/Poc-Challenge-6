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
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddWaterIntent(),
            phrases: [
                    
                    // Variações diretas e formais
                    "Inserir água no \(.applicationName)",
                    "Anotar água no \(.applicationName)",
                    "Salvar água no \(.applicationName)",
                    "Acrescentar água no \(.applicationName)",
                    "Gravar água no \(.applicationName)",
                    "Colocar água no \(.applicationName)",
                    
                    // Variações focadas em "hidratação"
                    "Registrar hidratação no \(.applicationName)",
                    "Atualizar hidratação no \(.applicationName)",
                    "Adicionar hidratação no \(.applicationName)",
                    "Inserir hidratação no \(.applicationName)",
                    
                    // Variações curtas e rápidas
                    "Mais água no \(.applicationName)",
                    "Nova água no \(.applicationName)",
                    "Marca uma água no \(.applicationName)",
                    "Hidratei no \(.applicationName)",
                    
                    // Variações conversacionais e naturais
                    "Tomei um copo de água no \(.applicationName)",
                    "Bebi um copo de água no \(.applicationName)",
                    "Acabei de beber água no \(.applicationName)",
                    "Anota que bebi água no \(.applicationName)",
                    
                    // Variações informais (nível "iOS 27")
                    "Manda uma água pra dentro no \(.applicationName)",
                    "Botei água pra dentro no \(.applicationName)"
            ],
            shortTitle: "Registrar Água",
            systemImageName: "drop.fill"
        )
    }
}
