//
//  Encodable.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                throw NSError()
            }
            return dictionary
        } catch {
            return nil
        }
    }
}
