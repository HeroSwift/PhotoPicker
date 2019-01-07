
import UIKit
import Photos

public class AlbumAsset {
    
    public var title: String? {
        get {
            return collection.localizedTitle
        }
    }

    public var collection: PHAssetCollection
    
    public var thumbnail: PhotoAsset?
    
    public var count: Int
    
    public init(collection: PHAssetCollection, thumbnail: PhotoAsset?, count: Int) {
        self.collection = collection
        self.thumbnail = thumbnail
        self.count = count
    }
    
}


