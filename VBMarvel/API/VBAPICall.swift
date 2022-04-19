//
//  VBAPICall.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

protocol VBAPICallParams {
    func queryParameters() -> [String: Any]?
}

protocol VBAPICallModel: Codable { }

class VBAPICall<P: VBAPICallParams, T: VBAPICallModel> {

}
