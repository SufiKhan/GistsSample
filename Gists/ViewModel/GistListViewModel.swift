//
//  GistListViewModel.swift
//
//  Created by sarfaraz.d.khan on 18/11/2021.


import Foundation
import RxSwift
import RxCocoa

class GistListViewModel: ViewModelBridge {
    
    typealias T = Any
    private let disposeBag = DisposeBag()
    private var dataManager: ViewModelDataManager
    private let datasource: BehaviorRelay<[T]> = BehaviorRelay(value: [])
    private let errorMessage: PublishSubject<String> = PublishSubject()
    private let viewState = PublishSubject<AppState>()
    private let isFetchingInProgress = PublishSubject<Bool>()
    var input: Input
    var output: Output
    
    init() {
        dataManager = GistListViewModelDataManager(apiClient: ApiClient())
        input = Input(viewState: viewState.asObserver())
        output = Output(
            datasource: datasource.asDriver(),
            errorMsg: errorMessage.asDriver(onErrorJustReturn: ""),
            isFetching: isFetchingInProgress.asDriver(onErrorJustReturn: false)
        )
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewState.subscribe { [weak self] type in
            switch type.element {
            case .initialFetch: self?.getGistsFromGitHub()
            case .queryUserShares: self?.getGistsForUser()
            case .fetchCompleted: self?.isFetchingInProgress.onNext(false)
            case .none:break
            }
        }.disposed(by: disposeBag)
    }
    
    private func getGistsFromGitHub() {
        isFetchingInProgress.onNext(true)
        dataManager.getGistsFromServer { [weak self] result in
            switch result {
            case .success(let data):
                if !data.isEmpty {
                    self?.datasource.accept(data)
                    self?.viewState.onNext(.fetchCompleted)
                    //once Gist list is fetched proceed to query users shares
                    self?.viewState.onNext(.queryUserShares)
                } else {
                    self?.errorMessage.onNext(Constants.notFound)
                }
                
            case .failure(let errorMsg):
                self?.errorMessage.onNext(errorMsg)
                self?.viewState.onNext(.fetchCompleted)
            }
        }
    }
    
    private func getGistsForUser() {
        isFetchingInProgress.onNext(true)
        if let gists = datasource.value as? [Gist] {
            dataManager.queryUserForDetail(gists: gists) {[weak self] result in
                switch result {
                case .success(let userShares):
                    self?.updateGistList(list: userShares)
                    self?.viewState.onNext(.fetchCompleted)
                case .failure(_):
                    // We do not show any error if the user shares api because the initial list is already loaded
                    // so we fetch it again when user launches the app next time
                    self?.viewState.onNext(.fetchCompleted)
                }
//
            }
        }
    }
        
    private func updateGistList(list: Set<UserShares> ) {
        if list.isEmpty {return}
        var tempDatasource = datasource.value
        _ = list.map {
            let element = $0
            if let index = tempDatasource.firstIndex(where: { ($0 as? Gist)?.owner.login == element.name}) {
                // Insert the user detail below his gist append it at next index
                tempDatasource.insert(element, at: index + 1)
            }
        }
        datasource.accept(tempDatasource)
    }
}

extension GistListViewModel {
    struct Input {
        let viewState: AnyObserver<AppState>
    }
    
    struct Output {
        let datasource: Driver<[T]>
        let errorMsg: Driver<String>
        let isFetching: Driver<Bool>
    }
}
