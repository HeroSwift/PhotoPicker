
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
       
        let view = RawButton(configuration: configuration)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: submitButton, attribute: .centerY, multiplier: 1, constant: 0),
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
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: configuration.submitButtonMarginTop),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -configuration.submitButtonMarginRight),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.submitButtonHeight)
        ])
        
        return view
        
    }()
    
    public override var intrinsicContentSize: CGSize {
        return frame.size
    }
    
    public convenience init(configuration: PhotoPickerConfiguration) {
        
        self.init()
        self.configuration = configuration

        backgroundColor = configuration.bottomBarBackgroundColor
        
        rawButton.addTarget(self, action: #selector(onRawButtonClick), for: .touchUpInside)
        
    }
    
    @objc private func onRawButtonClick() {
        isRawChecked = !isRawChecked
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.width
        var height = configuration.bottomBarHeight
        
        if #available(iOS 11.0, *) {
            height += safeAreaInsets.bottom
        }
        
        let oldSize = frame.size
        if oldSize.width != width || oldSize.height != height {
            frame.size = CGSize(width: width, height: height)
            invalidateIntrinsicContentSize()
        }
        
    }
    
}
