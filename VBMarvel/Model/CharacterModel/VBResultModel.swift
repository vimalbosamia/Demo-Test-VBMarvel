//
//  VBCharacterModel.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

struct VBResultModel: VBAPICallModel, Codable {
    var characters: [VBCharacterModel]?
    var offset, limit, total, count: Int?

    enum CodingKeys: String, CodingKey {
        case characters = "results"
        case offset, limit, total, count
    }
}
