//
//  ViewController.swift
//  ControlKit
//
//  Created by Darryl Weimers on 2021-01-01.
//

import UIKit
import UtilityKit

class ViewController: UIViewController, LensMenuViewDelegate {
    
    //  MARK: image test 1
//    private lazy var lensFiltersImages: [UIImage] = {
//        var images: [UIImage] = []
//        for i in 0...19 {
//          guard let image = UIImage(named: "face\(i)") else { break }
//          images.append(image)
//        }
//        return images
//    }()
    
    //  MARK: image test 2
//    private lazy var lensFiltersImages: [UIImage] = {
//        let aScalars = "a".unicodeScalars
//        let aCode = aScalars[aScalars.startIndex].value
//
//        let letters: [Character] = (0..<26).map {
//            i in Character(UnicodeScalar(aCode + i) ?? "a")
//        }
//
//        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .small)
//        var images: [UIImage] = []
//        for letter in letters {
//          guard let image = UIImage(systemName: "\(letter).circle.fill", withConfiguration: config) else { break }
//          images.append(image)
//        }
//        return images
//    }()

    
    // MARK: image test 3
    private lazy var lensFiltersImages: [UIImage] = {
        var images: [UIImage] = []
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .small)


        if let image = UIImage(systemName: "trash", withConfiguration: config) {
            images.append(image)
        }
        if let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: config) {
            images.append(image)
        }
        if let image = UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: config) {
            images.append(image)
        }
        if let image = UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: config) {
            images.append(image)
        }
        if let image = UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: config) {
            images.append(image)
        }
        return images
    }()

    public lazy var faceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var lensViewController: LensMenuController = {
        let controller = LensMenuController(lensFiltersImages: lensFiltersImages, imageTintColor: .white, imageBackgroundColor: .systemRed, lensColor: .darkGray)
        //controller.lensImageView.tintColor = .lightGray
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(superview: self.view)
        view.backgroundColor = .white
    }
    
    private func setupViews(superview: UIView) {
        
        add(lensViewController)
        NSLayoutConstraint.activate([
            lensViewController.view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            lensViewController.view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
//            lensViewController.view.widthAnchor.constraint(equalToConstant: 3 * 80),
//            lensViewController.view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            lensViewController.view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            lensViewController.view.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        superview.addSubview(faceImageView)
        NSLayoutConstraint.activate([
            faceImageView.heightAnchor.constraint(equalToConstant: 200),
            faceImageView.widthAnchor.constraint(equalToConstant: 200),
            faceImageView.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            faceImageView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        ])
    }
    
    // MARK: lens menu delegate
    func lensMenuView(_ lensMenuView: UICollectionView, didSelectAt indexPath: IndexPath) {
        faceImageView.image = lensFiltersImages[indexPath.row]
    }


}

