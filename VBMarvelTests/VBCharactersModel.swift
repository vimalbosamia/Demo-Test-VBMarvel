//
//  VBCharactersModel.swift
//  VBMarvelTests
//
//  Created by Vimal on 21/04/22.
//

import XCTest
@testable import VBMarvel

extension VBCharacterListTest {
    class VBCharactersService: VBCharactersServiceProtocol {
        private var maxItems = 15
        private var itemsByPage = 10

        var fail = false
        var noResults = false

        private func getModel(page: Int) -> VBResultModel {
            guard !noResults else { return getNoResultsModel() }
            let items = (page + 1) * itemsByPage <= maxItems ? itemsByPage : (maxItems - itemsByPage)
            let offset = page * itemsByPage
            var characters = [VBCharacterModel]()
            for i in 1...items {
                characters.append(VBCharacterModel(id: offset + i - 1, name: "Character \(offset + i - 1)"))
            }

            return VBResultModel(characters: characters,
                                     offset: offset,
                                     limit: itemsByPage,
                                     total: maxItems,
                                     count: items)
        }

        private func getNoResultsModel() -> VBResultModel {
            return VBResultModel(characters: [],
                                     offset: 0,
                                     limit: itemsByPage,
                                     total: 0,
                                     count: 0)
        }

        func fetchCharacters(params: VBCharactersParams, completion: @escaping (Result<VBResultModel, Error>) -> Void) {
            guard !fail else {
                completion(.failure(NSError()))
                return
            }

            let model = getModel(page: params.page)
            completion(.success(model))
        }

        func clean() {
            fail = false
            noResults = false
        }
    }
}
extension VBCharacterListTest {
    class VBCharactersList: VBCharacterListViewProtocol {
        var errorShowed = false
        var characterDetail: VBDetailModel?
        var listReloaded = false

        func reloadCharacters() {
            listReloaded = true
            errorShowed = false
        }

        func showError() {
            errorShowed = true
        }

        func showDetail(model: VBDetailModel) {
            characterDetail = model
        }

        func clean() {
            errorShowed = false
            characterDetail = nil
            listReloaded = false
        }
    }
}
