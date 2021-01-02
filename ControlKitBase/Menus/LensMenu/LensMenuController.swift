import UIKit

public protocol LensMenuViewDelegate {
    func lensMenuView(_ lensMenuView: UICollectionView, didSelectAt indexPath: IndexPath)
}

public class LensMenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {

    public lazy var cameraImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "cameraicon")
        imageView.image = image
        imageView.tintColor = .systemBlue
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var lensCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: LensFlowLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.register(LensCircleCell.self, forCellWithReuseIdentifier: LensCircleCell.reuseIdentifier)
        return collectionView
    }()
    
    public var delegate: LensMenuViewDelegate?
    private let menuHeight: CGFloat = 75 // MARK: change this value to adjust button size; BEAWARE that dependent features might stop functioning perfectly te
    private var lensFiltersImages: [UIImage]
    private var itemManager: ItemManager
    private var itemDiameterScaleRatio: CGFloat = 0.9
    
    public init(lensFiltersImages: [UIImage]) {
        self.lensFiltersImages = lensFiltersImages
        let estimatedNumberOfVisibleItems = 5   // will be calculated after view did appear
        self.itemManager = ItemManager(numberOfItems: lensFiltersImages.count, numberOfVisibleItems: estimatedNumberOfVisibleItems)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(superview: self.view)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bounds = lensCollectionView.bounds
        let itemDiameter = bounds.size.height * itemDiameterScaleRatio
        let numberOfVisibleItems = Int((bounds.size.width) / itemDiameter)
        //print("numberOfVisibleItems - calculated: \(numberOfVisibleItems)")
        self.itemManager.numberOfVisibleItems = numberOfVisibleItems
        self.lensCollectionView.reloadData()
    }
    
    private func setupViews(superview: UIView) {
        superview.addSubview(lensCollectionView)
        
        NSLayoutConstraint.activate([
            lensCollectionView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            lensCollectionView.widthAnchor.constraint(equalTo: superview.widthAnchor),
            lensCollectionView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            lensCollectionView.heightAnchor.constraint(equalToConstant: menuHeight)
        ])
        
        superview.addSubview(cameraImageView)
        NSLayoutConstraint.activate([
            cameraImageView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            cameraImageView.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            cameraImageView.heightAnchor.constraint(equalToConstant: menuHeight),
            cameraImageView.widthAnchor.constraint(equalToConstant: menuHeight),
        ])
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let middleIndexPath = IndexPath(item: self.itemManager.normalizedNumberOfItems / 2, section: 0)
        selectCell(for: middleIndexPath, animated: false)
    }

    private func selectCell(for indexPath: IndexPath, animated: Bool) {
        lensCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        
        if let normalizedIndexPath = self.itemManager.getIndexPath(indexPath: indexPath) {
            delegate?.lensMenuView(self.lensCollectionView, didSelectAt: normalizedIndexPath)
        }
    }

    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemManager.normalizedNumberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(for: indexPath, animated: true)
    }

    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LensCircleCell.reuseIdentifier, for: indexPath) as? LensCircleCell else { fatalError() }
        
        cell.isHidden = false
        guard let normalizedIndexPath = self.itemManager.getIndexPath(indexPath: indexPath) else {
            cell.isHidden = true
            return cell
        }
        
        cell.image = lensFiltersImages[normalizedIndexPath.row]
        let itemDiameter = getItemDiameter(collectionView: collectionView, itemScaleRatio: itemDiameterScaleRatio)
        cell.imageCornerRadius = itemDiameter / 2
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemDiameter = getItemDiameter(collectionView: collectionView, itemScaleRatio: itemDiameterScaleRatio)
        print("side \(itemDiameter)")
        return CGSize(width: itemDiameter, height: itemDiameter)
    }
    
    private func getItemDiameter(collectionView: UICollectionView, itemScaleRatio: CGFloat) -> CGFloat {
        return collectionView.frame.height * itemDiameterScaleRatio
    }
    
    // MARK: UIScrollViewDelegate
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bounds = lensCollectionView.bounds
        let xPosition = lensCollectionView.contentOffset.x + bounds.size.width / 2.0
        let yPosition = bounds.size.height / 2.0
        let point = CGPoint(x: xPosition, y: yPosition)

        if let indexPath = lensCollectionView.indexPathForItem(at: point) {
            selectCell(for: indexPath, animated: true)
            return
        }
        
        // try again with an offset to the left
        let itemDiameter = self.getItemDiameter(collectionView: lensCollectionView, itemScaleRatio: itemDiameterScaleRatio)
        let adjustedPoint = CGPoint(x: xPosition - itemDiameter / 2, y: yPosition)
        if let indexPath = lensCollectionView.indexPathForItem(at: adjustedPoint) {
            selectCell(for: indexPath, animated: true)
            return
        }
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
          scrollViewDidEndDecelerating(scrollView)
        }
    }
}

struct ItemManager {
    
    public var numberOfVisibleItems: Int
    private let numberOfItems: Int
    private let numberOfPaddingItemPerSide: Int = 2 // pad to allow item to be reacheable by scrolling
    
    public init(numberOfItems: Int, numberOfVisibleItems: Int) {
        self.numberOfItems = numberOfItems
        self.numberOfVisibleItems = numberOfVisibleItems
    }
    
    public var normalizedNumberOfItems: Int {
        get {
            return numberOfPaddingItemPerSide + numberOfVisibleItems + numberOfPaddingItemPerSide
        }
    }
    
    public func isPaddingItem(indexPath: IndexPath) -> Bool {
        let index = indexPath.row // adjust for index path that starts from 0
        
        if index < numberOfPaddingItemPerSide ||
               index >= numberOfPaddingItemPerSide + numberOfItems {
            //print("padding index: \(index)")
            return true
        }
        //print("valid index: \(index)")
        return false
    }
    
    public func getIndexPath(indexPath: IndexPath) -> IndexPath? {
        guard !isPaddingItem(indexPath: indexPath) else {
            return nil
        }
        
        return IndexPath(row: indexPath.row - numberOfPaddingItemPerSide, section: indexPath.section)
    }
    
}
