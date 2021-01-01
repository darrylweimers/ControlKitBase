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
    private let menuHeight: CGFloat = 80
    private var lensFiltersImages: [UIImage]
    
    public init(lensFiltersImages: [UIImage]) {
        self.lensFiltersImages = lensFiltersImages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews(superview: self.view)
    }
    
    private func setupViews(superview: UIView) {
        superview.addSubview(lensCollectionView)
        
        NSLayoutConstraint.activate([
            lensCollectionView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            lensCollectionView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
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

        let middleIndexPath = IndexPath(item: lensFiltersImages.count/2, section: 0)
        selectCell(for: middleIndexPath, animated: false)
    }

    private func selectCell(for indexPath: IndexPath, animated: Bool) {
        lensCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        delegate?.lensMenuView(self.lensCollectionView, didSelectAt: indexPath)
    }

    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lensFiltersImages.count
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(for: indexPath, animated: true)
    }
    

    // MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LensCircleCell.reuseIdentifier, for: indexPath) as? LensCircleCell else { fatalError() }

        cell.image = lensFiltersImages[indexPath.row]
        return cell
    }
    

    // MARK: UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = lensCollectionView.frame.height * 0.9
        return CGSize(width: side, height: side)
    }
    

    // MARK: UIScrollViewDelegate
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bounds = lensCollectionView.bounds

        let xPosition = lensCollectionView.contentOffset.x + bounds.size.width/2.0
        let yPosition = bounds.size.height/2.0
        let xyPoint = CGPoint(x: xPosition, y: yPosition)

        guard let indexPath = lensCollectionView.indexPathForItem(at: xyPoint) else { return }

        selectCell(for: indexPath, animated: true)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
          scrollViewDidEndDecelerating(scrollView)
        }
    }
}
