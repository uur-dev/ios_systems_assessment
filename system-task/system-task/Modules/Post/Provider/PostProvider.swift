//
//  PostProvider.swift
//  system-task
//
//  Created by Ubaid ur Rahman on 08/05/2026.
//

import Foundation
@preconcurrency import Alamofire
import RxSwift

final class PostProvider: Sendable {
    static let shared = PostProvider()
    private init() {}

    func fetchPostsFromAPI() -> Observable<[PostDTO]> {
        let url = "https://jsonplaceholder.typicode.com/posts"
        
        return Observable.create { observer in
            let request = AF.request(url, method: .get)
                .validate()
                .responseDecodable(of: [PostDTO].self, queue: .global(qos: .utility)) { response in
                    switch response.result {
                    case .success(let posts):
                        observer.onNext(posts)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
