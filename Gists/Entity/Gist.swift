
import Foundation

struct Gist: Codable {
    let id: String
    let description: String?
    let url: String
    let owner: GistUser
    let files: UserFiles
    let comments: Int
    let availableUserGistCount: Int?
}
