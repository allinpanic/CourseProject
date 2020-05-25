//
//  FilteredThumbnailCell.swift
//  Course2FinalTask
//
//  Created by Rodianov on 13.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FilteredThumbnailCell: UICollectionViewCell {
  
  var image: UIImage? {
    didSet {
      imageFiltered.image = image
    }
  }
  var filterName: String? {
    didSet {
      filterNameLabel.text = filterName
    }
  }
  
  var filterParameters: [String: Any]?
  
   private var imageFiltered: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private var filterNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 17)
    label.textColor = .black
    label.text = "filterName"
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FilteredThumbnailCell {
  func setupLayout() {
    contentView.addSubview(imageFiltered)
    contentView.addSubview(filterNameLabel)
    
    imageFiltered.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(50)
      $0.bottom.equalTo(filterNameLabel.snp.top).inset(-8)
    }
    
    filterNameLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(6)
    }
  }
}
