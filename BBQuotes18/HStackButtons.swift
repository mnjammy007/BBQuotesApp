//
//  SwiftUIView.swift
//  BBQuotes18
//
//  Created by Apple on 25/10/24.
//

import SwiftUI

struct HStackButtons: View {
    let show: String
    let vm: ViewModel
    
    var body: some View {
        HStack {
            Button {
                Task{
                    await vm.getQuoteData(for: show)
                }
            }
            label: {
                Text(Constants.getRandomQuote)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color("\(show.removeSpaces())\(Constants.button)"))
                    .clipShape(.rect(cornerRadius: 7))
                    .shadow(color: Color("\(show.removeSpaces())\(Constants.button)"), radius: 2)
            }
            Button {
                Task{
                    await vm.getEpisodeData(of: show)
                }
            }
            label: {
                Text(Constants.getRandomEpisode)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color("\(show.removeSpaces())\(Constants.button)"))
                    .clipShape(.rect(cornerRadius: 7))
                    .shadow(color: Color("\(show.removeSpaces())\(Constants.button)"), radius: 2)
            }
            
            Button {
                Task{
                    await vm.getRandomCharacterData(for: show)
                }
            }
            label: {
                Text(Constants.getRandomCharacter)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color("\(show.removeSpaces())\(Constants.button)"))
                    .clipShape(.rect(cornerRadius: 7))
                    .shadow(color: Color("\(show.removeSpaces())\(Constants.button)"), radius: 2)
            }
        }
        .padding()
    }
}

#Preview {
    HStackButtons(show: Constants.bbName, vm: ViewModel())
}
