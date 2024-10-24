//
//  QuoteView.swift
//  BBQuotes18
//
//  Created by Apple on 24/10/24.
//

import SwiftUI

struct QuoteView: View {
    let vm = ViewModel()
    let show: String
    @State var showCharacterSheet = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
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
                        case .success:
                            Text("\"\(vm.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: vm.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.55)
                                Text(vm.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.55)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterSheet.toggle()
                            }
                        case .failed(let error):
                            Text(error.localizedDescription)
                        }
                        
                        Spacer()
                    }
                    Button {
                        Task{
                            await vm.getData(for: show)
                        }
                    }
                    label: {
                        Text("Get Random Quote")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                            .background(show=="Breaking Bad" ? .breakingBadButton : .betterCallSaulButton)
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(color: show=="Breaking Bad" ? .breakingBadShadow :  .betterCallSaulShadow, radius: 2)
                    }
                    Spacer(minLength: geo.size.height * 0.105)
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterSheet) {
            CharacterView(character: vm.character, show: show)
        }
    }
}

#Preview {
    QuoteView(show: "Breaking Bad", showCharacterSheet: false)
        .preferredColorScheme(.dark)
}
