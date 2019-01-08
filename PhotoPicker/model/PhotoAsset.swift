
import UIKit
import Photos

public class PhotoAsset {
    
    public var asset: PHAsset
    
    // 在网格中的顺序
    public var index = -1
    
    // 选中的顺序，大于 0 表示已选中
    public var checkedIndex = -1
    
    // 先给个默认值
    public var type = AssetType.image
    
    public init(asset: PHAsset) {
        
        self.asset = asset
        
        if asset.mediaType == .image {
            let filename = asset.value(forKey: "filename") as! String
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
        
    }
    
    public enum AssetType {
        case video, audio, image, gif, live, webp;
    }
    
}
