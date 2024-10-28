//
//  CharacterView.swift
//  BBQuotes18
//
//  Created by Apple on 24/10/24.
//

import SwiftUI

struct CharacterView: View {
    let vm = ViewModel()
    let character: Character
    let show: String
    let isViewingOnFetchView: Bool
    @State private var rotationAngle = 0.0
    
    var body: some View {
        GeometryReader{ geo in
            ScrollViewReader{proxy in
                ZStack(alignment: .top) {
                    Image(isViewingOnFetchView ? "" : show.removeSpaceAndLowerCase())
                        .resizable()
                        .scaledToFit()
                    ScrollView {
                        HStack{
                            switch vm.randomQuoteStatus {
                            case .notTried, .success:
                                Text("\(vm.character.randomQuote)")
                            case .failed(let error):
                                Text(error.localizedDescription)
                            }
                            Button("↻"){
                                Task{
                                    withAnimation(.easeInOut(duration: 0.5)) {rotationAngle += 360}
                                    await vm.getRandomQuote(by: character)
                                }
                            }
                            .rotationEffect(.degrees(rotationAngle))
                            .font(.title2)
                        }
                        .foregroundStyle(.white)
                        .padding([.horizontal,.vertical])
                        .background(.black.opacity(0.6))
                        .clipShape(.rect(cornerRadius: 25))
                        .frame(width: geo.size.width * 0.8, alignment: .center)
                        .padding(.top, geo.size.height * 0.07)
                        
                        TabView {
                            ForEach(character.images, id: \.self) {characterImageUrl in
                                AsyncImage(url: characterImageUrl) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .tabViewStyle(.page)
                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.6)
                        .clipShape(.rect(cornerRadius: 25))
                        
                        
                        VStack(alignment: .leading) {
                            Text(character.name)
                                .font(.largeTitle)
                            Text("\(Constants.portrayedBy) \(character.portrayedBy)")
                                .font(.subheadline)
                            Divider()
                            Text("\(character.name) \(Constants.characterInfo)")
                                .font(.title2)
                            Text("\(Constants.born) \(character.birthday)")
                            Divider()
                            ForEach(character.occupations, id: \.self) {occupation in
                                Text("∙\(occupation)")
                                    .font(.subheadline)
                            }
                            Divider()
                            Text("\(Constants.nicknames)")
                            if character.aliases.count > 0 {
                                ForEach(character.aliases, id: \.self) {alias in
                                    Text("∙\(alias)")
                                        .font(.subheadline)
                                }
                            }
                            else{
                                Text("\(Constants.none)")
                                    .font(.subheadline)
                            }
                            Divider()
                            DisclosureGroup("\(Constants.status)") {
                                VStack(alignment: .leading) {
                                    Text(character.status)
                                        .font(.title2)
                                    if let death = character.death {
                                        AsyncImage(url: death.image) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 15))
                                                .onAppear{
                                                    withAnimation {
                                                        proxy.scrollTo(1, anchor: .bottom)
                                                    }
                                                }
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        Text("\(Constants.how) \(death.details)")
                                            .padding(.bottom, 7)
                                        Text("\(Constants.lastWords) \(death.lastWords)")
                                    }
                                }
                                .frame(maxWidth: geo.size.width, alignment: .leading)
                            }
                            .tint(.primary)
                        }
                        .foregroundStyle(.white)
                        .padding(.all, 10)
                        .background(isViewingOnFetchView ? .black.opacity(0.6) : .clear)
                        .clipShape(.rect(cornerRadius: isViewingOnFetchView ? 25 : 0))
                        .frame(width: geo.size.width * 0.8, alignment: .leading)
                        .padding(.bottom, 50)
                        .id(1)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: Constants.bbName, isViewingOnFetchView: true)
}
