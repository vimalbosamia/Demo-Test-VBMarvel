//
//  VBMarvelTests.swift
//  VBMarvelTests
//
//  Created by Vimal on 19/04/22.
//

import XCTest
@testable import VBMarvel

class VBCharacterListTest: XCTestCase {

    var sut: VBCharacterListViewModel?
    var charactersService = VBCharactersService()
    var view = VBCharactersList()
    override func setUpWithError() throws {
        sut = VBCharacterListViewModel(charactersService: charactersService)
        sut?.attachView(view: view)
    }

    override func tearDownWithError() throws {
        sut = nil
        charactersService.clean()
        view.clean()
    }

    func testTitle() {
        XCTAssertEqual(sut?.navTitle, "Marvel")
    }

    func testLoadCharacters() {
        sut?.loadNextPage(name: "")
        XCTAssertTrue(sut?.canLoadMore() ?? false)
        XCTAssertTrue(view.listReloaded)
        XCTAssertEqual(sut?.charactersCount, 10)

        sut?.loadNextPage(name: "")
        XCTAssertFalse(sut?.canLoadMore() ?? true)
        XCTAssertEqual(sut?.charactersCount, 15)
    }

    func testLoadOtherNameCharacters() {
        sut?.loadNextPage(name: "")
        XCTAssertTrue(sut?.canLoadMore() ?? false)
        XCTAssertTrue(view.listReloaded)
        XCTAssertEqual(sut?.charactersCount, 10)

        sut?.loadNextPage(name: "Spider")
        XCTAssertEqual(sut?.charactersCount, 10)
    }

    func testLoadCharactersFail() {
        charactersService.fail = true
        sut?.loadNextPage(name: "")
        XCTAssertEqual(sut?.state, .error)
        XCTAssertFalse(sut?.canLoadMore() ?? true)
        XCTAssertTrue(view.errorShowed)

        charactersService.fail = false
        sut?.retry()
        XCTAssertEqual(sut?.state, .success)
        XCTAssertTrue(view.listReloaded)
        XCTAssertFalse(view.errorShowed)
    }

    func testLoadNoResults() {
        charactersService.noResults = true
        sut?.loadNextPage(name: "NoResults")
        XCTAssertEqual(sut?.state, .noResults)
        XCTAssertFalse(sut?.canLoadMore() ?? true)
    }

    func testCharacterAt() {
        sut?.loadNextPage(name: "")
        let character = sut?.character(at: 3)
        XCTAssertEqual(character?.name, "Character 3")
    }

    func testSelectCharacter() {
        sut?.loadNextPage(name: "")
        sut?.didSelect(character: 3)
        XCTAssertEqual(view.characterDetail?.name, "Character 3")
    }
}
