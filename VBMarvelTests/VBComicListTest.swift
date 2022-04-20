//
//  VBMarvelTests.swift
//  VBMarvelTests
//
//  Created by Vimal on 19/04/22.
//

import XCTest
@testable import VBMarvel

class VBComicListTest: XCTestCase {

    var sut: VBComicViewModel?
    var comicService = VBComicService()
    var view = VBComicList()
    override func setUpWithError() throws {
        sut = VBComicViewModel(comicService: comicService)
        sut?.attachView(view: view)
    }

    override func tearDownWithError() throws {
        sut = nil
        comicService.clean()
        view.clean()
    }

    func testTitle() {
        XCTAssertEqual(sut?.navTitle, "Marvel")
    }

    func testLoadCharacters() {
        sut?.loadNextPage(name: "" ,isFilter : false,dateDescriptor : " ")
        XCTAssertTrue(sut?.canLoadMore() ?? false)
        XCTAssertTrue(view.listReloaded)
        XCTAssertEqual(sut?.charactersCount, 10)

        sut?.loadNextPage(name: "" ,isFilter : false,dateDescriptor : " ")
        XCTAssertFalse(sut?.canLoadMore() ?? true)
        XCTAssertEqual(sut?.charactersCount, 15)
    }

    func testLoadOtherNameCharacters() {
        sut?.loadNextPage(name: "" ,isFilter : false,dateDescriptor : " ")
        XCTAssertTrue(sut?.canLoadMore() ?? false)
        XCTAssertTrue(view.listReloaded)
        XCTAssertEqual(sut?.charactersCount, 10)

        sut?.loadNextPage(name: "Spider",isFilter : false,dateDescriptor : "")
        XCTAssertEqual(sut?.charactersCount, 10)
    }

    func testLoadCharactersFail() {
        comicService.fail = true
        sut?.loadNextPage(name: "" ,isFilter : false,dateDescriptor : " ")
        XCTAssertEqual(sut?.state, .error)
        XCTAssertFalse(sut?.canLoadMore() ?? true)
        XCTAssertTrue(view.errorShowed)

        comicService.fail = false
        sut?.retry()
        XCTAssertEqual(sut?.state, .success)
        XCTAssertTrue(view.listReloaded)
        XCTAssertFalse(view.errorShowed)
    }

    func testLoadNoResults() {
        comicService.noResults = true
        sut?.loadNextPage(name: "NoResults",isFilter : false,dateDescriptor : "")
        XCTAssertEqual(sut?.state, .noResults)
        XCTAssertFalse(sut?.canLoadMore() ?? true)
    }

    func testCharacterAt() {
        sut?.loadNextPage(name: "" ,isFilter : false,dateDescriptor : " ")
        let character = sut?.character(at: 3)
        XCTAssertEqual(character?.name, "Comic 3")
    }

    func testSelectCharacter() {
        sut?.loadNextPage(name: "",isFilter : false,dateDescriptor : "")
        sut?.didSelect(character: 3)
        XCTAssertEqual(view.characterDetail?.name, "Comic 3")
    }
}
