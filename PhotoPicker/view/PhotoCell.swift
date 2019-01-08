
import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    var configuration: PhotoPickerConfiguration!
    
    var photo: PhotoAsset! {
        didSet {

            imageRequestID = PhotoPickerManager.shared.requestImage(
                asset: photo.asset,
                size: contentView.bounds.size,
                options: configuration.photoThumbnailRequestOptions
            ) { [weak self] image, _ in
                self?.thumbnail = image
            }
            
            var badgeImage: UIImage? = nil
            
            if photo.type == .gif {
                badgeImage = configuration.photoBadgeGifIcon
            }
            else if photo.type == .live {
                badgeImage = configuration.photoBadgeLiveIcon
            }
            else if photo.type == .webp {
                badgeImage = configuration.photoBadgeWebpIcon
            }
            
            if let image = badgeImage {
                badgeView.image = image
                badgeView.isHidden = false
            }
            
        }
    }
    
    private var imageRequestID: PHImageRequestID?
    
    private var thumbnail: UIImage? {
        didSet {
            imageRequestID = nil
            
            if let thumbnail = thumbnail {
                thumbnailView.image = thumbnail
            }
            else {
                thumbnailView.image = configuration.photoThumbnailErrorPlaceholder
            }
        }
    }
    
    private lazy var thumbnailView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        view.image = configuration.photoThumbnailLoadingPlaceholder
        
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
        
        view.isHidden = true

        contentView.addSubview(view)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.photoBadgeMarginBottom),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.photoBadgeMarginRight),
            
        ])
        
        return view
        
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let requestID = imageRequestID {
            PhotoPickerManager.shared.cancelImageRequest(requestID)
            imageRequestID = nil
        }
        thumbnail = configuration.photoThumbnailLoadingPlaceholder
        badgeView.isHidden = true
    }
    
}
