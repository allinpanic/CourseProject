//
//  FeedViewController.swift
//  Course2FinalTask
//
//  Created by Rodianov on 06.03.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

final class FeedViewController: UIViewController {  
  private lazy var feedTableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.allowsSelection = false
    tableView.register(FeedPostCell.self, forCellReuseIdentifier: reuseIdentifier)
    return tableView
  }()
  
  private var indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.style = .white
    return indicator
  }()
  
  private var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.7
    return view
  }()
  
  let reuseIdentifier = "postCell"
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()

    feedTableView.dataSource = self
    setupLayout()
    
    showIndicator()
    
    DataProviders.shared.postsDataProvider.feed(queue: DispatchQueue.global(qos: .userInitiated)) {[weak self] postsArray in
      if let postsArray = postsArray {
        self?.posts = postsArray
      }
      DispatchQueue.main.async {
        self?.feedTableView.reloadData()
        self?.hideIndicator()
      }
    }
  }
}

extension FeedViewController {
  func setupLayout() {
    view.addSubview(feedTableView)
    
    feedTableView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }
}
//MARK: - TableView DataSource

extension FeedViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = feedTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? FeedPostCell
      else { return UITableViewCell() }
    cell.post = posts[indexPath.row]  
    cell.configureCell()
    cell.delegate = self
    return cell
  }
}
//MARK: - PostCell Delegate methods

extension FeedViewController: FeedPostCellDelegate {
  func showAlert(_ alert: UIAlertController) {
    present(alert, animated: true, completion: nil)
  }
  
  func postHeaderViewTapped(user: User) {
    self.navigationController?.pushViewController(ProfileViewController(user: user), animated: true)
  }
  
  func postImageDoubleTapped(imageView: UIImageView) {
    imageView.isHidden = false
    animateImage(imageView: imageView)
  }
  
  func likesLabelTapped(users: [User], title: String) {
    self.navigationController?.pushViewController(UsersListViewController(userList: users, title: title), animated: true)
  }
}
//MARK: - Animation

extension FeedViewController {
  func animateImage (imageView: UIImageView) {
    let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
    animation.values = [0, 1, 1, 0]
    animation.keyTimes = [0, 0.17, 0.7, 1]
    animation.duration = 0.6
    animation.timingFunctions = [CAMediaTimingFunction(name: .linear),
                                 CAMediaTimingFunction(name: .linear),
                                 CAMediaTimingFunction(name: .easeOut)]
    imageView.layer.add(animation, forKey: "opacity")
    imageView.layer.opacity = 0
  }
}

extension FeedViewController {
  func showIndicator() {
    view.addSubview(dimmedView)
    dimmedView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    dimmedView.addSubview(indicator)
    indicator.startAnimating()
    indicator.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
  }
  
  func hideIndicator() {
    indicator.stopAnimating()
    indicator.hidesWhenStopped = true
    indicator.removeFromSuperview()
    dimmedView.removeFromSuperview()
  }
}
