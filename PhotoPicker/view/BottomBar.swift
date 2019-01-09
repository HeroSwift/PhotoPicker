
import UIKit

public class BottomBar: UIView {
    
    public var isRawChecked = false {
        didSet {

            if isRawChecked {
                rawButton.image = configuration.rawButtonImageChecked
            }
            else {
                rawButton.image = configuration.rawButtonImageUnchecked
            }
            
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

        if configuration.submitButtonBorderRadius > 0 {
            view.layer.cornerRadius = configuration.submitButtonBorderRadius
            view.clipsToBounds = true
        }
        
        view.setTitleColor(configuration.submitButtonTitleTextColor, for: .normal)
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: configuration.submitButtonMarginTop),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -configuration.submitButtonMarginRight),
            NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: configuration.submitButtonWidth),
            NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: configuration.submitButtonHeight),
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
        
        rawButton.addTarget(self, action: #selector(onRawClick), for: .touchUpInside)
        
    }
    
    @objc private func onRawClick() {
        isRawChecked = !isRawChecked
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.width
        var height = configuration.bottomBarHeight
        print(width)
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
