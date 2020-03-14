//
//  PostHeader.swift
//  Course2FinalTask
//
//  Created by Rodianov on 06.03.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class PostHeader: UIView {
  
   var avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
   var authorNameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .semibold)
    label.textColor = .black
    return label
  }()
  
   var dateLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .black
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func setupLayout() {
    addSubview(avatarImageView)
    addSubview(authorNameLabel)
    addSubview(dateLabel)
    
    avatarImageView.snp.makeConstraints{
      $0.height.width.equalTo(35)
      $0.leading.equalToSuperview().offset(15)
      $0.top.equalToSuperview().inset(8)
    }
    
    authorNameLabel.snp.makeConstraints{
      $0.leading.equalTo(avatarImageView.snp.trailing).offset(8)
      $0.top.equalToSuperview().inset(8)
    }
    
    dateLabel.snp.makeConstraints{
      $0.leading.equalTo(authorNameLabel)
      $0.bottom.equalToSuperview().inset(8)
    }
  }
}
