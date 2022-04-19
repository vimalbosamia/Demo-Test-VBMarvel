//
//  VBApiConfig.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

struct MarvelAPIData<T: Codable>: Codable {
    var code: Int?
    var data: T?
}

enum APIError: Error {
    case other(description: String)
}

class VBApiConfig<T: Codable> {
    private let apiKey = "5b72574ee1e223f0c0573a45da4c4879"
    private let privateKey = "53f3c88df7fa48f1f054992636c40edb833cd6bc" //
    private let baseUrl = "https://gateway.marvel.com"

    var queryParameters: [String: Any]?
    var path: String

    init(endpoint: String,
         queryParams: [String: Any]?) {
        path = endpoint
        queryParameters = queryParams
    }

    private func getParameters() -> [URLQueryItem] {
        let timestamp = Date().currentTimestamp()
        let hashKey = "\(timestamp)\(privateKey)\(apiKey)"
        var params: [String: Any] = [
            "ts": "\(timestamp)",
            "apikey": apiKey,
            "hash": hashKey.md5()
        ]
        params.merge(queryParameters ?? [:]) { (_, newValues) in newValues }
        return params.httpParams()
    }

    func fetchData<T: Codable>(completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents(string: "\(baseUrl)\(path)")
        components?.queryItems = getParameters()

        guard let url = components?.url else {
            completion(.failure(APIError.other(description: "URL not built")))
            return
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 5

        URLSession.shared.dataTask(with: request) { data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let model = try JSONDecoder().decode(MarvelAPIData<T>.self, from: data)
                    if let modelData = model.data, model.code == 200 {
                        completion(.success(modelData))
                    } else {
                        completion(.failure(APIError.other(description: "Model error")))
                    }
                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            }
        }.resume()
    }
}
