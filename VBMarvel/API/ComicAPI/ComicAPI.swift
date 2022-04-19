//
//  ComicAPI.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

protocol VBComicServiceProtocol {
    func fetchCharacters(params: VBComicParams,
                         completion: @escaping (Result<VBComicResult, Error>) -> Void)
}

struct VBComicParams: VBAPICallParams {
    private let limit: Int = 20
    private var offset: Int {
        return page * limit
    }

    var title: String?
    var page: Int = 0
    var filter : Bool
    var dateDescriptor : String
    
    func queryParameters() -> [String : Any]? {
        var params = [String: Any]()
        params.updateValue(limit, forKey: "limit")
        params.updateValue(offset, forKey: "offset")
        params.updateValue(false, forKey: "hasDigitalIssue")
        if filter == false {
            if let name = title?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
                params.updateValue(name, forKey: "titleStartsWith")
            }
        } else {
            if dateDescriptor != nil || dateDescriptor != ""{
                params.updateValue(dateDescriptor, forKey: "dateDescriptor")
            }
        }
        return params
    }
}

class ComicAPI: VBAPICall<VBComicParams, VBComicResult>,
                VBComicServiceProtocol {
    let endpoint = "/v1/public/comics"
    
    func fetchCharacters(params: VBComicParams,
                         completion: @escaping (Result<VBComicResult, Error>) -> Void) {
        
        let params = params.queryParameters()

        let request = VBApiConfig<VBComicResult>(endpoint: endpoint, queryParams: params)
        request.fetchData(completion: completion)
    }
    
    
}
