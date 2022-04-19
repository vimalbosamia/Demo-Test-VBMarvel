//
//  Collection.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
