//
//  HealthKitService.swift
//  Poc-Challenge-6
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/11/26.
//

import HealthKit

enum HealthKitService {
    // a porta de entrada: um único HKHealthStore para o app todo
    static let store = HKHealthStore()
    
    //o tipo de dado que vamos usar:
    //.dietaryWater é um tipo de dado do HealthKit, sendo água ingerida pela alimentação
    static let tipoAgua = HKQuantityType(.dietaryWater)
    
    //Pedir permissao para escrever e ler água
    static func pedirAutorizacao() async throws {
        //pergunta ao sistema se este aparelho tem o banco de dados do Saúde
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        //pop-up de permissão do app Saúde
        try await store.requestAuthorization(
            toShare: [tipoAgua], //escrever
            read: [tipoAgua] //ler
        )
    }
    
    //salvar um registro de agua
    static func registrarAgua(ml: Int) async throws{
        //valor + unidade (ml)
        let quantidade = HKQuantity(
            unit: .literUnit(with: .milli),
            doubleValue: Double(ml)
        )
        
        // o registro: tipo + quantidade + quando aconteceu
        let amostra = HKQuantitySample(
            type: tipoAgua,
            quantity: quantidade,
            start: .now,
            end: .now
        )
        
        try await store.save(amostra)
    }
    
    // ler quanto foi bebido hoje (da meia-noite até agora)
    static func totalDeHoje() async throws -> Int {
        // Filtro: só registros de hoje (da meia-noite até agora)
        let inicioDoDia = Calendar.current.startOfDay(for: .now)
        let filtroHoje = HKQuery.predicateForSamples(withStart: inicioDoDia, end: .now)

        // Pergunta: "some todos os registros de água de hoje"
        //    .cumulativeSum: o próprio HealthKit soma os registros pra gente
        let consulta = HKStatisticsQueryDescriptor(
            predicate: .quantitySample(type: tipoAgua, predicate: filtroHoje),
            options: .cumulativeSum
        )

        let resultado = try await consulta.result(for: store)
        let ml = resultado?.sumQuantity()?.doubleValue(for: .literUnit(with: .milli)) ?? 0
        return Int(ml)
    }
    
    
}
