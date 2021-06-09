//
//  ViewController.swift
//  ControlKit
//
//  Created by Darryl Weimers on 2021-01-01.
//

import UIKit
import UtilityKit

// MARK: dummy data source for testing menu
var testImages1: [UIImage] = {
    var images: [UIImage] = []
    for i in 0...19 {
      guard let image = UIImage(named: "face\(i)") else { break }
      images.append(image)
    }
    return images
}()

var testImages2: [UIImage] = {
    let aScalars = "a".unicodeScalars
    let aCode = aScalars[aScalars.startIndex].value

    let letters: [Character] = (0..<3).map {
        i in Character(UnicodeScalar(aCode + i) ?? "a")
    }

    let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .small)
    var images: [UIImage] = []
    for letter in letters {
      guard let image = UIImage(systemName: "\(letter).circle.fill", withConfiguration: config) else { break }
      images.append(image)
    }
    return images
}()

var testImages3: [UIImage] = {
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
    if let image = UIImage(systemName: "archivebox", withConfiguration: config) {
        images.append(image)
    }
    return images
}()


class ViewController: UIViewController, MenuViewControllerDelegate {

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var menuViewController: MenuViewController = {
        let controller = MenuViewController(images: testImages3, imageTintColor: .white, imageBackgroundColor: .systemRed, lensColor: .darkGray)
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(superview: self.view)
        view.backgroundColor = .black
    }
    
    private func setupViews(superview: UIView) {
        add(menuViewController)
        superview.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            menuViewController.view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            menuViewController.view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            menuViewController.view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            menuViewController.view.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        ])
    }
    
    // MARK: menu view controller delegate
    func menuViewController(_ lensMenuView: UICollectionView, didSelectAt indexPath: IndexPath) {
        print("selected image at index \(indexPath.row)")
        imageView.image = testImages3[indexPath.row]
    }
    
    func menuViewController(_ lensMenuView: UICollectionView, didTapSelectionAt indexPath: IndexPath) {
        print("selected image at index \(indexPath.row)")
    }
}
