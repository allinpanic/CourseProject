//
//  File.swift
//  Course2FinalTask
//
//  Created by Rodianov on 03.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class FollowButton: UIButton {
  
  override var intrinsicContentSize: CGSize  {
    get {
      let labelSize = titleLabel?.sizeThatFits(CGSize(width: self.frame.size.width,
                                                      height: self.frame.size.height)) ?? CGSize.zero
      let intrinsicSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right,
                                 height: self.frame.size.height)

      return intrinsicSize
    }
  }
}
