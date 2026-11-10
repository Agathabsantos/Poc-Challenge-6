//
//  HidratacaoSnippetView.swift
//  Poc-Challenge-6
//
//  Created by Agatha Barbosa Marinho dos Santos on 29/10/26.
//

import SwiftUI

struct HidratacaoSnippetView: View {
    let quantidade: Int
    var confirmado: Bool = true

    var body: some View {
        VStack(spacing: 8) {
            Text(confirmado ? "Hidratação registrada!" : "Registrar hidratação")
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .center)

            // Quantidade em destaque: número grande + "ml" menor
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(quantidade)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                Text("ml")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
            }
        }
        .foregroundStyle(Color.aguaAzul)
        .padding(.top, 24)      // espaço acima do título
        .padding(.bottom, 80)   // espaço reservado para as ondas
        .background {
            ZStack(alignment: .bottom) {
                // Fundo em degradê: branco no topo, azul bem claro embaixo
                LinearGradient(
                    colors: [.white, .aguaFundo],
                    startPoint: .top,
                    endPoint: .bottom
                )

                // Ondas no rodapé do card
                OndasAgua()
                    .frame(height: 90)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

struct Onda: Shape {
    var nivel: CGFloat
    var amplitude: CGFloat
    var fase: CGFloat
    var frequencia: CGFloat = 1

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let meio = rect.height * nivel

        // Desenha a linha da onda da esquerda para a direita, de 2 em 2 pontos
        path.move(to: CGPoint(x: 0, y: meio))
        for x in stride(from: 0, through: rect.width, by: 2) {
            let progresso = x / rect.width
            let y = meio + sin(progresso * 2 * .pi * frequencia + fase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        // Garante o último ponto exatamente na borda direita
        // (o "by: 2" pode parar um pouco antes quando a largura não é par,
        // o que deixava uma fresta branca na direita)
        let yFinal = meio + sin(2 * .pi * frequencia + fase) * amplitude
        path.addLine(to: CGPoint(x: rect.width, y: yFinal))

        // Fecha a forma pelos cantos de baixo para poder pintar
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

// Ondas do rodapé, iguais no app e no snippet do Siri
struct OndasAgua: View {
    var body: some View {
        ZStack {
            // Onda de trás: crista no meio-direita
            Onda(nivel: 0.2, amplitude: 14, fase: 0.3)
                .fill(Color.aguaCiano)
            // Onda da frente: crista à esquerda, vale no meio-direita, sobe na borda direita
            Onda(nivel: 0.4, amplitude: 18, fase: .pi, frequencia: 1.25)
                .fill(Color.aguaAzul)
        }
    }
}

#Preview("Confirmação") {
    HidratacaoSnippetView(quantidade: 200, confirmado: false)
}

#Preview("Resultado") {
    HidratacaoSnippetView(quantidade: 200)
}
