
import UIKit

public class TopBar: UIView {
    
    var onCancelClick: (() -> Void)?
    
    var title = "" {
        didSet {
            titleView.setTitle(title, for: .normal)
        }
    }
    
    private var configuration: PhotoPickerConfiguration!
    
    private lazy var cancelButton: UIButton = {
        
        let view = UIButton()
        
        view.titleLabel?.font = configuration.cancelButtonTitleTextFont
        
        view.contentEdgeInsets = UIEdgeInsets(
            top: configuration.cancelButtonPaddingVertical,
            left: configuration.cancelButtonPaddingHorizontal,
            bottom: configuration.cancelButtonPaddingVertical,
            right: configuration.cancelButtonPaddingHorizontal
        )
        
        view.setTitle(configuration.cancelButtonTitle, for: .normal)
        view.setTitleColor(configuration.cancelButtonTitleTextColor, for: .normal)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: configuration.cancelButtonMarginLeft),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -configuration.cancelButtonMarginBottom),
        ])
        
        return view
        
    }()
    
    private lazy var titleView: SimpleButton = {
        
        let view = SimpleButton()
        
        view.translatesAutoresizingMaskIntoConstraints = false

        addSubview(view)
        
        addConstraints([
            NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
        return view
        
    }()
    
    public override var intrinsicContentSize: CGSize {
        return frame.size
    }
    
    public convenience init(configuration: PhotoPickerConfiguration) {
        
        self.init()
        self.configuration = configuration
        
        backgroundColor = configuration.topBarBackgroundColor
        
        cancelButton.addTarget(self, action: #selector(onCancelButtonClick), for: .touchUpInside)
        
    }
    
    @objc private func onCancelButtonClick() {
        onCancelClick?()
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.width
        var height = configuration.topBarHeight
        
        if #available(iOS 11.0, *) {
            height += safeAreaInsets.top
        }
        
        let oldSize = frame.size
        if oldSize.width != width || oldSize.height != height {
            frame.size = CGSize(width: width, height: height)
            invalidateIntrinsicContentSize()
        }
        
    }
    
}
