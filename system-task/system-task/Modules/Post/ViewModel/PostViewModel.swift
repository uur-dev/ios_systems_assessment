//
//  PostViewModel.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 08/05/2026.
//

import Foundation
import RxSwift
import RxRelay

class PostViewModel {
    
    private let postRepository: PostRepository = PostRepository()
    private let disposeBag: DisposeBag = DisposeBag()
    
    let currentPostScreenState = BehaviorRelay<PostState>(value: .loading)
    private var _currentPosts: [Post] = []
    
    var currentPosts: [Post] {
        get {
            return _currentPosts
        }
    }
    
    public func fetchAllPost(isRefreshing: Bool = false) {
        if !isRefreshing {
            currentPostScreenState.accept(.loading)
        }
        
        postRepository.getAll().subscribe(onNext: { [weak self] posts in
            self?._currentPosts = posts
            if posts.isEmpty {
                self?.currentPostScreenState.accept(.empty)
            } else {
                self?.currentPostScreenState.accept(.loaded(posts))
            }
        }, onError: { [weak self] error in
            self?.currentPostScreenState.accept(.error(error.localizedDescription))
        })
        .disposed(by: disposeBag)
    }
    
    func toggleFavourite(for post: Post) {
        if let index = _currentPosts.firstIndex(where: { $0.id == post.id }) {
            _currentPosts[index].isFavorite.toggle()
        }
        
        postRepository.toggleFavorite(post: post)
    }
}
