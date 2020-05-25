//
//  FeedPostCell.swift
//  Course2FinalTask
//
//  Created by Rodianov on 06.03.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import SnapKit
import DataProvider

protocol FeedPostCellDelegate: AnyObject {
  func postHeaderViewTapped(user: User)
  func postImageDoubleTapped(imageView: UIImageView)
  func likesLabelTapped(users: [User], title: String)
  func showAlert(_ alert: UIAlertController)
}

final class FeedPostCell: UITableViewCell {
  
  var post: Post?
  weak var delegate: FeedPostCellDelegate?
  
  private lazy var postHeader: PostHeader = {
    let header = PostHeader()
    header.addGestureRecognizer(tapGestureRecognizer)
    return header
  }()
  
  private lazy var postImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(doubleTapRecognizer)
    return imageView
  }()
  
  private var bigLikeImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "bigLike")
    imageView.isHidden = true
    return imageView
  }()
  
  private lazy var postFooter: PostFooterView = {
    let footer = PostFooterView()
    footer.likesLabel.addGestureRecognizer(likesTapRecognizer)
    return footer
  }()
  
  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postHeaderTapped))
    return tapGesture
  }()
  
  private lazy var doubleTapRecognizer: UITapGestureRecognizer = {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageTapped(_:)))
    tapGesture.numberOfTapsRequired = 2
    return tapGesture
  }()
  
  private lazy var likesTapRecognizer: UITapGestureRecognizer = {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likesCountTapped(_:)))
    return tapGesture
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Fill in cell

extension FeedPostCell {
  func setupLayout() {
    contentView.addSubview(postHeader)
    contentView.addSubview(postImageView)
    contentView.addSubview(bigLikeImageView)
    contentView.addSubview(postFooter)
    
    postHeader.snp.makeConstraints{
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(51)
    }
    
    postImageView.snp.makeConstraints{
      $0.top.equalTo(postHeader.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(postImageView.snp.width)
    }
    
    postFooter.snp.makeConstraints{
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(postImageView.snp.bottom)
      $0.bottom.equalToSuperview()
    }
    
    bigLikeImageView.snp.makeConstraints{
      $0.centerX.centerY.equalToSuperview()
    }
    
    postFooter.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
  }
  
  func configureCell() {
    let formater = DateFormatter()
    formater.timeStyle = .medium
    formater.dateStyle = .medium
    formater.doesRelativeDateFormatting = true
    
    if let post = post {
      postImageView.image = post.image
      postHeader.avatarImageView.image = post.authorAvatar
      postHeader.authorNameLabel.text = post.authorUsername
      postHeader.dateLabel.text = formater.string(from: post.createdTime)
      postFooter.likesLabel.text = "Likes: \(post.likedByCount)"
      postFooter.postTextLabel.text = post.description
      
      if post.currentUserLikesThisPost == false {
        postFooter.likeButton.tintColor = .lightGray
      } else {
        postFooter.likeButton.tintColor = .systemBlue
      }
    }
  }
}

// MARK: - Gesture Handlers

extension FeedPostCell {
  @objc func postHeaderTapped(_ recognizer: UITapGestureRecognizer) {
    
    if let userID = post?.author {
      DataProviders.shared.usersDataProvider.user(with: userID,
                                                  queue: DispatchQueue.main,
                                                  handler: { [weak self] user1 in
                                                    if let user1 = user1 {
                                                      
                                                      self?.delegate?.postHeaderViewTapped(user: user1)
                                                    } else {
                                                      let alert = UIAlertController(title: "Unknokn error!",
                                                                                    message: "Please, try again later",
                                                                                    preferredStyle: .alert)
                                                      let alertAction = UIAlertAction(title: "OK",
                                                                                      style: .default,
                                                                                      handler: { action in
                                                                                        alert.dismiss(animated: true, completion: nil)
                                                      })
                                                      alert.addAction(alertAction)
                                                      self?.delegate?.showAlert(alert)
                                                    }
      })
      
    }
  }  
  
  
  
  
  @objc func postImageTapped (_ gestureRecognizer: UITapGestureRecognizer) {
    delegate?.postImageDoubleTapped(imageView: bigLikeImageView)
    if post?.currentUserLikesThisPost == false {
      likeButtonPressed()
    }
  }
  
  @objc func likesCountTapped (_ gestureRecognizer: UITapGestureRecognizer) {
    if let postID = post?.id {
      
      DataProviders.shared.postsDataProvider.usersLikedPost(with: postID, queue: DispatchQueue.global(qos: .userInteractive) ) { [weak self] usersList in
        if let usersList = usersList {
          
          DispatchQueue.main.async {
            self?.delegate?.likesLabelTapped(users: usersList, title: "Likes")
          }
        }
      }
    }
  }
  
  @objc func likeButtonPressed () {
    if let postID = post?.id {
      if post?.currentUserLikesThisPost == true {
        print("to unlike")
        DataProviders.shared.postsDataProvider.unlikePost(with: postID, queue: DispatchQueue.main) {
          [weak self] post in
          if let post = post {
            print("unlike done \(post.currentUserLikesThisPost)")
            
            self?.postFooter.likeButton.tintColor = .lightGray
            self?.postFooter.likesLabel.text = "Likes: \(post.likedByCount)"
            
          }
        }
        print(post?.currentUserLikesThisPost)
      } else {
        print("to like")
        DataProviders.shared.postsDataProvider.likePost(with: postID, queue: DispatchQueue.main) {
          [weak self] post in
          if let post = post {
            print("like done \(post.currentUserLikesThisPost)")
            
            self?.postFooter.likeButton.tintColor = .systemBlue
            self?.postFooter.likesLabel.text = "Likes: \(post.likedByCount)"
            
          }          
        }
        print(post?.currentUserLikesThisPost)
      }
      
    }
    
  }
  
  
}
