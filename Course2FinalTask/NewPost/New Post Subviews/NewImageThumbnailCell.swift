//
//  NewImageThumbnailCell.swift
//  Course2FinalTask
//
//  Created by Rodianov on 12.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class NewImageThumbnailCell: UICollectionViewCell {
  
  var imageView: UIImageView = {
    let imageView = UIImageView()
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
