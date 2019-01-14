
import UIKit
import Photos

public class AlbumAsset {
    
    public static func build(collection: PHAssetCollection, photoList: [PhotoAsset]) -> AlbumAsset {
        
        return AlbumAsset(
            collection: collection,
            poster: photoList.count > 0 ? photoList[0] : nil,
            count: photoList.count
        )
        
    }
    
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


