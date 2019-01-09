

import UIKit

class RawButton: UIButton {

    private var configuration: PhotoPickerConfiguration!
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + configuration.rawButtonTitleMarginLeft,
            height: size.height
        )
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }
    
    convenience init(configuration: PhotoPickerConfiguration) {
        
        self.init()
        self.configuration = configuration
        
        setTitle(configuration.rawButtonTitle, for: .normal)

        titleLabel?.font = configuration.rawButtonTitleTextFont
        titleLabel?.textColor = configuration.rawButtonTitleTextColor
        
        contentHorizontalAlignment = .left
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: configuration.rawButtonTitleMarginLeft, bottom: 0, right: 0)

        contentEdgeInsets = UIEdgeInsets(
            top: configuration.rawButtonPaddingVertical,
            left: configuration.rawButtonPaddingHorizontal,
            bottom: configuration.rawButtonPaddingVertical,
            right: configuration.rawButtonPaddingHorizontal
        )
        
    }
    
}

