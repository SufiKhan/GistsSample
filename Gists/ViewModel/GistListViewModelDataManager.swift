//
//  UserSharesDataManager.swift
//  Gists
//
//  Created by sarfaraz.d.khan on 20/11/2021.
//

import RxSwift

enum Result<Value> {
    case success(Value)
    case failure(String)
}

class GistListViewModelDataManager {
    private var apiClient: Service
    private let disposeBag = DisposeBag()

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getGistsFromServer(completionHandler: @escaping (Result<[Gist]>) -> Void) {
        apiClient.getGists().observe(on: MainScheduler.instance)
        .subscribe(
            onNext: { gistsList in
                completionHandler(.success(gistsList))
            }, onError: { error in
                var reason = Constants.defaultError
                switch error {
                case ApiError.conflict:
                    reason = Constants.conflict
                case ApiError.forbidden:
                    reason = Constants.forbidden
                case ApiError.notFound:
                    reason = Constants.notFound
                case ApiError.internalServerError:
                    reason =  Constants.internalServer
                default:
                    break
                }
                completionHandler(.failure(reason))
        })
        .disposed(by: disposeBag)
    }
    
    func queryUserForDetail(gists: [Gist], completionHandler: @escaping (Result<Set<UserShares>>) -> Void) {
        let group = DispatchGroup()
        var userDetailList = Set<UserShares>()
        gists.forEach { gist in
            group.enter()
            apiClient.getUserGists(username: gist.owner.login).subscribe {  userGists in
                group.leave()
                if (userGists.count >= 5) {
                    userDetailList.insert(UserShares(name: gist.owner.login, shares: userGists.count))
                }
            } onError: { error in
                group.leave()
            }.disposed(by: disposeBag)
        }
        group.notify(queue: .global()) {
            completionHandler(.success(userDetailList))
        }
    }
}
