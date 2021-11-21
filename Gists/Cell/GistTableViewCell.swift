
import Foundation
import UIKit
import RxSwift
import RxCocoa

class GistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var gistDescription: UILabel!
    @IBOutlet weak var gistFiles: UILabel!
    @IBOutlet weak var id: UILabel!

    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    var model: Gist! {
        didSet {
            gistDescription.text = model.description
            gistFiles.text =  "\(model.files.files.count) files"
            id.text =  "ID: \(model.id)"
            userImageView.loadImageUsingCache(withUrl: model.owner.avatar_url)

        }
    }
}
