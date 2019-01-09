
import UIKit

public class BottomBar: UIView {
    
    public var isRawChecked = false {
        didSet {
            
            let image: UIImage?
            
            if isRawChecked {
                image = configuration.rawButtonImageChecked
            }
            else {
                image = configuration.rawButtonImageUnchecked
            }
            
            rawButton.setImage(image, for: .normal)
            rawButton.setImage(image, for: .highlighted)
        }
    }
    
    public var count = -1 {
        didSet {
            guard count != oldValue else {
                return
            }
            if count > 0 {
                submitButton.isEnabled = true
                submitButton.alpha = 1
                submitButton.setTitle("\(configuration.submitButtonTitle)(\(count))", for: .normal)
            }
            else {
                submitButton.isEnabled = false
                submitButton.alpha = 0.5
                submitButton.setTitle(configuration.submitButtonTitle, for: .normal)
            }
        }
    }
    
    private var configuration: PhotoPickerConfiguration!
    
    private lazy var rawButton: RawButton = {
       
        let view = RawButton()
        
        view.titleMarginLeft = configuration.rawButtonTitleMarginLeft
        
        view.setTitle(configuration.rawButtonTitle, for: .normal)
        
        view.titleLabel?.font = configuration.rawButtonTitleTextFont
        view.titleLabel?.textColor = configuration.rawButtonTitleTextColor

        view.contentHorizontalAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
        return view
        
    }()
    
    private lazy var submitButton: SimpleButton = {
    
        let view = SimpleButton()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = configuration.submitButtonBackgroundColorNormal
        view.backgroundColorPressed = configuration.submitButtonBackgroundColorPressed
        
        view.titleLabel?.font = configuration.submitButtonTitleTextFont
        
        view.contentEdgeInsets = UIEdgeInsets(
            top: 0,
            left: configuration.submitButtonPaddingHorizontal,
            bottom: 0,
            right: configuration.submitButtonPaddingHorizontal
        )

        if configuration.submitButtonBorderRadius > 0 {
            view.layer.cornerRadius = configuration.submitButtonBorderRadius
            view.clipsToBounds = true
        }
        
        view.setTitleColor(configuration.submitButtonTitleTextColor, for: .normal)
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -configuration.submitButtonMarginRight),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.submitButtonHeight)
        ])
        
        return view
        
    }()
    
    public convenience init(configuration: PhotoPickerConfiguration) {
        
        self.init()
        self.configuration = configuration

        backgroundColor = configuration.bottomBarBackgroundColor
        
        rawButton.addTarget(self, action: #selector(onRawButtonClick), for: .touchUpInside)
        
    }
    
    @objc private func onRawButtonClick() {
        isRawChecked = !isRawChecked
    }
    
}
