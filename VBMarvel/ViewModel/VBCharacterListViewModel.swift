//
//  VBCharacterViewModel.swift
//  VBMarvel
//
//  Created by Vimal on 19/04/22.
//

import Foundation

protocol VBCharacterListViewModelDelegate {
    var navTitle: String { get }
    func attachView(view: VBCharacterListViewProtocol)

    var state: VBCharacterListViewModel.State { get }
    func loadNextPage(name: String)
    func canLoadMore() -> Bool
    func retry()

    var charactersCount: Int { get }
    func character(at position: Int) -> CollectionViewCellModel?
    func didSelect(character at: Int)
}

class VBCharacterListViewModel {
    enum State {
        case success
        case loading
        case error
        case noResults
    }

    init(charactersService: VBCharactersServiceProtocol? = nil) {
        self.charactersService = charactersService ?? CharacterAPI()
    }

    private weak var view: VBCharacterListViewProtocol?

    private let charactersService: VBCharactersServiceProtocol?

    private var charactersModel: VBResultModel?
    private var characters: [VBCharacterModel] = []
    private var currentPage: Int  = -1
    private var currentName = ""

    private var isLoading = false
    private var isError = false

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
        return characters.count
    }

    private func resetSearch() {
        charactersModel = nil
        characters = []
        currentPage = -1
        isLoading = false
        isError = false
        view?.reloadCharacters()
    }

    private func setCharacters(model: VBResultModel) {
        charactersModel = model

        if currentPage < 0 {
            characters = model.characters ?? []
        } else {
            characters += model.characters ?? []
        }

        currentPage += 1
        view?.reloadCharacters()
    }

    private func fetchCharacters(params: VBCharactersParams, completion: @escaping (Result<VBResultModel, Error>) -> Void) {
        isLoading = true
        isError = false
        charactersService?.fetchCharacters(params: params) { [weak self] result in
            self?.isLoading = false
            completion(result)
        }
    }
}

extension VBCharacterListViewModel: VBCharacterListViewModelDelegate {
    func attachView(view: VBCharacterListViewProtocol) {
        self.view = view
    }

    func canLoadMore() -> Bool {
        return characters.count < charactersModel?.total ?? Int.max && !isLoading && !isError
    }

    func loadNextPage(name: String) {
        if name != currentName {
            resetSearch()
            currentName = name
        }

        guard canLoadMore() else { return }
        let params = VBCharactersParams(name: name, page: currentPage + 1)
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
        loadNextPage(name: currentName)
    }

    func character(at position: Int) -> CollectionViewCellModel? {
        guard let character = characters[safe: position] else { return nil }
        let cellModel = CollectionViewCellModel(
            name: character.name ?? "",
            description: character.description ?? "",
            imageUrl: character.thumbnail?.urlString ?? ""
        )
        return cellModel
    }

    func didSelect(character at: Int) {
        guard let character = characters[safe: at] else { return }
        let model = VBDetailModel(
            image: character.thumbnail?.urlString ?? "",
            name: character.name ?? "",
            description: character.description ?? ""
        )
        view?.showDetail(model: model)
    }
}
