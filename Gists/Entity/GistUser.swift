
import Foundation

struct GistUser: Codable {
    
    let login: String
    let avatar_url: String
    let url: String
    let gists_url: String
    let type: String
    let starred_url: String
}

struct UserShares: Hashable {
    var name: String
    var shares: Int
}
