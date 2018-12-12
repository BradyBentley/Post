//
//  PostListViewController.swift
//  Post
//
//  Created by Brady Bentley on 12/10/18.
//  Copyright © 2018 Brady. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    let refreshControl = UIRefreshControl()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.fetchPosts {
            self.reloadTableView()
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = PostController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username): \(Date.init(timeIntervalSince1970: post.timestamp))"
        
        
        return cell
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        PostController.fetchPosts {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
}

// MARK: - Alerts
extension PostListViewController {
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "Add new post", message: nil, preferredStyle: .alert)
        alertController.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "Username"
        }
        alertController.addTextField { (messageTextField) in
            messageTextField.placeholder = "Message"
        }
        guard let userTextField = alertController.textFields?[0].text,
            let messageTextField = alertController.textFields?[1].text else { return }
        let postAlertAction = UIAlertAction(title: "Post", style: .default) { (_) in
            if !userTextField.isEmpty, !messageTextField.isEmpty {
                PostController.addNewPostWith(username: userTextField, text: messageTextField, completion: {
                    self.reloadTableView()
                })
            } else {
                self.presentErrorAlert()
            }
        }
        let dimissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(postAlertAction)
        alertController.addAction(dimissAction)
        present(alertController, animated: true)
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Missing Information", message: "Please try again", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Try Again", style: .default) { (_) in
            self.presentNewPostAlert()
        }
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
        
    }
}
