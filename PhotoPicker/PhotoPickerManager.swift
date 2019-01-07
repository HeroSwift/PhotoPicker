
import Foundation
import Photos

// https://www.jianshu.com/p/6f051fe88717
// http://kayosite.com/ios-development-and-detail-of-photo-framework-part-two.html
// http://blog.imwcl.com/2017/01/11/iOS%E5%BC%80%E5%8F%91%E8%BF%9B%E9%98%B6-Photos%E8%AF%A6%E8%A7%A3%E5%9F%BA%E4%BA%8EPhotos%E7%9A%84%E5%9B%BE%E7%89%87%E9%80%89%E6%8B%A9%E5%99%A8/
public class PhotoPickerManager {
    
    public static let shared: PhotoPickerManager = PhotoPickerManager()
    
    private let imageManager = PHImageManager()
    
    // 获取所有照片
    public func fetchPhotoList(album: PHAssetCollection?) -> [PhotoAsset] {
        
        let options = PHFetchOptions()
        
        // 创建时间排序
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        
        // 检索什么格式
        options.predicate = NSPredicate.init(format: "mediaType IN %@", [PHAssetMediaType.image.rawValue])
        
        let result: PHFetchResult<PHAsset>
        
        if let album = album {
            result = PHAsset.fetchAssets(in: album, options: options)
        }
        else {
            result = PHAsset.fetchAssets(with: options)
        }
        
        var photoList = [PhotoAsset]()
        
        for index in 0..<result.count {
            photoList.append(PhotoAsset(asset: result[index]))
        }
        
        return photoList
        
    }
    
    // 获取用户创建的相册列表
    public func fetchUserAlbumList() -> PHFetchResult<PHCollection> {
        return PHAssetCollection.fetchTopLevelUserCollections(with: nil)
    }
    
    // 获取智能相册列表
    public func fetchSmartAlbumList() -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
    }
    
    public func requestImage(asset: PHAsset, size: CGSize, options: PHImageRequestOptions, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
        // 要转成像素值
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, infoDict) in
            if image != nil {
                completion(image, infoDict)
            }
            else {
                // 加载失败后的默认图片
            }
        }
    }
    
}
