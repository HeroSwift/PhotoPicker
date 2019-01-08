
import UIKit
import Photos

public class PhotoAsset {
    
    public var asset: PHAsset
    
    // 先给个默认值
    public var type = AssetType.image
    
    public init(asset: PHAsset) {
        
        self.asset = asset
        
        if asset.mediaType == .image {

            if #available(iOS 9.1, *) {
                if asset.mediaSubtypes.contains(.photoLive) {
                    type = .live
                }
            }
            
            let filename = asset.value(forKey: "filename") as! String
            if filename.hasSuffix("GIF") {
                type = .gif
            }
            else if filename.hasSuffix("WEBP") {
                type = .webp
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
