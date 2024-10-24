//
//  ViewModel.swift
//  BBQuotes18
//
//  Created by Apple on 24/10/24.
//

import Foundation

@Observable
class ViewModel {
    enum DataFetchStatus {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    private(set) var status: DataFetchStatus = .notStarted
    
    let dataFetcher = FetchService()
    var quote: Quote
    var character: Character
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Character.self, from: characterData)
    }
    
    func getData(for show: String) async {
        status = .fetching
        do {
            quote = try await dataFetcher.fetchQuote(from: show)
            character = try await dataFetcher.fetchCharacter(quote.character)
            character.death = try await dataFetcher.fetchDeath(for: character.name)
            status = .success
        }
        catch {
            status = .failed(error: error)
        }
    }
}
