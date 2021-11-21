
import Foundation

struct Constants {

    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
    
    static let defaultError = "An error occured. Please retry or come back later."
    static let forbidden = "Access Forbidden (Limit Exceeded), Please come back later"
    static let internalServer = "Internal Server Error"
    static let conflict = "Request could not be completed due to a conflict with the current state of the target resource."
    static let notFound = "No Data found. Please retry or come back later."
}
