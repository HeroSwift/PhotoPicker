
import UIKit
import Photos

public class AlbumAsset {
    
    public var title: String? {
        get {
            return collection.localizedTitle
        }
    }
    
    public var count: Int {
        get {
            return collection.estimatedAssetCount
        }
    }

    public var collection: PHAssetCollection
    
    public var thumbnail: PhotoAsset?
    
    public init(collection: PHAssetCollection, thumbnail: PhotoAsset?) {
        self.collection = collection
        self.thumbnail = thumbnail
    }
    
}


