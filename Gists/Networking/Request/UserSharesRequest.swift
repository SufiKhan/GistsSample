//
//  UserSharesRequestModel.swift
//  Gists
//
//  Created by sarfaraz.d.khan on 21/11/2021.
//

import Foundation

class UserSharesRequest: APIRequest {
    private var username: String
    
    init(username: String) {
        self.username = username
    }
    
    override var path: String {
        return "users/\(username)/gists"
    }
    
    override var method: RequestHTTPMethod {
        return .get
    }
}
