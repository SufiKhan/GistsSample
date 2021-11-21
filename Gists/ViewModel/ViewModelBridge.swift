//
//  ViewModelBridge.swift
//  Gists
//
//  Created by sarfaraz.d.khan on 19/11/2021.
//

import Foundation

protocol ViewModelBridge {
    associatedtype Input
    associatedtype Output
}

enum AppState {
    case initialFetch, queryUserShares, fetchCompleted
}
