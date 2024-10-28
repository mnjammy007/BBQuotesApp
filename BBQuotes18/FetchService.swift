//
//  FetchService.swift
//  BBQuotes18
//
//  Created by Apple on 24/10/24.
//

import Foundation

struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    private let baseUrl = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    func fetchQuote(from show: String) async throws -> Quote {
//        Build fetch url
        let quoteUrl = baseUrl.appending(path: "quotes/random")
        let fetchUrl = quoteUrl.appending(queryItems: [URLQueryItem(name: "production", value: show)])
//        Fetch data from url
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
//        Handle responsee
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
//        Decode the data
        let quote = try JSONDecoder().decode(Quote.self, from: data)
//        Return Quote
        return quote
    }
    
    func fetchSimpsonsQuote() async throws -> SimpsonsQuote{
        let fetchUrl = URL(string: "https://thesimpsonsquoteapi.glitch.me/quotes")!
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let simpsonsQuote = try JSONDecoder().decode([SimpsonsQuote].self, from: data)
        return simpsonsQuote[0]
    }
    
    func fetchCharacter(_ name: String) async throws -> Character {
        let characterUrl = baseUrl.appending(path: "characters")
        let fetchUrl = characterUrl.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let characters = try decoder.decode([Character].self, from: data)
        return characters[0]
    }
    
    func fetchDeath(for characterName: String) async throws -> Death? {
        let fetchUrl = baseUrl.appending(path: "deaths")
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let deaths = try decoder.decode([Death].self, from: data)
        
        for death in deaths {
            if death.character == characterName {
                return death
            }
        }
        return nil
    }
    
    func fetchEpisode(of show: String) async throws -> Episode? {
        let episodeUrl = baseUrl.appending(path: "episodes")
        let fetchUrl = episodeUrl.appending(queryItems: [URLQueryItem(name: "production", value: show)])
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let episodes = try decoder.decode([Episode].self, from: data)
        return episodes.randomElement()
    }
    
    func fetchRandomCharacter(for show: String) async throws -> Character? {
        let randomCharacterUrl = baseUrl.appending(path: "characters/random")
        let (data, response) = try await URLSession.shared.data(from: randomCharacterUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let character = try decoder.decode(Character.self, from: data)
        return character
    }
    
    func fetchRandomQuote(by character: String) async throws -> String {
        let randomQuoteUrl = baseUrl.appending(path: "quotes/random")
        let fetchUrl = randomQuoteUrl.appending(queryItems: [URLQueryItem(name: "character", value: character.replaceSpaceByPlus())])
        let (data, response) = try await URLSession.shared.data(from: fetchUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        return quote.quote
    }
}

