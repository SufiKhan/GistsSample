//
//  GistRequestModel.swift
//  Gists
//
//  Created by sarfaraz.d.khan on 21/11/2021.
//

import Foundation

class GistRequest: APIRequest {
    
    override var path: String {
        return "gists/public"
    }
    
    override var method: RequestHTTPMethod {
        return .get
    }
}
