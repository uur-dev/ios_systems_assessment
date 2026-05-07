//
//  PostViewController.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    
    let viewModel = PostViewModel()
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        // initial call
        viewModel.fetchAllPost()
    }
    
    private func setupUI() {
        tableView.refreshControl = refreshControl
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
        tableView.rowHeight = UITableView.automaticDimension
        // register nib for table view
        let nib = UINib(nibName: PostTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PostTableViewCell.nibName)
    }
    
    private func setupBindings() {
        viewModel.currentPostScreenState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                self?.handleUI(for: state)
            })
            .disposed(by: disposeBag)
        
        // pull to refresh action
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchAllPost(isRefreshing: true)
            })
            .disposed(by: disposeBag)
        
        // bind data to table view items
        viewModel.currentPostScreenState
            .compactMap { state -> [Post]? in
                if case .loaded(let posts) = state { return posts }
                return nil
            }
            .bind(to: tableView.rx.items(cellIdentifier: PostTableViewCell.nibName, cellType: PostTableViewCell.self)) { row, post, cell in
                cell.configure(with: post)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [weak self] post in
                self?.viewModel.toggleFavourite(for: post)
                let currentPosts = self?.viewModel.currentPosts ?? []
                self?.viewModel.currentPostScreenState.accept(.loaded(currentPosts))
            })
            .disposed(by: disposeBag)
        
        //for click
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                //deselect
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleUI(for state: PostState) {
        switch state {
        case .loading:
            refreshControl.beginRefreshing()
            print("Loading...")
            
        case .empty:
            refreshControl.endRefreshing()
            tableView.isHidden = true
            emptyStateLabel.isHidden = false
            
        case .loaded(let posts):
            refreshControl.endRefreshing()
            tableView.isHidden = false
            emptyStateLabel.isHidden = true
            
        case .error(let message):
            refreshControl.endRefreshing()
            print("Error: \(message)")
        }
    }
}

// MARK: - Post State
enum PostState {
    case loading
    case empty
    case loaded([Post])
    case error(String)
}
