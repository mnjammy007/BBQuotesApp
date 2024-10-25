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
        case successQuote
        case successEpisode
        case successRandomCharacter
        case failureRandomCharacter
        case failed(error: Error)
    }
    enum QuoteFetchStatus {
        case notTried
        case success
        case failed(error: Error)
    }
    private(set) var status: DataFetchStatus = .notStarted
    private(set) var randomQuoteStatus: QuoteFetchStatus = .notTried
    
    let dataFetcher = FetchService()
    var quote: Quote
    var character: Character
    var episode: Episode
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Character.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    func getQuoteData(for show: String) async {
        status = .fetching
        do {
            quote = try await dataFetcher.fetchQuote(from: show)
            character = try await dataFetcher.fetchCharacter(quote.character)
            character.death = try await dataFetcher.fetchDeath(for: character.name)
            character.randomQuote = try await dataFetcher.fetchRandomQuote(by: character.name)
            status = .successQuote
        }
        catch {
            status = .failed(error: error)
        }
    }
    
    func getEpisodeData(of show: String) async {
        status = .fetching
        do {
            if let unwrappedEpisode = try await dataFetcher.fetchEpisode(of: show){
                episode = unwrappedEpisode
                status = .successEpisode
            }
        }
        catch {
            status = .failed(error: error)
        }
    }
    
    func getRandomCharacterData(for show: String) async {
        status = .fetching
        do {
            if let character = try await dataFetcher.fetchRandomCharacter(for: show){
                if character.productions.contains(show){
                    self.character = character
                    status = .successRandomCharacter
                }
                else{
                    status = .failureRandomCharacter
                }
            }
        }
        catch {
            status = .failed(error: error)
        }
    }
    
    func getRandomQuote(by characterValue: Character) async {
        randomQuoteStatus = .notTried
        do {
            character.randomQuote = try await dataFetcher.fetchRandomQuote(by: character.name)
            randomQuoteStatus = .success
        }
        catch {
            randomQuoteStatus = .failed(error: error)
        }

    }
}
