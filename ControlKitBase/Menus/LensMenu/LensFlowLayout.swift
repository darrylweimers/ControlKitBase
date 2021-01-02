import UIKit

let defaultItemScale: CGFloat = 0.7

public class LensFlowLayout: UICollectionViewFlowLayout {
  
    public override func prepare() {
        super.prepare()

        scrollDirection = .horizontal
        minimumLineSpacing = 8
        //minimumInteritemSpacing = 0
    }
  
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var attributesCopy: [UICollectionViewLayoutAttributes] = []

        for itemAttributes in attributes! {
          let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
          
          changeLayoutAttributes(itemAttributesCopy)
          
          attributesCopy.append(itemAttributesCopy)
        }

        return attributesCopy
    }
  
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
  
    private func changeLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) {

        let collectionCenter = collectionView!.frame.size.width / 2
        let offset = collectionView!.contentOffset.x
        let normalizedCenter = attributes.center.x - offset

        let maxDistance = itemSize.width + minimumLineSpacing
        let actualDistance = abs(collectionCenter - normalizedCenter)
        let scaleDistance = min(actualDistance, maxDistance)

        let ratio = (maxDistance - scaleDistance) / maxDistance
        let scale = defaultItemScale + ratio * (1 - defaultItemScale)

        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
}
