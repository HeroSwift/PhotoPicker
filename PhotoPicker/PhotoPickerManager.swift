
import Foundation
import Photos

// https://www.jianshu.com/p/6f051fe88717
// http://kayosite.com/ios-development-and-detail-of-photo-framework-part-two.html
// http://blog.imwcl.com/2017/01/11/iOS%E5%BC%80%E5%8F%91%E8%BF%9B%E9%98%B6-Photos%E8%AF%A6%E8%A7%A3%E5%9F%BA%E4%BA%8EPhotos%E7%9A%84%E5%9B%BE%E7%89%87%E9%80%89%E6%8B%A9%E5%99%A8/

public class PhotoPickerManager {
    
    public static let shared: PhotoPickerManager = PhotoPickerManager()
    
    // 全局单例
    private let imageManager = PHImageManager.default()
    
    // 所有操作之前必须先确保拥有权限
    public func requestPermissions() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                if status == PHAuthorizationStatus.authorized {
                    
                }
                else {
                    
                }
            }
            break
        default:
            // denied 和 restricted 都表示没有权限访问相册
            break
        }
    }
    
    // 获取所有照片
    public func fetchPhotoList(options: PHFetchOptions, album: PHAssetCollection?) -> [PhotoAsset] {
        
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
    public func fetchUserAlbumList(albumFetchOptions: PHFetchOptions, photoFetchOptions: PHFetchOptions) -> [AlbumAsset] {
        return fetchAlbumList(albumFetchOptions: albumFetchOptions, photoFetchOptions: photoFetchOptions, isSmart: false)
    }
    
    // 获取智能相册列表
    public func fetchSmartAlbumList(albumFetchOptions: PHFetchOptions, photoFetchOptions: PHFetchOptions) -> [AlbumAsset] {
        return fetchAlbumList(albumFetchOptions: albumFetchOptions, photoFetchOptions: photoFetchOptions, isSmart: true)
    }
    
    private func fetchAlbumList(albumFetchOptions: PHFetchOptions, photoFetchOptions: PHFetchOptions, isSmart: Bool) -> [AlbumAsset] {
        
        var albumList = [AlbumAsset]()
        
        let result: PHFetchResult<PHAssetCollection>
        
        if isSmart {
            result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: albumFetchOptions)
        }
        else {
            result = PHAssetCollection.fetchTopLevelUserCollections(with: albumFetchOptions) as! PHFetchResult<PHAssetCollection>
        }
        
        let showEmptyAlbum = true
        
        for index in 0..<result.count {
            let album = result[index]
            let photoList = fetchPhotoList(options: photoFetchOptions, album: album)
            let photoCount = photoList.count
            if showEmptyAlbum || photoCount > 0 {
                // 缩略图显示最后一个
                albumList.append(AlbumAsset(collection: album, thumbnail: photoCount > 0 ? photoList[photoCount - 1] : nil, count: photoCount))
            }
        }

        return albumList
        
    }
    
    public func requestImage(asset: PHAsset, size: CGSize, options: PHImageRequestOptions, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
        // 要转成像素值
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: completion)
    }
    
}
