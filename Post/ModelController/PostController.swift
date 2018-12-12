//
//  PostController.swift
//  Post
//
//  Created by Brady Bentley on 12/10/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import Foundation

class PostController {
    // MARK: - Properties
    let baseUrl = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    // source of Truth
    var posts: [Post] = []
    
    // MARK: - FetchFunctions
    func fetchPosts(completion: @escaping ()-> Void) {
        guard let unwrappedUrl = baseUrl else { completion() ; return }
        let getterEndpoint = unwrappedUrl.appendingPathComponent("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpMethod = "GET"
        request.httpBody = nil
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("There was an error in \(#function) : \(error.localizedDescription)")
                completion()
                return
            }
            guard let data = data else { completion() ; return }
            let jsonDecoder = JSONDecoder()
            do {
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                var posts = postsDictionary.compactMap({ ($0.value) })
                posts.sort(by: { $0.timestamp > $1.timestamp })
                self.posts = posts
                completion()
            } catch {
                print("There was an error in \(#function) : \(error.localizedDescription)")
                completion()
                return
            }
        }
            dataTask.resume()
    }
    
    
    
    
}


