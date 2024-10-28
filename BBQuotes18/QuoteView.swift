//
//  QuoteView.swift
//  BBQuotes18
//
//  Created by Apple on 25/10/24.
//

import SwiftUI

struct QuoteView: View {
    let vm: ViewModel
    let scHeight: Double
    let scWidth: Double
    
    var body: some View {
        VStack {
            Text("\"\(vm.isQuoteSimpsons ? vm.simpsonsQuote.quote : vm.quote.quote)\"")
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(.rect(cornerRadius: 25))
                .padding(.horizontal)
            ZStack(alignment: .bottom) {
                AsyncImage(url: vm.isQuoteSimpsons ? vm.simpsonsQuote.image : vm.character.images.randomElement()) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: scWidth * 0.9, height: scHeight * 0.55)
                Text(vm.isQuoteSimpsons ? vm.simpsonsQuote.character : vm.quote.character)
                    .foregroundStyle(.white)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
            }
            .frame(width: scWidth * 0.9, height: scHeight * 0.55)
            .clipShape(.rect(cornerRadius: 50))
        }
    }
}

#Preview {
    QuoteView(vm:ViewModel(), scHeight: 874.0, scWidth: 402.0)
}
