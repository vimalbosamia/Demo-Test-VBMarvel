//
//  VBCharacterThumbnail.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

struct VBCharacterThumbnail: Codable {
    var path, imageExtension: String?
    var urlString: String? {
        guard let path = path, let ext = imageExtension else { return nil }
        return "\(path).\(ext)"
    }

    enum CodingKeys: String, CodingKey {
        case imageExtension = "extension"
        case path
    }
}
