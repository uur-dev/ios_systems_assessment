//
//  PostRealmStore.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 08/05/2026.
//

import Foundation
import RealmSwift

final class PostRealmStore: Sendable {
    static let shared = PostRealmStore()
    
    // make realm intance thread safe
    private var realm: Realm {
        return try! Realm()
    }
    
    private init() {}

    // to fetech local data
    func fetchLocalPosts() -> [Post] {
        let objects = realm.objects(PostObject.self)
        return objects.map { $0.toDomain() }
    }

    // to save data
    func savePostsToOffline(_ posts: [Post]) {
        DispatchQueue.main.async {
            do {
                let realmInstance = try Realm()
                try realmInstance.write {
                    let objects = posts.map { PostObject(post: $0) }
                    realmInstance.add(objects, update: .modified)
                }
            } catch {
                print("Realm Error: \(error.localizedDescription)")
            }
        }
    }
    
    //for toggling - favourite
    func updateFavouriteStatus(postId: Int, isFavourite: Bool) {
        do {
            if let objectToUpdate = realm.object(ofType: PostObject.self, forPrimaryKey: postId) {
                try realm.write {
                    objectToUpdate.isFavorite = isFavourite
                }
            }
        } catch {
            print("Failed to update favourite status: \(error)")
        }
    }
    
    //clear Database
    func clearAllPosts() {
        try? realm.write {
            let allPosts = realm.objects(PostObject.self)
            realm.delete(allPosts)
        }
    }
}
