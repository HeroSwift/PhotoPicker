
import UIKit

class AlbumCell: UITableViewCell {

    var configuration: PhotoPickerConfiguration!
    
    var album: AlbumAsset! {
        didSet {
            
            if let thumbnail = album.thumbnail {
                PhotoPickerManager.shared.requestImage(
                    asset: thumbnail.asset,
                    size: thumbnailView.bounds.size,
                    options: configuration.albumThumbnailRequestOptions
                ) { (image, info) in
                    if let image = image {
                        self.thumbnailView.image = image
                    }
                    else {
                        self.thumbnailView.image = self.configuration.albumThumbnailErrorPlaceholder
                    }
                }
            }
            else {
                thumbnailView.image = configuration.albumEmptyPlaceholder
            }
            
            titleView.text = album.title
            countView.text = "\(album.count)"
            
        }
    }
    
    private lazy var separatorView: UIView = {
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = configuration.albumSeparatorColor
        
        contentView.backgroundColor = .clear
        contentView.addSubview(view)
        
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.albumCellPaddingHorizontal),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -configuration.albumCellPaddingHorizontal),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.albumSeparatorThickness)
        ])
        
        return view
        
    }()
    
    private lazy var thumbnailView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        
        let bottomLayoutConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -configuration.albumCellPaddingVertical)
        
        bottomLayoutConstraint.priority = .defaultLow
        
        contentView.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: separatorView, attribute: .bottom, multiplier: 1, constant: configuration.albumCellPaddingVertical),
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: configuration.albumCellPaddingHorizontal),
            bottomLayoutConstraint,
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.albumThumbnailWidth),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.albumThumbnailHeight),
        ])
        
        return view
        
    }()
    
    private lazy var titleView: UILabel = {
        
        let view = UILabel()
        
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
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
    
}
