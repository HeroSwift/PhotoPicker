
import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    var configuration: PhotoPickerConfiguration!
    
    var photo: PhotoAsset! {
        didSet {

            PhotoPickerManager.shared.requestImage(
                asset: photo.asset,
                size: contentView.bounds.size,
                options: configuration.photoThumbnailRequestOptions
            ) { (image, info) in
                if let image = image {
                    self.imageView.image = image
                }
                else {
                    self.imageView.image = self.configuration.photoThumbnailErrorPlaceholder
                }
            }
            
            if photo.type == .gif {
                badgeView.image = configuration.photoBadgeGifIcon
            }
            else if photo.type == .live {
                badgeView.image = configuration.photoBadgeLiveIcon
            }
            else if photo.type == .webp {
                badgeView.image = configuration.photoBadgeWebpIcon
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
    
    // 角标，如 live photo/GIF
    private lazy var badgeView: UIImageView = {
       
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.contentMode = .center

        contentView.addSubview(view)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.photoBadgeMarginBottom),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.photoBadgeMarginRight),
            
        ])
        
        return view
        
    }()
    
}
