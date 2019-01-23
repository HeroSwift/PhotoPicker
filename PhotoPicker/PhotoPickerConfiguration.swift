import UIKit
import Photos

open class PhotoPickerConfiguration {

    //
    // MARK: - 相册列表
    //
    
    // 相册单元格默认时的背景色
    public var albumBackgroundColorNormal = UIColor.white
    
    // 相册单元格按下时的背景色
    public var albumBackgroundColorPressed = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.1)
    
    // 相册单元格的水平内间距
    public var albumPaddingHorizontal: CGFloat = 12
    
    // 相册单元格的垂直内间距
    public var albumPaddingVertical: CGFloat = 6
    
    // 相册封面图的宽度
    public var albumPosterWidth: CGFloat = 50
    
    // 相册封面图的高度
    public var albumPosterHeight: CGFloat = 50
    
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
    public var photoGridBackgroundColor = UIColor.white
    
    // 一行的照片数量
    public var photoGridSpanCount: CGFloat = 3
    
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
    
    // 选择按钮的图片到顶部的距离
    public var selectButtonImageMarginTop: CGFloat = 5
    
    // 选择按钮的图片到右边的距离
    public var selectButtonImageMarginRight: CGFloat = 5
    
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
    public var photoOverlayColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
    
    
    //
    // MARK: - 顶部栏
    //
    
    // 顶部栏高度
    public var topBarHeight: CGFloat = 44
    
    // 顶部栏水平内间距
    public var topBarPaddingHorizontal: CGFloat = 0
    
    // 顶部栏背景色
    public var topBarBackgroundColor = UIColor.white
    
    // 顶部栏边框颜色
    public var topBarBorderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    
    // 顶部栏边框大小
    public var topBarBorderWidth = 1 / UIScreen.main.scale
    
    
    //
    // MARK: - 底部栏
    //
    
    // 底部栏高度
    public var bottomBarHeight: CGFloat = 44
    
    // 底部栏水平内间距
    public var bottomBarPaddingHorizontal: CGFloat = 14
    
    // 底部栏背景色
    public var bottomBarBackgroundColor = UIColor(red: 0.15, green: 0.17, blue: 0.20, alpha: 1)
    
    //
    // MARK: - 取消按钮
    //
    
    // 取消按钮的标题字体
    public var cancelButtonTitleTextFont = UIFont.systemFont(ofSize: 16)
    
    // 取消按钮的标题颜色
    public var cancelButtonTitleTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    
    // 取消按钮宽度
    public var cancelButtonWidth: CGFloat = 60
    
    // 取消按钮高度
    public var cancelButtonHeight: CGFloat = 34
    
    // 取消按钮的标题
    public var cancelButtonTitle = "取消"
    
    
    //
    // MARK: - 标题按钮
    //
    
    // 标题按钮的标题字体
    public var titleButtonTitleTextFont = UIFont.systemFont(ofSize: 18)
    
    // 标题按钮的标题颜色
    public var titleButtonTitleTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    
    // 标题按钮的图标和文字的距离
    public var titleButtonTitleMarginRight: CGFloat = 5
    
    // 标题按钮水平内间距，用来扩大点击区域
    public var titleButtonPaddingHorizontal: CGFloat = 8
    
    // 标题按钮垂直内间距，用来扩大点击区域
    public var titleButtonPaddingVertical: CGFloat = 8
    
    // 箭头图标
    public var titleButtonArrow = UIImage(named: "photo_picker_arrow")
    
    //
    // MARK: - 原图按钮
    //
    
    // 原图按钮的标题字体
    public var fullButtonTitleTextFont = UIFont.systemFont(ofSize: 13)
    
    // 原图按钮的标题颜色
    public var fullButtonTitleTextColor = UIColor.white
    
    // 原图按钮的标题到图标的距离
    public var fullButtonTitleMarginLeft: CGFloat = 6
    
    // 原图按钮水平内间距，用来扩大点击区域
    public var fullButtonPaddingHorizontal: CGFloat = 8
    
    // 原图按钮垂直内间距，用来扩大点击区域
    public var fullButtonPaddingVertical: CGFloat = 8
    
    // 原图按钮未选中时的图片
    public var fullButtonImageUnchecked = UIImage(named: "photo_picker_full_button_unchecked")
    
    // 原图按钮选中时的图片
    public var fullButtonImageChecked = UIImage(named: "photo_picker_full_button_checked")
    
    // 原图按钮的标题
    public var fullButtonTitle = "原图"
    
    //
    // MARK: - 确定按钮
    //
    
    // 确定按钮的标题字体
    public var submitButtonTitleTextFont = UIFont.systemFont(ofSize: 12)
    
    // 确定按钮的标题颜色
    public var submitButtonTitleTextColor = UIColor.white
    
    // 确定按钮的背景色
    public var submitButtonBackgroundColorNormal = UIColor(red: 1, green: 0.53, blue: 0.02, alpha: 1)
    
    // 确定按钮的背景色
    public var submitButtonBackgroundColorPressed = UIColor(red: 1, green: 0.38, blue: 0.04, alpha: 1)
    
    // 确定按钮的圆角
    public var submitButtonBorderRadius: CGFloat = 4
    
    // 确定按钮宽度
    public var submitButtonWidth: CGFloat = 58
    
    // 确定按钮高度
    public var submitButtonHeight: CGFloat = 28
    
    // 确定按钮的标题
    public var submitButtonTitle = "确定"
    
    //
    // MARK: - 各种可选配置
    //
    
    // 是否支持计数
    public var countable = true

    // 最大支持的多选数量
    public var maxSelectCount = 9
    
    //
    // MARK: - 各种选项
    //
    
    // 相册封面图的加载选项
    public lazy var albumPosterRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        return options
    }()
    
    // 列表缩略图的加载选项
    public var photoThumbnailRequestOptions: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        return options
    }()
    
    // 获取照片列表的选项
    public var photoSortField = "creationDate"
    public var photoSortAscending = false
    public var photoMediaTypes = [ PHAssetMediaType.image.rawValue ]
    
    //
    // MARK: - 各种占位图
    //
    
    // 相册封面图等待加载时的默认图
    public var albumPosterLoadingPlaceholder = UIImage(named: "photo_picker_album_poster_loading_placeholder")
    
    // 相册封面图加载错误时的默认图
    public var albumPosterErrorPlaceholder = UIImage(named: "photo_picker_album_poster_error_placeholder")
    
    // 相册为空时的缩略图
    public var albumEmptyPlaceholder = UIImage(named: "photo_picker_album_empty_placeholder")
    
    // 照片缩略图等待加载时的默认图
    public var photoThumbnailLoadingPlaceholder = UIImage(named: "photo_picker_photo_thumbnail_loading_placeholder")
    
    // 照片缩略图加载错误时的默认图
    public var photoThumbnailErrorPlaceholder = UIImage(named: "photo_picker_photo_thumbnail_error_placeholder")
    
    //
    // MARK: - 照片角标
    //
    
    // 角标到右边的距离
    public var photoBadgeMarginRight: CGFloat = 5
    
    // 角标到下边的距离
    public var photoBadgeMarginBottom: CGFloat = 5
    
    public var photoBadgeGifIcon = UIImage(named: "photo_picker_badge_gif")
    public var photoBadgeLiveIcon = UIImage(named: "photo_picker_badge_live")
    public var photoBadgeWebpIcon = UIImage(named: "photo_picker_badge_webp")
    
    public init() {
        
    }
    
    open func filterAlbum(title: String, count: Int) -> Bool {
        return count > 0
    }
    
    open func filterPhoto(width: Int, height: Int, type: AssetType) -> Bool {
        return width > 44 && height > 44
    }
    
}
