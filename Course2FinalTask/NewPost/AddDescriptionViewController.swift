//
//  AddDescriptionViewController.swift
//  Course2FinalTask
//
//  Created by Rodianov on 13.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

final class AddDescriptionViewController: UIViewController {
  
  private var filteredImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private var addLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17)
    label.textColor = .black
    label.text = "Add description:"
    return label
  }()
  
  private lazy var descriptionTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  init(filteredImage: UIImage?) {
    self.filteredImageView.image = filteredImage
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(sharePost))
    
    setupLayout()
    handleKeyboard()
  }
}

extension AddDescriptionViewController {
  private func setupLayout() {
    view.backgroundColor = .white
    view.addSubview(filteredImageView)
    view.addSubview(addLabel)
    view.addSubview(descriptionTextField)
    
    filteredImageView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
      $0.leading.equalToSuperview().inset(16)
      $0.width.height.equalTo(100)
    }
    
    addLabel.snp.makeConstraints {
      $0.top.equalTo(filteredImageView.snp.bottom).offset(32)
      $0.leading.equalToSuperview().inset(16)
    }
    
    descriptionTextField.snp.makeConstraints {
      $0.trailing.leading.equalToSuperview().inset(16)
      $0.top.equalTo(addLabel.snp.bottom).offset(8)
    }
  }
}

extension AddDescriptionViewController {
  @objc private func sharePost() {
    guard let postImage = filteredImageView.image,
          let text = descriptionTextField.text else {return}
    
    DataProviders.shared.postsDataProvider.newPost(with: postImage,
                                                   description: text,
                                                   queue: DispatchQueue.global(qos: .userInteractive) ) {
                                                    [weak self] post in
                                                    DispatchQueue.main.async {
                                                      
                                                    }
    }
  }
}

extension AddDescriptionViewController {
  private func handleKeyboard() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyBoard))    
    view.addGestureRecognizer(tap)
  }
  
  @objc private func dissmissKeyBoard() {
    view.endEditing(true)
  }
}
