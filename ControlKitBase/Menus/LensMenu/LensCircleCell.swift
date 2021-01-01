import UIKit

public class LensCircleCell: UICollectionViewCell {
  
    public static var reuseIdentifier = "\(LensCircleCell.self)"
    
    private lazy var blackBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        
        return imageView
    }()

    var image: UIImage? {
        didSet {
        guard let image = image else { return }
        imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews(superview: self.contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(superview: UIView) {
    
        superview.addSubview(blackBorderView)

        blackBorderView.addSubview(imageView)
        NSLayoutConstraint.activate([
            blackBorderView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            blackBorderView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            blackBorderView.topAnchor.constraint(equalTo: superview.topAnchor),
            blackBorderView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    
        blackBorderView.layer.cornerRadius = 36
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: blackBorderView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: blackBorderView.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: blackBorderView.widthAnchor, multiplier: 0.98),
            imageView.heightAnchor.constraint(equalTo: blackBorderView.heightAnchor, multiplier: 0.98),
        ])
    }
}

