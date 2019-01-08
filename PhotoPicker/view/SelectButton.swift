
import UIKit

class SelectButton: UIView {
    
    var onClick: (() -> Void)?
    
    var checked = false {
        didSet {
            
            if checked {
                if configuration.countable {
                    image = configuration.selectButtonImageCheckedCountable
                }
                else {
                    image = configuration.selectButtonImageChecked
                }
            }
            else {
                image = configuration.selectButtonImageUnchecked
            }
            
        }
    }
    
    var count = 0 {
        didSet {
            
            if count > 0 {
                if oldValue <= 0 {
                    countView.isHidden = false
                }
                countView.text = "\(count)"
                countView.sizeToFit()
            }
            else {
                if oldValue > 0 {
                    countView.isHidden = true
                }
            }
            
        }
    }
    
    private var configuration: PhotoPickerConfiguration!
    
    private var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private lazy var imageView: UIImageView = {
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        insertSubview(view, at: 0)
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        return view
        
    }()
    
    private lazy var countView: UILabel = {
       
        let view = UILabel()
        
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        return view
        
    }()
    
    convenience init(configuration: PhotoPickerConfiguration) {
        
        self.init()
        self.configuration = configuration
        
        image = configuration.selectButtonImageUnchecked
        countView.font = configuration.selectButtonTitleTextFont
        countView.textColor = configuration.selectButtonTitleTextColor
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let event = event {
            onClick?()
        }
    }
    
}
