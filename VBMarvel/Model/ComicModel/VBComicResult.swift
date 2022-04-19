//
//  VBComicResult.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

struct VBComicResult : VBAPICallModel, Codable {
    
    var characters: [VBComicModel]?
    var offset, limit, total, count: Int?
    
    enum CodingKeys: String, CodingKey {
        case characters = "results"
        case offset, limit, total, count
    }
}
