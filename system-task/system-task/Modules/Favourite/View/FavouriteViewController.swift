//
//  FavouriteViewController.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class FavouriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    let viewModel = FavouriteViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // initial call
        viewModel.fetchFavourites()
    }
    
    private func setupUI() {
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.isHidden = true
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
        
        tableView.register(UINib(nibName: PostTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PostTableViewCell.nibName)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupBindings() {
        viewModel.favouritePosts
            .bind(to: tableView.rx.items(cellIdentifier: PostTableViewCell.nibName, cellType: PostTableViewCell.self)) { row, post, cell in
                cell.configure(with: post)
            }
            .disposed(by: disposeBag)
        
        viewModel.favouritePosts
            .map { !$0.isEmpty }
            .subscribe(onNext: { [weak self] hasData in
                self?.tableView.isHidden = !hasData
                self?.emptyStateLabel.isHidden = hasData
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.removeFromFavourites(at: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

// MARK: - For Swipe to Delete
extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
