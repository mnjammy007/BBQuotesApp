//
//  QuoteView.swift
//  BBQuotes18
//
//  Created by Apple on 24/10/24.
//

import SwiftUI

struct FetchView: View {
    let vm = ViewModel()
    let show: String
    @State var showCharacterSheet = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image(show.removeSpaceAndLowerCase())
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height  * 1.2)
                VStack {
                    VStack {
                        Spacer(minLength: geo.size.height * 0.07)
                        switch vm.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuote:
                            QuoteView(vm: vm, scHeight: geo.size.height, scWidth: geo.size.width)
                                .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.65)
                                .onTapGesture {
                                    if !vm.isQuoteSimpsons{ showCharacterSheet.toggle() }
                                }
                        case .successEpisode:
                            EpisodeView(episode: vm.episode)
                        case .successRandomCharacter:
                            CharacterView(character: vm.character, show: show, isViewingOnFetchView: true)
                        case .failureRandomCharacter:
                            Text("\(Constants.characterSelected) \(vm.character.name), \(Constants.isNotPart) \(show). \(Constants.pleaseRetry)")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.6))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    HStackButtons(show: show, vm: vm)
                    Spacer(minLength: geo.size.height * 0.105)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .task {
            await vm.getQuoteData(for: show)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterSheet) {
            CharacterView(character: vm.character, show: show, isViewingOnFetchView: false)
        }
    }
}

#Preview {
    FetchView(show: Constants.bbName, showCharacterSheet: false)
        .preferredColorScheme(.dark)
}
