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
}

