

import Foundation

struct UserGistShares : Codable {
	let url : String?
	let forks_url : String?
	let commits_url : String?
	let id : String?
	let owner : Owner?

	enum CodingKeys: String, CodingKey {

		case url = "url"
		case forks_url = "forks_url"
		case commits_url = "commits_url"
		case id = "id"
		case owner = "owner"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		forks_url = try values.decodeIfPresent(String.self, forKey: .forks_url)
		commits_url = try values.decodeIfPresent(String.self, forKey: .commits_url)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
	}

}
struct Owner : Codable {
    let login : String?

    enum CodingKeys: String, CodingKey {

        case login = "login"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
    }
}
