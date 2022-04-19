//
//  Date.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

extension Date {
    func currentTimestamp() -> Int64 {
        return Int64(timeIntervalSince1970)
    }
}
