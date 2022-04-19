//
//  VBCharacterModel.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

struct VBCharacterModel: Codable {
    var id: Int?
    var name, description : String?
    var thumbnail: VBCharacterThumbnail?
   
}
