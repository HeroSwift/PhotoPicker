import UIKit
import Photos

open class PhotoPickerConfiguration {

    // 照片网格的背景色
    public var photoGridBackgroundColor = UIColor.clear
    
    // 一行的照片数量
    public var numberOfPhotoPerLine: CGFloat = 4
    
    // 网格的水平内间距
    public var photoGridPaddingHorizontal: CGFloat = 5
    
    // 网格的垂直内间距
    public var photoGridPaddingVertical: CGFloat = 5
    
    // 网格行间距
    public var photoGridRowSpacing: CGFloat = 5
    
    // 网格列间距
    public var photoGridColumnSpacing: CGFloat = 5
    
    // 列表图片的加载选项
    public var photoGridImageRequestOptions = PHImageRequestOptions()
    
    public init() {
        photoGridImageRequestOptions.resizeMode = .fast
        photoGridImageRequestOptions.deliveryMode = .opportunistic
    }
    
}
