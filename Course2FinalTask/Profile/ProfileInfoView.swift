//
//  ProfileInfoView.swift
//  Course2FinalTask
//
//  Created by Rodianov on 07.03.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol ProfileInfoViewDelegate: AnyObject {
  func followersTapped(userList: [User], title: String)
  func followingTapped(userList: [User], title: String)
  func showAlert()
  func showIndicator()
  func hideIndicator()
}

final class ProfileInfoView: UIView {
  weak var delegate: ProfileInfoViewDelegate?  
  var user: User?
//MARK: - Private properties
  
  private var userAvatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 35
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  private var userNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .black
    return label
  }()
  
  private lazy var followersLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .black
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(followersTapRecognizer)
    return label
  }()
  
  private lazy var followingLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .black
    label.isUserInteractionEnabled = true
    label.addGestureRecognizer(followingTapRecognizer)
    return label
  }()
  
  private var followButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor(named: "ButtonBlue")
    button.titleLabel?.textColor = .white
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.titleEdgeInsets.left = 6
    button.titleEdgeInsets.right = 6
    button.layer.cornerRadius = 4
    button.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var followersTapRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(followersLabelTapped(_:)))
    return gesture
  }()
  
  private lazy var followingTapRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(followinLabelTapped(_:)))
    return gesture
  }()
//MARK: - Inits
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
//MARK: - Fill in the View methods

extension ProfileInfoView {
  func setupLayout() {
    addSubview(userAvatarImageView)
    addSubview(userNameLabel)
    addSubview(followersLabel)
    addSubview(followingLabel)
    addSubview(followButton)
    
    userAvatarImageView.snp.makeConstraints{
      $0.height.width.equalTo(70)
      $0.top.equalToSuperview().offset(8)
      $0.leading.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().inset(8)
    }
    
    userNameLabel.snp.makeConstraints{
      $0.leading.equalTo(userAvatarImageView.snp.trailing).offset(8)
      $0.top.equalToSuperview().offset(8)
    }
    
    followersLabel.snp.makeConstraints{
      $0.leading.equalTo(userAvatarImageView.snp.trailing).offset(8)
      $0.bottom.equalToSuperview().inset(8)
    }
    
    followingLabel.snp.makeConstraints{
      $0.bottom.equalToSuperview().inset(8)
      $0.trailing.equalToSuperview().inset(8)
    }
    
    followButton.snp.makeConstraints{
      $0.top.equalToSuperview().inset(8)
      $0.trailing.equalTo(followingLabel)
      $0.width.greaterThanOrEqualTo(60).priority(750)
    }
  }
  
  func fillProfileInfo() {
    if let user = user {
      userAvatarImageView.image = user.avatar
      userNameLabel.text = user.fullName
      followersLabel.text = "Followers: \(user.followedByCount)"
      followersLabel.sizeToFit()
      followingLabel.text = "Following: \(user.followsCount)"
      
      if user.currentUserFollowsThisUser == true {
        followButton.setTitle("Unfollow", for: .normal)
        followButton.sizeToFit()
      } else {
        followButton.setTitle("Follow", for: .normal)
        followButton.sizeToFit()
      }
    }
  }
}
//MARK: - Gesture Handlers

extension ProfileInfoView {
  @objc func followersLabelTapped (_ recognizer: UITapGestureRecognizer) {
    let globalQueue = DispatchQueue.global(qos: .userInitiated)
    delegate?.showIndicator()
    if let userID = user?.id {
      
      DataProviders.shared.usersDataProvider.usersFollowingUser(with: userID, queue: globalQueue) { [weak self] usersArray in
        
        if let usersArray = usersArray {
          DispatchQueue.main.async {
            self?.delegate?.hideIndicator()
            self?.delegate?.followersTapped(userList: usersArray, title: "Followers")
          }
        }
      }
    }
  }
  
  @objc func followinLabelTapped (_ recognizer: UITapGestureRecognizer) {
    delegate?.showIndicator()
    if let userID = user?.id {
      
      DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userID, queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] usersArray in
        
        if let usersArray = usersArray {
          DispatchQueue.main.async {
            self?.delegate?.hideIndicator()
            self?.delegate?.followingTapped(userList: usersArray, title: "Following")
          }
        }
      }
    }
  }
  
  @objc func followButtonTapped () {
    if let user = user {
      if user.currentUserFollowsThisUser {
        print(user.currentUserFollowsThisUser)
        print("current user follows, to unfollow")
        DataProviders.shared.usersDataProvider.unfollow(user.id, queue: DispatchQueue.global(qos: .userInteractive)) {
          [weak self] user in
          if let user = user {
            DispatchQueue.main.async {
              self?.followersLabel.text = "Followers: \(user.followedByCount)"
              self?.followButton.setTitle("Follow", for: .normal)
              print(user.currentUserFollowsThisUser)
            }
          } else {
            DispatchQueue.main.async {
              self?.delegate?.showAlert()
            }
          }
        }
      } else {
        print(user.currentUserFollowsThisUser)
        print("current user unfollows, to follow")
        DataProviders.shared.usersDataProvider.follow(user.id, queue: DispatchQueue.global(qos: .userInteractive)) {
          [weak self] user in
          if let user = user {
            DispatchQueue.main.async {
              self?.followersLabel.text = "Followers: \(user.followedByCount)"
              self?.followButton.setTitle("Unfollow", for: .normal)
              print(user.currentUserFollowsThisUser)
            }
          } else {
            DispatchQueue.main.async {
              self?.delegate?.showAlert()
            }
          }
        }
      }
    }
    print(user?.currentUserFollowsThisUser)
  }
}
