
import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    var configuration: PhotoPickerConfiguration!
    
    var photo: PhotoAsset! {
        didSet {
            
            PhotoPickerManager.shared.requestImage(
                asset: photo.asset,
                size: contentView.bounds.size,
                options: configuration.photoGridThumbnailRequestOptions
            ) { (image, info) in
                if let image = image {
                    self.imageView.image = image
                }
                else {
                    self.imageView.image = self.configuration.photoGridThumbnailErrorPlaceholder
                }
            }
            
        }
    }
    
    private lazy var imageView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        contentView.addSubview(view)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
            
        ])
        
        return view
        
    }()
    
}
