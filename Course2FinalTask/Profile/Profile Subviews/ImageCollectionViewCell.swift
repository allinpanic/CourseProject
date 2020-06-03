//
//  ImageCollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Rodianov on 07.03.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
  
  var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .cyan
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    
    imageView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
