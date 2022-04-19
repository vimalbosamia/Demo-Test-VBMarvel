//
//  String+Crypto.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation
import CryptoKit

extension String {
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: data(using: .utf8) ?? Data())
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
