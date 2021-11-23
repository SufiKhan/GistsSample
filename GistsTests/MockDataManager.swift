//
//  MockApiClient.swift
//  GistsTests
//
//  Created by Sarfaraz Khan on 23/11/2021.
//

import Foundation
@testable import Gists
import RxSwift
import RxCocoa

final class MockDataManager: ViewModelDataManager {
    
    var showEmptyList = false
    var fetchFailure = false
    var getUserSharesResult: Result<[UserGistShares]>?
    
    func getGistsFromServer(completionHandler: @escaping (Result<[Gist]>) -> Void) {
        if !fetchFailure {
            if !showEmptyList {
                completionHandler(.success(getMockedJsonForGists()))
            } else {
                completionHandler(.success([]))
            }
        } else {
            completionHandler(.failure(Constants.forbidden))
        }
        
    }
    
    func queryUserForDetail(gists: [Gist], completionHandler: @escaping (Result<Set<UserShares>>) -> Void) {
            var userDetailList = Set<UserShares>()
            gists.forEach({ gist in
                let userShares = getMockedJsonForUserShares()
                if (userShares.count >= 5) {
                    userDetailList.insert(UserShares(name: gist.owner.login, shares: userShares.count))
                }
                completionHandler(.success(userDetailList))
            })
    }
    
    func getMockedJsonForGists() -> [Gist] {
        var data = [Gist]()
        if let path = Bundle(for: GistsTests.self).path(forResource: "Gists", ofType: "json") {
            do {
                  let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let gists = try! JSONDecoder().decode([Gist].self, from: jsonData)
                  data = gists
              } catch {
                   // handle error
              }
        }
        return data
    }
    
    func getMockedJsonForUserShares() -> [UserGistShares] {
        var data = [UserGistShares]()
        if let path = Bundle(for: GistsTests.self).path(forResource: "UserGists", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let userShares = try! JSONDecoder().decode([UserGistShares].self, from: jsonData)
                data = userShares
            } catch {
                // handle error
            }
        }
        return data
    }

}

