import UIKit
import Photos

open class PhotoPickerConfiguration {

    //
    // MARK: - 相册列表
    //
    
    // 相册单元格默认时的背景色
    public var albumCellBackgroundColorNormal = UIColor.white
    
    // 相册单元格按下时的背景色
    public var albumCellBackgroundColorPressed = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.1)
    
    // 相册单元格的水平内间距
    public var albumCellPaddingHorizontal: CGFloat = 8
    
    // 相册单元格的垂直内间距
    public var albumCellPaddingVertical: CGFloat = 6
    
    // 相册缩略图的宽度
    public var albumThumbnailWidth: CGFloat = 50
    
    // 相册缩略图的高度
    public var albumThumbnailHeight: CGFloat = 50
    
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
    
    // 相册向右箭头
    public var albumIndicatorIcon = UIImage(named: "photo_picker_album_indicator")
    
    //
    // MARK: - 照片网格
    //
    
    // 照片网格的背景色
    public var photoGridBackgroundColor = UIColor.clear
    
    // 一行的照片数量
    public var numberOfPhotoPerLine: CGFloat = 3
    
    // 网格的水平内间距
    public var photoGridPaddingHorizontal: CGFloat = 2
    
    // 网格的垂直内间距
    public var photoGridPaddingVertical: CGFloat = 2
    
    // 网格行间距
    public var photoGridRowSpacing: CGFloat = 2
    
    // 网格列间距
    public var photoGridColumnSpacing: CGFloat = 2

    
    //
    // MARK: - 计数器
    //
    
    // 选择按钮宽度
    public var selectButtonWidth: CGFloat = 44
    
    // 选择按钮高度
    public var selectButtonHeight: CGFloat = 44
    
    // 选择按钮到顶部的距离
    public var selectButtonMarginTop: CGFloat = 0
    
    // 选择按钮到右边的距离
    public var selectButtonMarginRight: CGFloat = 0
    
    // 选择按钮的标题字体
    public var selectButtonTitleTextFont = UIFont.systemFont(ofSize: 14)
    
    // 选择按钮的标题颜色
    public var selectButtonTitleTextColor = UIColor.white
    
    // 未选中时的图片
    public var selectButtonImageUnchecked = UIImage(named: "photo_picker_select_button_unchecked")
    
    // 选中且不需要计数时的图片
    public var selectButtonImageChecked = UIImage(named: "photo_picker_select_button_checked")
    
    // 选中且需要计数时的图片
    public var selectButtonImageCheckedCountable = UIImage(named: "photo_picker_select_button_checked_countable")
    
    // 当选择的照片数量到达上线后的蒙层颜色
    public var photoThumbnailOverlayColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    
    //
    // MARK: - 各种可选配置
    //
    
    // 是否显示空相册
    public var showEmptyAlbum = false
    
    // 是否可以多选
    public var selectable = true
    
    // 是否支持计数
    public var countable = false

    // 最大支持的多选数量
    public var maxSelectCount = 9
    
    //
    // MARK: - 各种选项
    //
    
    // 相册缩略图的加载选项
    public var albumThumbnailRequestOptions = PHImageRequestOptions()
    
    // 列表缩略图的加载选项
    public var photoThumbnailRequestOptions = PHImageRequestOptions()
    
    // 获取照片列表的选项
    public var photoFetchOptions = PHFetchOptions()
    
    //
    // MARK: - 各种占位图
    //
    
    // 相册缩略图加载错误时的默认图
    public var albumThumbnailErrorPlaceholder = UIImage(named: "image")
    
    // 相册为空时的缩略图
    public var albumEmptyPlaceholder = UIImage(named: "image")
    
    // 照片缩略图等待加载时的默认图
    public var photoThumbnailLoadingPlaceholder = UIImage(named: "image")
    
    // 照片缩略图加载错误时的默认图
    public var photoThumbnailErrorPlaceholder = UIImage(named: "image")
    
    //
    // MARK: - 照片角标
    //
    
    // 角标到右边的距离
    public var photoBadgeMarginRight: CGFloat = 2
    
    // 角标到下边的距离
    public var photoBadgeMarginBottom: CGFloat = 2
    
    public var photoBadgeGifIcon = UIImage(named: "photo_picker_badge_gif")
    public var photoBadgeLiveIcon = UIImage(named: "photo_picker_badge_live")
    public var photoBadgeWebpIcon = UIImage(named: "photo_picker_badge_webp")
    
    public init() {
        
        albumThumbnailRequestOptions.resizeMode = .exact
        
        photoThumbnailRequestOptions.resizeMode = .exact

        photoFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photoFetchOptions.predicate = NSPredicate(format: "mediaType IN %@", [PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue])
        
    }
    
}
