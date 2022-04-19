//
//  VBCharacterModel.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

struct VBComicModel: Codable {
    var id: Int?
    var title, description, modified : String?
    var thumbnail: VBCharacterThumbnail?
}
