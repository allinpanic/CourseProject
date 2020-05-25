//
//  PostFooterView.swift
//  Course2FinalTask
//
//  Created by Rodianov on 06.03.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class PostFooterView: UIView {
  
  var likesLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    label.isUserInteractionEnabled = true
    return label
  }()
  
  var likeButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "like"), for: .normal)
    return button
  }()
  
   var postTextLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .black
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}

extension PostFooterView {
  private func setupLayout() {
    addSubview(likesLabel)
    addSubview(likeButton)
    addSubview(postTextLabel)
    
    likeButton.snp.makeConstraints{
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview().inset(15)
      $0.height.width.equalTo(44)
    }
    
    likesLabel.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(15)
      $0.centerY.equalTo(likeButton.snp.centerY)
    }
    
    postTextLabel.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(15)
      $0.trailing.equalToSuperview().offset(15)
      $0.top.equalTo(likeButton.snp.bottom)
      $0.bottom.equalToSuperview()
    }
  }
}
