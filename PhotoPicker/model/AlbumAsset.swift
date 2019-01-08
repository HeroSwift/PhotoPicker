
import UIKit
import Photos

public class AlbumAsset {
    
    public var title: String? {
        get {
            return collection.localizedTitle
        }
    }

    public var collection: PHAssetCollection
    
    public var poster: PhotoAsset?
    
    public var count: Int
    
    public init(collection: PHAssetCollection, poster: PhotoAsset?, count: Int) {
        self.collection = collection
        self.poster = poster
        self.count = count
    }
    
}


