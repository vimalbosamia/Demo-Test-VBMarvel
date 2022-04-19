//
//  VBComicViewModel.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

protocol VBComicViewModelDelegate {
    var navTitle: String { get }
    func attachView(view: VBCComicListViewProtocol)

    var state: VBComicViewModel.State { get }
    func loadNextPage(name: String, isFilter : Bool,dateDescriptor : String)
    func canLoadMore() -> Bool
    func retry()

    var  charactersCount: Int { get }
    func character(at position: Int) -> CollectionViewCellModel?
    func didSelect(character at: Int)
}

class VBComicViewModel {
    enum State {
        case success
        case loading
        case error
        case noResults
    }

    init(comicService: VBComicServiceProtocol? = nil) {
        self.comicService = comicService ?? ComicAPI()
    }

    private weak var view: VBCComicListViewProtocol?

    private let comicService: VBComicServiceProtocol?

    private var comicModel: VBComicResult?
    private var comic: [VBComicModel] = []
    private var currentPage: Int  = -1
    private var currentName = ""

    private var isLoading = false
    private var isError = false
    private var isFilter = false
    private var dateDescriptorFormate = ""
    
    var state: State {
        var currentState: State = .success

        if isLoading {
            currentState = .loading
        } else if isError {
            currentState = .error
        } else if charactersCount == 0 {
            currentState = .noResults
        }

        return currentState
    }

    var navTitle: String = "Marvel"
    var charactersCount: Int {
        return comic.count
    }

    private func resetSearch() {
        comicModel = nil
        comic = []
        currentPage = -1
        isLoading = false
        isError = false
        view?.reloadComic()
    }

    private func setCharacters(model: VBComicResult) {
        comicModel = model

        if currentPage < 0 {
            comic = model.characters ?? []
        } else {
            comic += model.characters ?? []
        }

        currentPage += 1
        view?.reloadComic()
    }

    private func fetchCharacters(params: VBComicParams,completion: @escaping (Result<VBComicResult, Error>) -> Void) {
        isLoading = true
        isError = false
        comicService?.fetchCharacters(params: params) { [weak self] result in
            self?.isLoading = false
            completion(result)
        }
    }
}

extension VBComicViewModel: VBComicViewModelDelegate {
    func attachView(view: VBCComicListViewProtocol) {
        self.view = view
    }

    func canLoadMore() -> Bool {
        return comic.count < comicModel?.total ?? Int.max && !isLoading && !isError
    }

    func loadNextPage(name: String ,isFilter : Bool,dateDescriptor : String) {
        if name != currentName {
            resetSearch()
            currentName = name
        }
        
        if  dateDescriptor != self.dateDescriptorFormate {
            resetSearch()
            dateDescriptorFormate = dateDescriptor
        }

        self.isFilter = isFilter
        self.dateDescriptorFormate = dateDescriptor
        guard canLoadMore() else { return }
        let params = VBComicParams(title: name, page: currentPage + 1 , filter:  self.isFilter , dateDescriptor: dateDescriptorFormate)
        fetchCharacters(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.setCharacters(model: model)

            case .failure:
                self.isError = true
                self.view?.showError()
            }
        }
    }

    func retry() {
        isError = false
        isLoading = false
        loadNextPage(name: currentName,isFilter: isFilter , dateDescriptor:  dateDescriptorFormate)
    }

    func character(at position: Int) -> CollectionViewCellModel? {
        guard let character = comic[safe: position] else { return nil }
        let cellModel = CollectionViewCellModel(
            name: character.title ?? "",
            description: character.description  ?? "",
            imageUrl: character.thumbnail?.urlString ?? "",
            modified: character.modified ?? ""
        )
        return cellModel
    }

    func didSelect(character at: Int) {
        guard let character = comic[safe: at] else { return }
        let model = VBDetailModel(
            image: character.thumbnail?.urlString ?? "",
            name: character.title ?? "",
            description: character.description ?? "",
            modified: character.modified ?? ""
        )
        view?.showDetail(model: model)
    }
}
