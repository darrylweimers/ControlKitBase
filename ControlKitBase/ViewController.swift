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
    private lazy var lensFiltersImages2: [UIImage] = {
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
        let controller = LensMenuController(menuItems: MoveItems.allCases, imageTintColor: .white, imageBackgroundColor: .systemRed, lensColor: .darkGray)
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(superview: self.view)
        view.backgroundColor = .white
        
        // test switch to another set of menu items
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.lensViewController.menuItems = AddItems.allCases
        }
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
    
    func lensMenuViewDidTapSelection(_ lensMenuView: UICollectionView, didTapSelectionAt indexPath: IndexPath, menuItem: MenuItem) {
        print(indexPath.row)
        print(menuItem)
        
        switch menuItem {
        case MoveItems.delete:
            print("It is a delete")
            break
        case MoveItems.share:
            break
        default:
            break
        }
    }
}

    
public enum MoveItems : MenuItem, CaseIterable {
    case delete
    case share
    case copy
    case archive

    public func getImage() -> UIImage {
        switch self {
        case .delete:
            return UIImage(systemName: "trash", withConfiguration: MoveItems.imageConfig)!
        case .share:
            return UIImage(systemName: "square.and.arrow.up", withConfiguration: MoveItems.imageConfig)!
        case .copy:
            return UIImage(systemName: "square.and.arrow.down.on.square", withConfiguration: MoveItems.imageConfig)!
        case .archive:
            return UIImage(systemName: "archivebox", withConfiguration: MoveItems.imageConfig)!
        }
    }

    public func getDescription() -> String {
        switch self {
        case .delete:
            return "delete"
        case .share:
            return "share"
        case .copy:
            return "copy"
        case .archive:
            return "archive"
        }
    }
    
    private static let imageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .small)
    
}

public enum AddItems : MenuItem, CaseIterable {
    case camera
    case photo
    case microphone
    case text
    case board
    
    public func getDescription() -> String {
        switch self {
        case .camera:
            return "camera"
        case .photo:
            return "photo"
        case .microphone:
            return "microphone"
        case .text:
            return "text"
        case .board:
            return "board"
        }
    }
    
    public func getImage() -> UIImage {
        switch self {
        case .camera:
            return UIImage(systemName: "camera", withConfiguration: AddItems.imageConfig)!
        case .photo:
            return UIImage(systemName: "photo", withConfiguration: AddItems.imageConfig)!
        case .microphone:
            return UIImage(systemName: "mic", withConfiguration: AddItems.imageConfig)!
        case .text:
            return UIImage(systemName: "square.and.pencil", withConfiguration: AddItems.imageConfig)!
        case .board:
            return UIImage(systemName: "note", withConfiguration: AddItems.imageConfig)!
        }
    }
    
    private static let imageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .light, scale: .small)
    
}
