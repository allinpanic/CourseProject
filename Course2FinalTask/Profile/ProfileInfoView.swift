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
}

final class ProfileInfoView: UIView {
  weak var delegate: ProfileInfoViewDelegate?  
  var user: User?
  
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
  
  private lazy var followersTapRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(followersLabelTapped(_:)))
    return gesture
  }()
  
  private lazy var followingTapRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(followinLabelTapped(_:)))
    return gesture
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProfileInfoView {
  func setupLayout() {
    addSubview(userAvatarImageView)
    addSubview(userNameLabel)
    addSubview(followersLabel)
    addSubview(followingLabel)
    
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
  }
  
  func fillProfileInfo() {
    if let user = user {
      userAvatarImageView.image = user.avatar
      userNameLabel.text = user.fullName
      followersLabel.text = "Followers: \(user.followedByCount)"
      followersLabel.sizeToFit()
      followingLabel.text = "Following: \(user.followsCount)"
    }
  }
}

extension ProfileInfoView {
  @objc func followersLabelTapped (_ recognizer: UITapGestureRecognizer) {
    if let userID = user?.id {
      if let userList = DataProviders.shared.usersDataProvider.usersFollowingUser(with: userID) {
        delegate?.followersTapped(userList: userList, title: "Followers")
      }
    }
  }
  
  @objc func followinLabelTapped (_ recognizer: UITapGestureRecognizer) {
    if let userID = user?.id {
      if let userList = DataProviders.shared.usersDataProvider.usersFollowedByUser(with: userID) {
        delegate?.followingTapped(userList: userList, title: "Following")
      }
    }
  }
}
