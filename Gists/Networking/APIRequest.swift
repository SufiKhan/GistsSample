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
        let urlString = baseURL + path
        let url = try urlString.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        let encoding: ParameterEncoding = URLEncoding.default
        return try encoding.encode(urlRequest, with: parameters)
    }
}
