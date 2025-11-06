//
//  BadgeDetailView.swift
//  Momentos
//
//  Created by Brian Benjamin Pareja Meruvia on 5/11/25.
//

import SwiftUI

    struct BadgeDetailView: View {
        var badge: Badge

        var body: some View {
            ScrollView {
                VStack(spacing: 8) {
                    Image(badge.details.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140, height: 140)
                    Text(badge.details.title)
                        .font(.title.bold())
                    Text(badge.details.congratulatoryMessage)
                        .font(.body)
                    Spacer()
                    // Si está desbloqueado, muestra la fecha
                    if let timestamp = badge.timestamp {
                        Text(timestamp, style: .date)
                            .font(.caption2.bold())
                    }
                }
                .padding()
                .frame(width: 320)
                .frame(minHeight: 410)
                .fixedSize()
                .multilineTextAlignment(.center)
                .foregroundStyle(.white) // Texto blanco
                .background(badge.details.color.opacity(0.8)) // Fondo de color
                .clipShape(RoundedRectangle(cornerRadius: 16.0))
            }
            .scrollBounceBehavior(.basedOnSize)
            .defaultScrollAnchor(.center, for: .alignment)
        }
    }

    #Preview {
        BadgeDetailView(badge: .sample)
    }
