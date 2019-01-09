
import UIKit
import Photos

class AlbumCell: UITableViewCell {

    var configuration: PhotoPickerConfiguration!

    var thumbnailSize: CGSize!
    
    var album: AlbumAsset! {
        didSet {
            
            if let poster = album.poster {
                
                let asset = poster.asset
                posterIdentifier = asset.localIdentifier
                
                if poster.thumbnail == nil {
                    imageRequestID = PhotoPickerManager.shared.requestImage(
                        asset: asset,
                        size: thumbnailSize,
                        options: configuration.albumThumbnailRequestOptions
                    ) { [weak self] image, info in
                        
                        guard let _self = self, _self.posterIdentifier == asset.localIdentifier else {
                            return
                        }
                        
                        // 此回调会连续触发，这里只缓存高清图
                        if let degraded = info?[PHImageResultIsDegradedKey] as? NSNumber, degraded == 0 {
                            _self.album.poster?.thumbnail = image
                        }
                        
                        _self.imageRequestID = nil
                        _self.thumbnail = image
                        
                    }
                }
                else {
                    thumbnailView.image = poster.thumbnail
                }
            }
            else {
                thumbnailView.image = configuration.albumEmptyPlaceholder
            }
            
            titleView.text = album.title
            countView.text = "\(album.count)"
            
        }
    }
    
    var index = -1 {
        didSet {
            if index == 0 {
                if oldValue > 0 {
                    separatorHeightLayoutConstraint.constant = 0
                    setNeedsLayout()
                }
            }
            else {
                if oldValue <= 0 {
                    separatorHeightLayoutConstraint.constant = configuration.albumSeparatorThickness
                    setNeedsLayout()
                }
            }
        }
    }
    
    private var posterIdentifier: String!
    private var imageRequestID: PHImageRequestID?
    
    private var separatorHeightLayoutConstraint: NSLayoutConstraint!
    
    private lazy var separatorView: UIView = {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = configuration.albumSeparatorColor
        
        // 只能随便找个地方写这句了...
        selectionStyle = .none
        indicatorView.image = configuration.albumIndicatorIcon
        
        contentView.addSubview(view)
        
        separatorHeightLayoutConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.albumCellPaddingHorizontal),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.albumCellPaddingHorizontal),
            separatorHeightLayoutConstraint
        ])
        
        return view
        
    }()
    
    private var thumbnail: UIImage? {
        didSet {
            if let thumbnail = thumbnail {
                thumbnailView.image = thumbnail
            }
            else {
                thumbnailView.image = configuration.albumThumbnailErrorPlaceholder
            }
        }
    }

    private lazy var thumbnailView: UIImageView = {
        
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        
        let bottomLayoutConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.albumCellPaddingVertical)
        
        bottomLayoutConstraint.priority = .defaultLow
        
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: separatorView, attribute: .bottom, multiplier: 1, constant: configuration.albumCellPaddingVertical),
            bottomLayoutConstraint,
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.albumCellPaddingHorizontal),
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.albumThumbnailWidth),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.albumThumbnailHeight),
        ])
        
        return view
        
    }()
    
    private lazy var titleView: UILabel = {
        
        let view = UILabel()
        
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.preferredMaxLayoutWidth = UIScreen.main.bounds.width / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.font = configuration.albumTitleTextFont
        view.textColor = configuration.albumTitleTextColor
        view.textAlignment = .left
        
        contentView.addSubview(view)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: thumbnailView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: thumbnailView, attribute: .right, multiplier: 1, constant: configuration.albumTitleMarginLeft),
        ])
        
        return view
        
    }()
    
    private lazy var countView: UILabel = {
        
        let view = UILabel()
        
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.font = configuration.albumCountTextFont
        view.textColor = configuration.albumCountTextColor
        view.textAlignment = .left
        
        contentView.addSubview(view)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: titleView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: titleView, attribute: .right, multiplier: 1, constant: configuration.albumCountMarginLeft),
        ])
        
        return view
        
    }()
    
    private lazy var indicatorView: UIImageView = {
    
        let view = UIImageView()
    
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.albumCellPaddingHorizontal),
        ])
        
        return view
    
    }()
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            backgroundColor = configuration.albumCellBackgroundColorPressed
        }
        else {
            backgroundColor = .clear
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let requestID = imageRequestID {
            PhotoPickerManager.shared.cancelImageRequest(requestID)
            imageRequestID = nil
        }
    }
    
}
