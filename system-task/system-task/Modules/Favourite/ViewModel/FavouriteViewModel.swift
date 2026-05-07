//
//  FavouriteViewModel.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 08/05/2026.
//

import Foundation
import RxSwift
import RxCocoa

class FavouriteViewModel {
    let favouritePosts = BehaviorRelay<[Post]>(value: [])
    let disposeBag = DisposeBag()

    func fetchFavourites() {
        let allLocal = PostRealmStore.shared.fetchLocalPosts()
        let filtered = allLocal.filter { $0.isFavorite }
        favouritePosts.accept(filtered)
    }

    func removeFromFavourites(at index: Int) {
        var current = favouritePosts.value
        let postToRemove = current[index]
        
        PostRealmStore.shared.updateFavouriteStatus(postId: postToRemove.id, isFavourite: false)
        
        current.remove(at: index)
        favouritePosts.accept(current)
    }
}
