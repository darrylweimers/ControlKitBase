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
        let controller = LensMenuController(itemImages: lensFiltersImages, imageTintColor: .white, imageBackgroundColor: .systemRed, lensColor: .darkGray)
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(superview: self.view)
        view.backgroundColor = .white
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.lensViewController.menuItemImages = self.lensFiltersImages2
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
    
    func lensMenuViewDidTapSelection(_ lensMenuView: UICollectionView, didTapSelectionAt indexPath: IndexPath, didTapItem button: UIButton) {
//        print("button tapped")
//        print("\(lensMenuView.frame)")
//        print("\(lensMenuView.frame.width)")
//        print("\(lensMenuView.frame.height)")
//        print("\(lensMenuView.frame.midX)")
//        print("\(lensMenuView.frame.midY)")
//        
//        print("compare: \(CGPoint(x: button.bounds.midX, y: button.bounds.midY))")
//        let center = button.convert(button.center, to: self.view)
//        print(center)
//        //let center = CGPoint(x: lensMenuView.frame.width/2, y: lensMenuView.frame.height/2)
//        let pulse = PulseAnimation(numberOfPulse: 3, radius: 90, postion: center)
//        pulse.animationDuration = 1.0
//        pulse.backgroundColor = #colorLiteral(red: 0.8993218541, green: 0.1372507513, blue: 0.2670814395, alpha: 1)
//        view.layer.insertSublayer(pulse, below: self.view.layer)
        
//
//                let pulse1 = CASpringAnimation(keyPath: "transform.scale")
//                pulse1.duration = 0.6
//                pulse1.fromValue = 1.0
//                pulse1.toValue = 1.12
//                pulse1.autoreverses = true
//                pulse1.repeatCount = 3
//                pulse1.initialVelocity = 0.5
//                pulse1.damping = 0.8
//
//        //        let animationGroup = CAAnimationGroup()
//        //        animationGroup.duration = 2.7
//        //        animationGroup.repeatCount = 5
//        //        animationGroup.animations = [pulse1]
//
//                button.layer.add(pulse1, forKey: "pulse")
        
    }
}
