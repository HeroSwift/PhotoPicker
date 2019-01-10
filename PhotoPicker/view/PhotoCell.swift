
import UIKit
import Photos

class PhotoCell: UICollectionViewCell {
    
    var onToggleChecked: (() -> Void)?
    
    var configuration: PhotoPickerConfiguration! {
        didSet {
            guard configuration !== oldValue else {
                return
            }
            selectButton.isHidden = !configuration.selectable
        }
    }
    
    var size: CGSize!
    
    var photo: PhotoAsset! {
        didSet {
            
            let asset = photo.asset
            
            assetIdentifier = asset.localIdentifier
            
            if photo.thumbnail == nil {
                imageRequestID = PhotoPickerManager.shared.requestImage(
                    asset: asset,
                    size: size,
                    options: configuration.photoThumbnailRequestOptions
                ) { [weak self] image, info in
                    
                    guard let _self = self, _self.assetIdentifier == asset.localIdentifier else {
                        return
                    }
                    
                    // 此回调会连续触发，这里只缓存高清图
                    if let degraded = info?[PHImageResultIsDegradedKey] as? NSNumber, degraded == 0 {
                        _self.photo.thumbnail = image
                    }
                    
                    _self.imageRequestID = nil
                    _self.thumbnail = image
                    
                }
            }
            else {
                thumbnailView.image = photo.thumbnail
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
            
            if configuration.selectable {
                checked = photo.order >= 0
                selectable = photo.selectable
            }
        }
    }
    
    private var assetIdentifier: String!
    private var imageRequestID: PHImageRequestID?
    
    private var checked = false {
        didSet {
            
            selectButton.checked = checked
            
            selectButton.count = configuration.countable && photo.order >= 0 ? photo.order + 1 : -1
            
        }
    }
    
    private var selectable = true {
        didSet {
            
            overlayView.isHidden = selectable
            
        }
    }
    
    private var thumbnail: UIImage? {
        didSet {
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
        
        contentView.insertSubview(view, at: 0)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
            
        ])
        
        return view
        
    }()
    
    private lazy var selectButton: SelectButton = {
        
        let view = SelectButton(configuration: configuration)

        view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(view)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.selectButtonWidth),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.selectButtonHeight),
            
        ])
        
        view.addTarget(self, action: #selector(onToggleCheckedClick), for: .touchUpInside)
        
        return view
        
    }()
    
    // 角标，如 live、gif、webp
    private lazy var badgeView: UIImageView = {
       
        let view = UIImageView()
        
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.photoBadgeMarginBottom),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.photoBadgeMarginRight),
            
        ])
        
        return view
        
    }()
    
    // 当选择数量到达上限后显示的蒙板
    private lazy var overlayView: UIView = {
       
        let view = UIView()

        view.isHidden = true
        view.backgroundColor = configuration.photoThumbnailOverlayColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        
        contentView.addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0),
            
        ])
        
        return view
        
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()

        if let requestID = imageRequestID {
            PhotoPickerManager.shared.cancelImageRequest(requestID)
            imageRequestID = nil
        }
        if configuration.selectable {
            checked = false
        }

        thumbnail = configuration.photoThumbnailLoadingPlaceholder
        badgeView.isHidden = true

    }
    
    @objc private func onToggleCheckedClick() {
        onToggleChecked?()
    }
    
}
