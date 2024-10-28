//
//  SimpsonsQuote.swift
//  BBQuotes18
//
//  Created by Apple on 28/10/24.
//
import Foundation

struct SimpsonsQuote: Decodable {
    let quote: String
    let character: String
    let image: URL
}
