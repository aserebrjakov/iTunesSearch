//
//  iTunesList.swift
//  iTunesSearchSwift
//
//  Created by Alexandr on 22/07/2019.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation

class iTunesList: Codable {
    
    var resultCount:Int
    var results: [iTunesItem]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
    
    init() {
        resultCount = 0
        results = []
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resultCount = try container.decode(Int.self, forKey: .resultCount)
        self.results = try container.decode([iTunesItem].self, forKey: .results)
    }
}
