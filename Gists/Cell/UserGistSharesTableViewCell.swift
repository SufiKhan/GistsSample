
import Foundation
import UIKit
import RxSwift
import RxCocoa


class UserGistSharesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var shares: UILabel!

    var model: UserShares! {
        didSet {
            self.username.text = model.name
            self.shares.text = "Shares: \(String(describing: model.shares))"
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
