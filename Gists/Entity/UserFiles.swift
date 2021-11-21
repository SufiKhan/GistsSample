
import Foundation

struct UserFiles : Codable {
    
    struct FileTypeKey : CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
        
        static let type = FileTypeKey(stringValue: "type")!
        static let filename = FileTypeKey(stringValue: "filename")!
        static let size = FileTypeKey(stringValue: "size")!
        static let raw_url = FileTypeKey(stringValue: "raw_url")!
    }
    
    struct File: Codable {
        let filename: String
        let type: String
        let raw_url: String
        let size: Int64
    }
    
    let files : [File]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FileTypeKey.self)
        
        var files: [File] = []
        for key in container.allKeys {
            let nested = try container.nestedContainer(keyedBy: FileTypeKey.self, forKey: key)
            let type = try nested.decode(String.self, forKey: .type)
            let filename = try nested.decode(String.self, forKey: .filename)
            let rawURL = try nested.decode(String.self, forKey: .raw_url)
            let size = try nested.decode(Int64.self, forKey: .size)
            files.append(File.init(filename: filename, type: type, raw_url: rawURL, size: size))
        }
        
        self.files = files
    }
}

