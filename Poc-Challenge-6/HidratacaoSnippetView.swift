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
                .font(.title3.bold())
                .frame(maxWidth: .infinity, alignment: confirmado ? .center : .leading)

            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(quantidade)")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                Text("ml")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
            }
        }
        .foregroundStyle(Color.aguaAzul)
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 80)
        .background {
            ZStack(alignment: .bottom) {
                LinearGradient(
                    colors: [.white, .aguaFundo],
                    startPoint: .top,
                    endPoint: .bottom
                )

                ZStack {
                    Onda(nivel: 0.45, amplitude: 10, fase: .pi)
                        .fill(Color.aguaCiano)
                    Onda(nivel: 0.55, amplitude: 12, fase: 0)
                        .fill(Color.aguaAzul)
                }
                .frame(height: 90)
            }
        }
    }
}

struct Onda: Shape {
    var nivel: CGFloat
    var amplitude: CGFloat
    var fase: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let meio = rect.height * nivel

        path.move(to: CGPoint(x: 0, y: meio))
        for x in stride(from: 0, through: rect.width, by: 2) {
            let progresso = x / rect.width
            let y = meio + sin(progresso * 2 * .pi + fase) * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        return path
    }
}

extension Color {
    static let aguaAzul   = Color(red: 0.23, green: 0.51, blue: 0.96) // onda da frente
    static let aguaCiano  = Color(red: 0.34, green: 0.75, blue: 0.89) // onda de trás
    static let aguaFundo  = Color(red: 0.90, green: 0.97, blue: 0.99) // fim do degradê
}

#Preview("Confirmação") {
    HidratacaoSnippetView(quantidade: 200, confirmado: false)
}

#Preview("Resultado") {
    HidratacaoSnippetView(quantidade: 200)
}
