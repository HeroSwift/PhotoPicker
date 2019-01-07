import UIKit
import Photos

open class PhotoPickerConfiguration {

    //
    // MARK: - 相册列表
    //
    
    // 相册列表背景色
    public var albumListBackgroundColor = UIColor.white
    
    // 相册单元格的水平内间距
    public var albumCellPaddingHorizontal: CGFloat = 5
    
    // 相册单元格的垂直内间距
    public var albumCellPaddingVertical: CGFloat = 5
    
    // 相册缩略图的宽度
    public var albumThumbnailWidth: CGFloat = 50
    
    // 相册缩略图的高度
    public var albumThumbnailHeight: CGFloat = 50
    
    // 相册缩略图的加载选项
    public var albumThumbnailRequestOptions = PHImageRequestOptions()
    
    // 相册缩略图加载错误时的默认图
    public var albumThumbnailErrorPlaceholder = UIImage(named: "image")
    
    // 相册为空时的缩略图
    public var albumEmptyPlaceholder = UIImage(named: "image")
    
    // 相册标题字体
    public var albumTitleTextFont = UIFont.systemFont(ofSize: 16)
    
    // 相册标题颜色
    public var albumTitleTextColor = UIColor.black
    
    // 相册标题与缩略图的距离
    public var albumTitleMarginLeft: CGFloat = 10
    
    // 相册数量字体
    public var albumCountTextFont = UIFont.systemFont(ofSize: 14)
    
    // 相册数量颜色
    public var albumCountTextColor = UIColor.gray
    
    // 相册数量与标题的距离
    public var albumCountMarginLeft: CGFloat = 10
    
    // 相册分割线颜色
    public var albumSeparatorColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6)
    
    // 相册分割线粗细
    public var albumSeparatorThickness = 1 / UIScreen.main.scale
    
    // 获取相册列表的选项
    public var albumFetchOptions = PHFetchOptions()
    
    // 是否显示空相册
    public var showEmptyAlbum = true
    
    

    //
    // MARK: - 照片网格
    //
    
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
    
    // 列表缩略图的加载选项
    public var photoGridThumbnailRequestOptions = PHImageRequestOptions()
    
    // 列表缩略图加载错误时的默认图
    public var photoGridThumbnailErrorPlaceholder = UIImage(named: "image")
    
    // 获取照片列表的选项
    public var photoFetchOptions = PHFetchOptions()
    
    public init() {
        
        // 设置为 PHImageRequestOptionsResizeModeFast 请求的效率更高
        // 但返回的图像可能和目标大小不一样并且质量较低
        albumThumbnailRequestOptions.resizeMode = .exact
        albumThumbnailRequestOptions.deliveryMode = .highQualityFormat
        
        photoGridThumbnailRequestOptions.resizeMode = .exact
        photoGridThumbnailRequestOptions.deliveryMode = .opportunistic
        
//        albumFetchOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        
        photoFetchOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        photoFetchOptions.predicate = NSPredicate(format: "mediaType IN %@", [PHAssetMediaType.image.rawValue])
        
    }
    
}
