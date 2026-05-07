//
//  PostRepo.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 08/05/2026.
//

import Foundation
import RxSwift

protocol PostRepositoryProtocol {
    func getAll() -> Observable<[Post]>
    func toggleFavorite(post: Post) -> Void
}


class PostRepository: PostRepositoryProtocol {
    
    func toggleFavorite(post: Post) {
        self.realmStore.updateFavouriteStatus(postId: post.id, isFavourite: !post.isFavorite)
    }
    
    private let provider = PostProvider.shared
    private let realmStore = PostRealmStore.shared
    private let disposeBag = DisposeBag()
    
    func getAll() -> Observable<[Post]> {
        return Observable.create { observer in
            
            // try to get data from realm
            let localPosts = self.realmStore.fetchLocalPosts()
            
            if !localPosts.isEmpty {
                observer.onNext(localPosts)
            }
            
            // call network request and save data
            self.provider.fetchPostsFromAPI()
                .map { dtos in dtos.map { $0.toDomain() } }
                .subscribe(onNext: { remotePosts in
                    
                    //make favourite if favourite in db
                    var updatedPosts: [Post] = []
                    for i in 0 ..< remotePosts.count {
                        let isFav = localPosts.contains(where: {
                            $0.id == remotePosts[i].id && $0.isFavorite
                        })
                        
                        if isFav {
                            print("POST IS FAVOURITE \(remotePosts[i].id)")
                        }
                        
                        let post = remotePosts[i]
                        updatedPosts.append(Post(id: post.id, userId: post.userId, title: post.title, body: post.body, isFavorite: isFav))
                    }
                    
                    // data received, save it to db
                    self.realmStore.savePostsToOffline(updatedPosts)
                    
                    // show latest data
                    observer.onNext(updatedPosts)
                    observer.onCompleted()
                    
                }, onError: { error in
                    // if network not available show local
                    if localPosts.isEmpty {
                        observer.onError(error)
                    } else {
                        observer.onCompleted()
                    }
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
