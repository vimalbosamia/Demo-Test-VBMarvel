//
//  CharacterAPI.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

protocol VBCharactersServiceProtocol {
    func fetchCharacters(params: VBCharactersParams,
                         completion: @escaping (Result<VBResultModel, Error>) -> Void)
}

struct VBCharactersParams: VBAPICallParams {
    private let limit: Int = 20
    private var offset: Int {
        return page * limit
    }

    var name: String?
    var page: Int = 0

    func queryParameters() -> [String : Any]? {
        var params = [String: Any]()
        params.updateValue(limit, forKey: "limit")
        params.updateValue(offset, forKey: "offset")

        if let name = name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            params.updateValue(name, forKey: "nameStartsWith")
        }
        return params
    }
}

class CharacterAPI: VBAPICall<VBCharactersParams, VBResultModel>,
                    VBCharactersServiceProtocol {
    func fetchCharacters(params: VBCharactersParams,
                         completion: @escaping (Result<VBResultModel, Error>) -> Void) {
        let endpoint = "/v1/public/characters"
        let params = params.queryParameters()

        let request = VBApiConfig<VBResultModel>(endpoint: endpoint, queryParams: params)
        request.fetchData(completion: completion)
    }
}
