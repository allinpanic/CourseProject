//
//  FilterImageViewController.swift
//  Course2FinalTask
//
//  Created by Rodianov on 13.05.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

final class FilterImageViewController: UIViewController {
  private var selectedImage: UIImage
  private var index: Int
  private let context = CIContext()
  private var filterParametersArray: [[String: Any]] = []
  
  private let reuseIdentifier = "filterThumbnail"
  private let filterNames: [String] = []
  private var thumbnails: [UIImage]?
  
  private lazy var imageViewToFilter: UIImageView = {
    let imageView = UIImageView()
    imageView.image = selectedImage
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private lazy var filtersPreviewCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 16
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .white
    collectionView.register(FilteredThumbnailCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  private var indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.style = .white
    return indicator
  }()
  
  private var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = .black
    view.alpha = 0.7
    return view
  }()
  
  init(image: UIImage, index: Int) {
    self.selectedImage = image
    self.index = index
    super.init(nibName: nil, bundle: nil)
    self.navigationItem.title = "Filters"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLayout()
    
    getThumbnails()
    filterCollectionView()
  }
}
//MARK: - CollectionView Datasource, Delegate

extension FilterImageViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Filters.filterNamesArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FilteredThumbnailCell else {return UICollectionViewCell()}

    cell.image = thumbnails?[indexPath.row]
    cell.filterName = Filters.filterNamesArray[indexPath.row]
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 120, height: 120)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let imageToFilter = self.selectedImage
    guard let ciImage = CIImage(image: imageToFilter) else {return}
    showIndicator()
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      
      let parameters = self?.getParameters(filter: Filters.filterNamesArray[indexPath.row],
                                           image: imageToFilter)
      let filteredImage = self?.applyFilter(name: Filters.filterNamesArray[indexPath.row],
                                            parameters: parameters ?? [kCIInputImageKey: ciImage])
      
      DispatchQueue.main.async {
        self?.hideIndicator()
        self?.imageViewToFilter.image = filteredImage
      }
    }
  }
}
//MARK: - Layout

extension FilterImageViewController {
  private func setupLayout() {
    view.backgroundColor = .white
    view.addSubview(imageViewToFilter)
    view.addSubview(filtersPreviewCollectionView)
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(showAddDescriptionToPost))
    
    imageViewToFilter.snp.makeConstraints{
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
    
    filtersPreviewCollectionView.snp.makeConstraints{
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(120)
    }
  }
}

extension FilterImageViewController {
  @objc private func showAddDescriptionToPost() {
    self.navigationController?.pushViewController(AddDescriptionViewController(filteredImage: imageViewToFilter.image), animated: true)
  }
}
// MARK: - Filter images

extension FilterImageViewController {
  private func getThumbnails() {
    thumbnails = []
    let allImagesArray = DataProviders.shared.photoProvider.thumbnailPhotos()
    let thumbnail = allImagesArray[index]
    let count = Filters.filterNamesArray.count
    
    for _ in 0...count - 1 {
      thumbnails?.append(thumbnail)
    }
  }
  
  private func filterCollectionView() {
    let globalQueue = DispatchQueue.global(qos: .background)
    var parameters: [String: Any] = [:]
    
    for (index, filter) in Filters.filterNamesArray.enumerated() {
      guard let thumbnails = self.thumbnails else {continue}
      
      globalQueue.async { [weak self] in
        guard let self = self else {return}
        parameters = self.getParameters(filter: filter, image: thumbnails[index])
        
        guard let image = self.applyFilter(name: filter, parameters: parameters) else {return}
        self.thumbnails?[index] = image
        
        DispatchQueue.main.async {
          self.filtersPreviewCollectionView.reloadData()
        }
      }
    }
  }
  
  private func applyFilter(name: String, parameters: [String: Any]) -> UIImage? {
    
    guard let filter = CIFilter(name: name, parameters: parameters),
      let outputImage = filter.outputImage,
      let cgiimage = context.createCGImage(outputImage, from: outputImage.extent) else {return nil}
    
    return UIImage(cgImage: cgiimage)
  }
  
  private func getParameters(filter: String, image: UIImage) -> [String: Any] {
    var parameters: [String: Any] = [:]
    guard let ciimage = CIImage(image: image) else {return parameters}
    
    switch filter {
    case "CIGaussianBlur":
      parameters = [kCIInputImageKey: ciimage, kCIInputRadiusKey: 3.0]
    case "CIMotionBlur":
      parameters = [kCIInputImageKey: ciimage, kCIInputRadiusKey: 2.0]
    case "CICrystallize":
      parameters = [kCIInputImageKey: ciimage, kCIInputRadiusKey: 2.0]
    case "CIBloom":
      parameters = [kCIInputImageKey: ciimage, kCIInputIntensityKey: 1.0]
    case "CIColorMonochrome":
      parameters = [kCIInputImageKey: ciimage, kCIInputColorKey: CIColor.white, kCIInputIntensityKey: 0.6]
    case "CIVignetteEffect":
      parameters = [kCIInputImageKey: ciimage, kCIInputIntensityKey: 0.2, kCIInputRadiusKey: 0.5]
    default:
      parameters = [kCIInputImageKey: ciimage]
    }
    
    return parameters
  }
}

extension FilterImageViewController {
  private func showIndicator() {
    view.addSubview(dimmedView)
    dimmedView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    dimmedView.addSubview(indicator)
    indicator.startAnimating()
    indicator.snp.makeConstraints{
      $0.center.equalToSuperview()
    }
  }
  
  private func hideIndicator() {
    indicator.stopAnimating()
    indicator.hidesWhenStopped = true
    indicator.removeFromSuperview()
    dimmedView.removeFromSuperview()
  }
}


