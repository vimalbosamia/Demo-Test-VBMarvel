//
//  VBCharactersModel.swift
//  VBMarvelTests
//
//  Created by Vimal on 21/04/22.
//

import XCTest
@testable import VBMarvel

extension VBComicListTest {
    class VBComicService: VBComicServiceProtocol {
        
        private var maxItems = 15
        private var itemsByPage = 10

        var fail = false
        var noResults = false

        private func getModel(page: Int) -> VBComicResult {
            guard !noResults else { return getNoResultsModel() }
            let items = (page + 1) * itemsByPage <= maxItems ? itemsByPage : (maxItems - itemsByPage)
            let offset = page * itemsByPage
            var characters = [VBComicModel]()
            for i in 1...items {
                characters.append(VBComicModel(id: offset + i - 1, title: "Comic \(offset + i - 1)"))
            }

            return VBComicResult(characters: characters,
                                     offset: offset,
                                     limit: itemsByPage,
                                     total: maxItems,
                                     count: items)
        }

        private func getNoResultsModel() -> VBComicResult {
            return VBComicResult(characters: [],
                                     offset: 0,
                                     limit: itemsByPage,
                                     total: 0,
                                     count: 0)
        }

        func fetchCharacters(params: VBComicParams, completion: @escaping (Result<VBComicResult, Error>) -> Void) {
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
extension VBComicListTest {
    class VBComicList: VBCComicListViewProtocol {
        var errorShowed = false
        var characterDetail: VBDetailModel?
        var listReloaded = false

        func reloadComic() {
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
