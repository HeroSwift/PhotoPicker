
import UIKit
import Photos

public class AlbumAsset {
    
    public static func build(collection: PHAssetCollection, fetchResult: PHFetchResult<PHAsset>) -> AlbumAsset {
        
        return AlbumAsset(
            collection: collection,
            poster: fetchResult.count > 0 ? PhotoAsset.build(asset: fetchResult[0]) : nil,
            count: fetchResult.count
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


