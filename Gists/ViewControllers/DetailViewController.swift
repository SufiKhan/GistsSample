import Foundation
import RxSwift
import UIKit

class DetailViewController: UIViewController {
 
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var filesLabel: UILabel!
    @IBOutlet weak var favButtonSwitch: UISwitch!
    @IBOutlet weak var userImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    var gist: Gist?

    // MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // MARK:- Setup UI
    
    func updateUI() {
        guard let model = gist else {
            return
        }
        title = model.owner.login
        userNameLabel.text = "Name: \(model.owner.login)"
        descriptionLabel.text = model.description
        filesLabel.text = "URL:  \(model.url)"
        userImageView.loadImageUsingCache(withUrl: model.owner.avatar_url)
        let isFav = UserDefaults.standard.bool(forKey: model.id)
        favButtonSwitch.setOn(isFav, animated: true)
    }
    
    @IBAction func valueChanged(switch: UISwitch) {
        guard let model = gist else {
            return
        }
        let isOn = favButtonSwitch.isOn
        UserDefaults.standard.set(isOn, forKey: model.id)
        UserDefaults.standard.synchronize()
    }
}

