

import UIKit
import RxSwift
import RxCocoa

class GistListViewController: UIViewController, UITableViewDelegate {

    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    private var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private let viewModel = GistListViewModel(with: GistListViewModelDataManager(apiClient: ApiClient()))
    // MARK:- View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    // MARK:- SETUP UI
    
    private func setupUI() {
        title = "Gists"
        tableView.rowHeight = UITableView.automaticDimension
        let barButtonItem = UIBarButtonItem(customView: loader)
        self.navigationItem.rightBarButtonItem = barButtonItem
        tableView.register(GistTableViewCell.nib, forCellReuseIdentifier: GistTableViewCell.identifier)
        tableView.register(UserGistSharesTableViewCell.nib, forCellReuseIdentifier: UserGistSharesTableViewCell.identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        showAllGistList()
    }
    
    // MARK:- QUERYING DATA
    private func showAllGistList() {
        bindTableViewWithResult()
        bindLoader()
        subscribeToError()
        // Set app state to initial fetch to get gists list
        viewModel.input.viewState.onNext(.initialFetch)
    }
    
    // MARK:- Binding TableView
    
    private func bindTableViewWithResult() {
        // drive function will automatically switch to main thread on datasource update
        viewModel.output.datasource.asDriver()
            .drive(tableView.rx.items) { [weak self] (tv, row, item) -> UITableViewCell in
                guard let self = self else { return UITableViewCell() }
                if item is Gist {
                    return self.configGistCell(item: item as? Gist, atIndex: IndexPath(row: row, section: 0))
                } else if item is UserShares {
                    return self.configUserSharesCell(userShares: item as? UserShares, atIndex: IndexPath(row: row, section: 0))
                }
                return  UITableViewCell()
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GistListViewModel.T.self)
            .subscribe(onNext: { [weak self] model in
                if model is Gist {
                    if let detailVC = self?.storyboard?.instantiateViewController(identifier: "detailVC") as? DetailViewController {
                        detailVC.gist = model as? Gist
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }).disposed(by: disposeBag)

    }
    
    private func subscribeToError() {
        viewModel.output.errorMsg
            .drive(onNext: {[weak self] msg in
                guard let self = self else {return}
                self.showAlertController(msg: msg)
            }).disposed(by: disposeBag)
    }
}

// MARK:- UI State Management
extension GistListViewController {
    
    private func configGistCell(item: Gist?, atIndex: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: GistTableViewCell.identifier, for: atIndex) as? GistTableViewCell else {
            return UITableViewCell()
        }
        if let model = item {
            cell.model = model
        }
        return cell
    }
    
    private func configUserSharesCell(userShares: UserShares?, atIndex: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: UserGistSharesTableViewCell.identifier, for: atIndex) as? UserGistSharesTableViewCell else {
            return UITableViewCell()
        }
        if let model = userShares {
            cell.model = model
        }
        return cell
    }
}

extension GistListViewController {
    
    private func showAlertController(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        let retryAction = UIAlertAction (title: "Retry", style: UIAlertAction.Style.default) { action in
            self.viewModel.input.viewState.onNext(.initialFetch)
        }
        let cancelAction = UIAlertAction (title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
       self.present(alert, animated: true, completion: nil)
    }
    
    private func bindLoader() {
        viewModel.output.isFetching
            .drive(onNext: {[weak self] isLoadingData in
                guard let self = self else {return}
                if (isLoadingData) {
                    self.loader.startAnimating()
                } else {
                    self.loader.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
}

