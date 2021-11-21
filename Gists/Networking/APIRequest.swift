//
//  RequestModel.swift
//  Gists
//
//  Created by sarfaraz.d.khan on 21/11/2021.
//

import Foundation
import Alamofire

enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIRequest: URLRequestConvertible {
    var baseURL = "https://api.github.com"

    // MARK: - Properties
    var path: String {
        return ""
    }
    var parameters: Parameters? {
        return [:]
    }
    var headers: [String: String] {
        return [:]
    }
    var method: RequestHTTPMethod {
        return body.isEmpty ? RequestHTTPMethod.get : RequestHTTPMethod.post
    }
    var body: [String: Any?] {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        return try URLEncoding.queryString.encode(urlRequest, with: parameters)
    }
}
