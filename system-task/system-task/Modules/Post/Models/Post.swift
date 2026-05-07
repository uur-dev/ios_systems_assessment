//
//  Post.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 07/05/2026.
//

import Foundation
import RealmSwift

// MARK: - Base Model (used by view model and view)
struct Post {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    var isFavorite: Bool

    init(id: Int, userId: Int, title: String, body: String, isFavorite: Bool = false) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
    }

    // from realm object
    init(realmObject: PostObject) {
        self.id = realmObject.id
        self.userId = realmObject.userId
        self.title = realmObject.title
        self.body = realmObject.body
        self.isFavorite = realmObject.isFavorite
    }
}

// MARK: - Realm Object
final class PostObject: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var userId: Int = 0
    @Persisted var title: String = ""
    @Persisted var body: String = ""
    @Persisted var isFavorite: Bool = false

    convenience init(post: Post) {
        self.init()
        self.id = post.id
        self.userId = post.userId
        self.title = post.title
        self.body = post.body
        self.isFavorite = post.isFavorite
    }

    func toDomain() -> Post {
        Post(realmObject: self)
    }
}

// MARK: - Post Response DTO
nonisolated struct PostDTO: Codable, Sendable {
    let id: Int
    let userId: Int
    let title: String
    let body: String

    @MainActor
    func toDomain(isFavorite: Bool = false) -> Post {
        Post(id: id, userId: userId, title: title, body: body, isFavorite: isFavorite)
    }
}
