//
//  Episode.swift
//  BBQuotes18
//
//  Created by Apple on 25/10/24.
//

import Foundation

struct Episode: Decodable{
    let episode: Int
    let title: String
    let image: URL
    let synopsis: String
    let writtenBy: String
    let directedBy: String
    let airDate: String
    
    var seasonEpisode: String {
        var episodeString = String(episode)
        let seasonNumber = episodeString.removeFirst()
        if episodeString.first != "0" {
            episodeString = String(episodeString.removeLast())
        }
        return "Season \(seasonNumber) Episode \(episodeString)"
    }
}
