import UIKit

public protocol LensMenuViewDelegate {
    func lensMenuView(_ lensMenuView: UICollectionView, didSelectAt indexPath: IndexPath)
    func lensMenuViewDidTapSelection(_ lensMenuView: UICollectionView, didTapSelectionAt indexPath: IndexPath, didTapItem button: UIButton)
}

public class LensMenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: stored properties
    public var doPerformSelectionFeedback: Bool
    public var doPulseAnimationOnSelection: Bool
    public var lensColor: UIColor
    public var imageBackgroundColor: UIColor
    public var imageTintColor: UIColor
    public var delegate: LensMenuViewDelegate?
    private let menuHeight: CGFloat = 75 // MARK: change this value to adjust button size; BE AWARE that dependent features might stop functioning perfectly
    private var itemImages: [UIImage]
    private var itemManager: ItemManager
    private var itemDiameterScaleRatio: CGFloat = 0.9
    private var itemSelected: IndexPath?
    
    // MARK: UIViews
    private lazy var lensImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "cameraicon")
        imageView.image = image
        imageView.tintColor = lensColor
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var lensCollectionView: UICollectionView = {
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
    
    private lazy var pulsatingCircularView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = menuHeight/2
        view.layer.masksToBounds = true
        return view
    }()
    
    public var menuItemImages: [UIImage] {
        set(images){
            itemImages = images
            lensCollectionView.reloadData()
            self.itemManager = ItemManager(numberOfItems: images.count, numberOfVisibleItems: computeForTheNumberOfVisibleItems())
        }
        get {
            return itemImages
        }
    }
        
    // MARK: init
    public init(itemImages: [UIImage],
                imageTintColor: UIColor = .white,
                imageBackgroundColor: UIColor = .systemBlue,
                lensColor: UIColor = .lightGray,
                doPerformSelectionFeedback: Bool = true,
                doPulseAnimationOnSelection: Bool = true) {
        self.doPerformSelectionFeedback = doPerformSelectionFeedback
        self.doPulseAnimationOnSelection = doPulseAnimationOnSelection
        self.itemImages = itemImages
        self.lensColor = lensColor
        self.imageBackgroundColor = imageBackgroundColor
        self.imageTintColor = imageTintColor
        let estimatedNumberOfVisibleItems = 5   // will be calculated after view did appear
        self.itemManager = ItemManager(numberOfItems: itemImages.count, numberOfVisibleItems: estimatedNumberOfVisibleItems)
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
        self.itemManager.numberOfVisibleItems = computeForTheNumberOfVisibleItems()
        self.lensCollectionView.reloadData()
    }
    
    private func computeForTheNumberOfVisibleItems() -> Int {
        let bounds = lensCollectionView.bounds
        let itemDiameter = bounds.size.height * itemDiameterScaleRatio
        let numberOfVisibleItems = Int((bounds.size.width) / itemDiameter)
        //print("numberOfVisibleItems - calculated: \(numberOfVisibleItems)")
        return numberOfVisibleItems
    }
    
    private func setupViews(superview: UIView) {
        superview.addSubview(pulsatingCircularView)
        NSLayoutConstraint.activate([
            pulsatingCircularView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            pulsatingCircularView.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            pulsatingCircularView.heightAnchor.constraint(equalToConstant: menuHeight),
            pulsatingCircularView.widthAnchor.constraint(equalToConstant: menuHeight),
        ])

        superview.addSubview(lensCollectionView)
        NSLayoutConstraint.activate([
            lensCollectionView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            lensCollectionView.widthAnchor.constraint(equalTo: superview.widthAnchor),
            lensCollectionView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            lensCollectionView.heightAnchor.constraint(equalToConstant: menuHeight)
        ])
        
        superview.addSubview(lensImageView)
        NSLayoutConstraint.activate([
            lensImageView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            lensImageView.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            lensImageView.heightAnchor.constraint(equalToConstant: menuHeight),
            lensImageView.widthAnchor.constraint(equalToConstant: menuHeight),
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
        
        // save selected item and reload to make button item tappable
        itemSelected = indexPath
        self.lensCollectionView.reloadData()
    }

    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemManager.normalizedNumberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(for: indexPath, animated: true)
    }
    
    // MARK: button tapped handler
    @objc private func buttonTapped(_ button: UIButton) {
        
        if doPerformSelectionFeedback {
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        }
        
        if doPulseAnimationOnSelection  {
                CATransaction.begin()
                
                CATransaction.setCompletionBlock {
                    self.pulsatingCircularView.backgroundColor = .clear
                }
                
                self.pulsatingCircularView.backgroundColor = self.imageBackgroundColor
                self.pulsatingCircularView.layer.add(Animator.createPulsingAnimation(), forKey: "pulsing")
                CATransaction.commit()
        }
       
        if let itemSelected = itemSelected {
            delegate?.lensMenuViewDidTapSelection(self.lensCollectionView, didTapSelectionAt: itemSelected, didTapItem: button)
        }
    }
    
    // MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LensCircleCell.reuseIdentifier, for: indexPath) as? LensCircleCell else { fatalError() }
        
        cell.isHidden = false
        cell.button.isUserInteractionEnabled = false
        cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        guard let normalizedIndexPath = self.itemManager.getIndexPath(indexPath: indexPath) else {
            cell.isHidden = true
            return cell
        }
        
        if let itemSelected = itemSelected,
                indexPath == itemSelected {
            cell.button.isUserInteractionEnabled = true
        }
        
        cell.image = itemImages[normalizedIndexPath.row]
        let itemDiameter = getItemDiameter(collectionView: collectionView, itemScaleRatio: itemDiameterScaleRatio)
        cell.imageCornerRadius = itemDiameter / 2
        cell.button.tintColor = imageTintColor
        cell.button.backgroundColor = imageBackgroundColor
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemDiameter = getItemDiameter(collectionView: collectionView, itemScaleRatio: itemDiameterScaleRatio)
        //print("side \(itemDiameter)")
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
    
    // MARK: animation
    fileprivate struct Animator {
        public static func createOpacityAnimation(animationDuration: Double = 0.5) -> CAKeyframeAnimation {
            let animation = CAKeyframeAnimation(keyPath: "opacity")
            animation.duration = animationDuration
            animation.values = [0.4,0.8,0]
            animation.keyTimes = [0,0.3,1]
            return animation
        }
        
        public static func createScalingAnimation(animationDuration: Double = 0.5) -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = 1.2
            animation.duration = animationDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.autoreverses = true
            animation.repeatCount = 1
            return animation
        }
        
        public static func createPulsingAnimation(pulseCount: Float = 1, animationDuration: Double = 0.5) -> CAAnimationGroup {
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.5
            animationGroup.repeatCount = pulseCount
            let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            animationGroup.timingFunction = defaultCurve
            animationGroup.animations = [Animator.createScalingAnimation(), Animator.createOpacityAnimation()]
            return animationGroup
        }
    }
    
    // MARK: add padding to each end of the items to enable user to scroll to all visible items
    fileprivate struct ItemManager {
        
        public var numberOfVisibleItems: Int
        private let numberOfItems: Int
        private let numberOfPaddingItemPerSide: Int = 2 // pad to allow item to be reacheable by scrolling
        
        public init(numberOfItems: Int, numberOfVisibleItems: Int) {
            self.numberOfItems = numberOfItems
            self.numberOfVisibleItems = numberOfVisibleItems
        }
        
        public var normalizedNumberOfItems: Int {
            get {
                return numberOfPaddingItemPerSide + numberOfItems + numberOfPaddingItemPerSide
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
}


