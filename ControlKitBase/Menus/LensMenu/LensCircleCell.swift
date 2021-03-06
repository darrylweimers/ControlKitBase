import UIKit

public class LensCircleCell: UICollectionViewCell {
  
    public static var reuseIdentifier = "\(LensCircleCell.self)"
    
    public lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    var image: UIImage? {
        didSet {
            guard let image = image else {
                return
            }
            button.setImage(image, for: .normal)
        }
    }
    
    var imageCornerRadius: CGFloat? {
        didSet{
            guard let imageCornerRadius = imageCornerRadius else {
                return
            }
            button.layer.cornerRadius = imageCornerRadius
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
        superview.addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            button.topAnchor.constraint(equalTo: superview.topAnchor),
            button.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
    
    public func hide() {
        self.contentView.isHidden = true
        self.button.isHidden = true
    }
}

