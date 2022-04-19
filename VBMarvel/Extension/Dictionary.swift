//
//  Dictionary.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

extension Dictionary {
    func httpParams() -> [URLQueryItem] {
        return map({ URLQueryItem(name: "\($0.key)", value: "\($0.value)") })
    }
}
