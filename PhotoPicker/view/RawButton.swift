

import UIKit

class RawButton: UIButton {

    var titleMarginLeft: CGFloat = 0 {
        didSet {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: titleMarginLeft, bottom: 0, right: 0)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + titleMarginLeft, height: size.height)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }
    
}

