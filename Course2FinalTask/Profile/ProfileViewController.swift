//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Rodianov on 07.03.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

final class ProfileViewController: UIViewController {

  var user: User?
// MARK: - Private properties
  
  private var reuseIdentifier = "imageCell"
  private var userPosts: [Post]?
  
  private lazy var profileScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .white
    scrollView.isScrollEnabled = true
    return scrollView
  }()
  
  private lazy var userImagesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  
  private lazy var profileInfoView: ProfileInfoView = {
    let profileInfo = ProfileInfoView()
    profileInfo.backgroundColor = .white
    profileInfo.delegate = self
    return profileInfo
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
// MARK: - Inits
  
  init (user: User?) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
//MARK: - ViewDidLoad
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userImagesCollectionView.dataSource = self
    userImagesCollectionView.delegate = self
    setupLayout()
  }
}
//MARK: - Layout

extension ProfileViewController {
  private func setupLayout() {
    view.addSubview(profileScrollView)
    profileScrollView.addSubview(profileInfoView)
    profileScrollView.addSubview(userImagesCollectionView)
    
    self.navigationItem.title = user?.username
    
    showIndicator()
    
    if let user = user {
      DataProviders.shared.postsDataProvider.findPosts(by: user.id,
                                                       queue: DispatchQueue.global(qos: .userInteractive))
      { [weak self] postArray in
        if let postArray = postArray {
          self?.userPosts = postArray.reversed()
          
          DispatchQueue.main.async {
            self?.userImagesCollectionView.reloadData()
            self?.hideIndicator()
          }
        } else {
          DispatchQueue.main.async {
          self?.showAlert()
          }
        }
      }
    }
    
    profileInfoView.user = user
    profileInfoView.fillProfileInfo()
    
    profileScrollView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    profileInfoView.snp.makeConstraints{
      $0.leading.trailing.top.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalTo(86)
    }
    
    userImagesCollectionView.snp.makeConstraints{
      $0.top.equalTo(profileInfoView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(view.bounds.height + 100)
    }
  }
}

// MARK: - CollectionViewDataSourse,Delegate

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return userPosts?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell
      else { return UICollectionViewCell()}
    cell.imageView.image = userPosts?[indexPath.item].image
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width/3, height: view.frame.width/3)
  }  
}
// MARK: - ProfileInfoViewDelegate

extension ProfileViewController: ProfileInfoViewDelegate {
  
  func followersTapped(userList: [User], title: String) {
    self.navigationController?.pushViewController(UsersListViewController(userList: userList, title: title), animated: true)
  }
  
  func followingTapped(userList: [User], title: String) {
    self.navigationController?.pushViewController(UsersListViewController(userList: userList, title: title), animated: true)
  }
  
  func showAlert() {
    let alert = UIAlertController(title: "Unknown Error", message: "Please, try again later", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
      [weak self] action in
      alert.dismiss(animated: true, completion: nil)
      self?.navigationController?.popViewController(animated: true)
    }))
    self.present(alert, animated: true, completion: nil)
  }
}
//MARK: - Activity indicator methods

extension ProfileViewController {
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
