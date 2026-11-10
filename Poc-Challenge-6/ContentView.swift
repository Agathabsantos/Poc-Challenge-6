//
//  ContentView.swift
//  Poc-Challenge-6
//
//  Created by Agatha Barbosa Marinho dos Santos on 29/10/26.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    // Quantidade escolhida na tela, em ml
    @State private var quantidade = 200 
    // Mensagem curta exibida depois de registrar (sucesso ou erro)
    @State private var mensagem: String?
    // Evita toques repetidos enquanto grava
    @State private var salvando = false

    // Quanto cada toque no − / + muda a quantidade
    private let passo = 50
    // Limites aceitos (iguais ao inclusiveRange do AddWaterIntent)
    private let faixa = 50...5000

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()

            // Ondas no rodapé: as mesmas do snippet (Onda e cores vêm da HidratacaoSnippetView)
            ZStack {
                OndasAgua()
                    .frame(height: 150)
                    .ignoresSafeArea(edges: .bottom)
            }
            .frame(height: 140)
            .ignoresSafeArea(edges: .bottom)

            VStack(spacing: 28) {
                Spacer()
                Spacer()

                Text("Registre aqui\nsua hidratação")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("aguaAzul"))

                // Círculo com a quantidade escolhida
                ZStack {
                    Circle()
                        .stroke(Color("aguaAzul"), lineWidth: 2)

                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("\(quantidade)")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .contentTransition(.numericText()) // número "rola" ao mudar
                        Text("ml")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color("aguaAzul"))
                }
                .frame(width: 230, height: 230)

                SeletorQuantidade(quantidade: $quantidade, passo: passo, faixa: faixa)

                // Botão principal: grava no app Saúde
                Button {
                    Task { await registrar() }
                } label: {
                    Text("Confirmar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 280, height: 56)
                        .background(Capsule().fill(Color("aguaAzul")))
                }
                .disabled(salvando)

                // Retorno para o usuário (espaço reservado para a tela não "pular")
                Text(mensagem ?? " ")
                    .font(.footnote)
                    .foregroundStyle(Color("Resultado"))
                    .multilineTextAlignment(.center)

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        // Ao abrir o app: pede permissão do Saúde (o pop-up só aparece na primeira vez)
        .task {
            do {
                try await HealthKitService.pedirAutorizacao()
            } catch {
                print("Erro no HealthKit: \(error)")
            }
        }
    }

    //Grava a quantidade escolhida no app Saúde e mostra o resultado
    private func registrar() async {
        salvando = true
        defer { salvando = false } // libera o botão ao terminar, com sucesso ou erro

        do {
            try await HealthKitService.registrarAgua(ml: quantidade)
            mensagem = "\(quantidade) ml registrados no app Saúde!"
        } catch {
            mensagem = "Não foi possível registrar. Verifique a permissão em Ajustes → Saúde."
        }
    }
}

// Botão duplo − | + para ajustar a quantidade
struct SeletorQuantidade: View {
    @Binding var quantidade: Int
    let passo: Int
    let faixa: ClosedRange<Int>

    var body: some View {
        HStack(spacing: 0) {
            botao("minus") {
                quantidade = max(faixa.lowerBound, quantidade - passo)
            }
            .disabled(quantidade <= faixa.lowerBound)

            Rectangle()
                .fill(Color("aguaAzul"))
                .frame(width: 1, height: 30)

            botao("plus") {
                quantidade = min(faixa.upperBound, quantidade + passo)
            }
            .disabled(quantidade >= faixa.upperBound)
        }
        .background(Capsule().fill(Color("aguaSeletor")))
    }

    // Um lado do seletor (ícone + ação)
    private func botao(_ icone: String, acao: @escaping () -> Void) -> some View {
        Button {
            withAnimation { acao() }
        } label: {
            Image(systemName: icone)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color("aguaAzul"))
                .frame(width: 64, height: 44)
        }
    }
}


#Preview {
    ContentView()
}
