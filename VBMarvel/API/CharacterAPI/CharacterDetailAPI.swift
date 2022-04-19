//
//  CharacterDetailAPI.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

protocol VBCharacterDetailServiceProtocol {
    func fetchCharacter(params: VBCharacterDetailParam,
                        completion: @escaping (Result<VBResultModel, Error>) -> Void)
}

struct VBCharacterDetailParam: VBAPICallParams {
    var id: String = ""

    func queryParameters() -> [String : Any]? {
        return nil
    }
}

class VBCharacterDetailService: VBAPICall<VBCharacterDetailParam, VBResultModel>,
                                VBCharacterDetailServiceProtocol {

    func fetchCharacter(params: VBCharacterDetailParam,
                        completion: @escaping (Result<VBResultModel, Error>) -> Void) {
        let endpoint = "/v1/public/characters/\(params.id)"

        let request = VBApiConfig<VBResultModel>(endpoint: endpoint, queryParams: nil)
        request.fetchData(completion: completion)
    }
}
