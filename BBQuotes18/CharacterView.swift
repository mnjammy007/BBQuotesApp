//
//  CharacterView.swift
//  BBQuotes18
//
//  Created by Apple on 24/10/24.
//

import SwiftUI

struct CharacterView: View {
    let character: Character
    let show: String
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .top) {
                Image(show.lowercased().replacingOccurrences(of: " ", with: ""))
                    .resizable()
                    .scaledToFit()
                ScrollView{
                    AsyncImage(url: character.images[0]) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.6)
                    .clipShape(.rect(cornerRadius: 25))
                    .padding(.top, geo.size.height * 0.07)
                    VStack(alignment: .leading) {
                        Text(character.name)
                            .font(.largeTitle)
                        Text("Portrayed By: \(character.portrayedBy)")
                            .font(.subheadline)
                        Divider()
                        Text("\(character.name) Character Info")
                            .font(.title2)
                        Text("Born: \(character.birthday)")
                        Divider()
                        ForEach(character.occupations, id: \.self) {occupation in
                            Text("∙\(occupation)")
                                .font(.subheadline)
                        }
                        Divider()
                        Text("Nicknames:")
                        if character.aliases.count > 0 {
                            ForEach(character.aliases, id: \.self) {alias in
                                Text("∙\(alias)")
                                    .font(.subheadline)
                            }
                        }
                        else{
                            Text("None")
                                .font(.subheadline)
                        }
                        Divider()
                        DisclosureGroup("Status (Spoiler Alert!)") {
                            VStack(alignment: .leading) {
                                Text(character.status)
                                    .font(.title2)
                                if let death = character.death {
                                    AsyncImage(url: death.image) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(.rect(cornerRadius: 15))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text("How: \(death.details)")
                                        .padding(.bottom, 7)
                                    Text("Last Words: \(death.lastWords)")
                                }
                            }
                            .frame(maxWidth: geo.size.width, alignment: .leading)
                        }
                        .tint(.primary)
                    }
                    .frame(width: geo.size.width * 0.8, alignment: .leading)
                    .padding(.bottom, 50)
                }
                .scrollIndicators(.hidden)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: "Breaking Bad")
}
