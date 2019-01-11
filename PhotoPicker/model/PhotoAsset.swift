
import UIKit
import Photos

public class PhotoAsset {
    
    public static func build(asset: PHAsset) -> PhotoAsset {
        
        var type = AssetType.image
        
        if asset.mediaType == .image {
            let filename = asset.value(forKey: "filename") as! String
            // 读取出来的扩展名是大写的
            if filename.hasSuffix("GIF") {
                type = .gif
            }
            else if filename.hasSuffix("WEBP") {
                type = .webp
            }
            else if #available(iOS 9.1, *) {
                if asset.mediaSubtypes.contains(.photoLive) {
                    type = .live
                }
            }
        }
        else if asset.mediaType == .video {
            type = .video
        }
        else if asset.mediaType == .audio {
            type = .audio
        }
        
        return PhotoAsset(asset: asset, type: type)
        
    }
    
    public var asset: PHAsset
    
    public var type: AssetType
    
    // 请求过的缩略图，避免多次请求
    public var thumbnail: UIImage?
    
    // 在网格中的顺序
    public var index = -1
    
    // 选中的顺序，大于 0 表示已选中
    public var order = -1
    
    // 是否可选
    public var selectable = true
    
    public init(asset: PHAsset, type: AssetType) {
        self.asset = asset
        self.type = type
    }

}
