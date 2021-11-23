//
//  GistListViewModelTests.swift
//  GistsTests
//
//  Created by Sarfaraz Khan on 23/11/2021.
//

import XCTest
import RxSwift
import RxTest
import RxCocoa
@testable import Gists

class GistListViewModelTests: XCTestCase {
    
    var sut: GistListViewModel?
    var mockDataManager = MockDataManager()
    let disposeBag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    
    override func setUpWithError() throws {
        sut = GistListViewModel(with: mockDataManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testViewStateInitialAndUserSharesDataSuccess() {
        mockDataManager.fetchFailure = false
        mockDataManager.showEmptyList = false
        //Fetch initial data
        sut?.input.viewState.onNext(.initialFetch)
        // Test datasource is not Empty
        XCTAssertFalse(sut?.output.datasource.value.isEmpty ?? true)
        //Check both api are called 
        XCTAssertTrue(mockDataManager.isGetGistsApiCalled)
        XCTAssertTrue(mockDataManager.isGetUsersGistsApiCalled)
        // Check if User shares row is appended at correct position
        // Since we only added one row for each gist and user shares we know the index will first and last
        // In case of multiple data we can enumerate the list
        guard let gist = sut!.output.datasource.value.first as? Gist,
              let userItem = sut!.output.datasource.value.last as? UserShares else {
            XCTFail("Unexpected datasoure")
            return
        }
        XCTAssertEqual(userItem.name, gist.owner.login)
        XCTAssertTrue(userItem.shares >= 5)
        
        let fetch = scheduler.createObserver(Bool.self)
        sut?.output.isFetching
                .drive(fetch)
                .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, (AppState.initialFetch))])
            .bind(to: sut!.input.viewState)
            .disposed(by: disposeBag)

        scheduler.start()
        // API fetch is in following order
        // AppState.initialFetch --> isFetching is true
        // AppState.queryUsers --> On completion --> Query users --> isFetching is true
        // AppState.fetchCompleted --> On completion --> isFetching is false
        XCTAssertEqual(fetch.events, [.next(10, true), .next(10, true), .next(10, false)])
    }
    
    func testViewStateInitialWithEmptyResult() {
        
        mockDataManager.showEmptyList = true
        sut?.input.viewState.onNext(.initialFetch)
        
        let errorMsg = scheduler.createObserver(String.self)
        sut?.output.errorMsg
                .drive(errorMsg)
                .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, (AppState.initialFetch))])
            .bind(to: sut!.input.viewState)
            .disposed(by: disposeBag)

        scheduler.start()
        XCTAssertEqual(errorMsg.events, [.next(10, Constants.notFound)])
    }
    
    func testViewStateInitialWithFailure() {
        
        mockDataManager.fetchFailure = true
        sut?.input.viewState.onNext(.initialFetch)
        
        let errorMsg = scheduler.createObserver(String.self)
        sut?.output.errorMsg
                .drive(errorMsg)
                .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, (AppState.initialFetch))])
            .bind(to: sut!.input.viewState)
            .disposed(by: disposeBag)

        scheduler.start()
        XCTAssertEqual(errorMsg.events, [.next(10, Constants.forbidden)])
    }
}

