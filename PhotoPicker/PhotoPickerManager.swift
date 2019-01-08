
import Foundation
import Photos

// https://www.jianshu.com/p/6f051fe88717
// http://kayosite.com/ios-development-and-detail-of-photo-framework-part-two.html
// http://blog.imwcl.com/2017/01/11/iOS%E5%BC%80%E5%8F%91%E8%BF%9B%E9%98%B6-Photos%E8%AF%A6%E8%A7%A3%E5%9F%BA%E4%BA%8EPhotos%E7%9A%84%E5%9B%BE%E7%89%87%E9%80%89%E6%8B%A9%E5%99%A8/

public class PhotoPickerManager: NSObject {
    
    public static let shared: PhotoPickerManager = PhotoPickerManager()
    
    override private init() {
        super.init()
        
        allPhotos = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        favorites = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        
        panoramas = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: nil)
        
        timelapses = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumTimelapses, options: nil)
        
        videos = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)

        if #available(iOS 9.0, *) {
            selfPortraints = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil)
            screenshots = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
        }

        if #available(iOS 10.3, *) {
            livePhotos = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumLivePhotos, options: nil)
        }
        
        if #available(iOS 11.0, *) {
            animations = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumAnimated, options: nil)
        }
        
        userAlbums = PHAssetCollection.fetchTopLevelUserCollections(with: nil)
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    // 所有照片
    private var allPhotos: PHFetchResult<PHAssetCollection>!
    
    // 收藏
    private var favorites: PHFetchResult<PHAssetCollection>!
    
    // 截图
    private var screenshots: PHFetchResult<PHAssetCollection>?
    
    // 动图
    private var animations: PHFetchResult<PHAssetCollection>?
    
    // 自拍
    private var selfPortraints: PHFetchResult<PHAssetCollection>?

    // 实景
    private var livePhotos: PHFetchResult<PHAssetCollection>?

    // 全景
    private var panoramas: PHFetchResult<PHAssetCollection>!
    
    // 延时
    private var timelapses: PHFetchResult<PHAssetCollection>!

    // 视频
    private var videos: PHFetchResult<PHAssetCollection>!
    
    // 用户创建的相册
    private var userAlbums: PHFetchResult<PHCollection>!
    
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
    public func fetchPhotoList(options: PHFetchOptions, album: PHAssetCollection? = nil) -> PHFetchResult<PHAsset> {

        if let album = album {
            return PHAsset.fetchAssets(in: album, options: options)
        }

        return PHAsset.fetchAssets(in: allPhotos.firstObject!, options: options)
        
    }
    
    // 获取相册列表
    public func fetchAlbumList(photoFetchOptions: PHFetchOptions, showEmptyAlbum: Bool, showVideo: Bool) -> [AlbumAsset] {
        
        var albumList = [PHAssetCollection]()
        
        let appendAlbum = { (album: PHAssetCollection?) in
            if let album = album {
                albumList.append(album)
            }
        }
        
        appendAlbum(allPhotos.firstObject)
        appendAlbum(favorites.firstObject)
        
        appendAlbum(screenshots?.firstObject)
        appendAlbum(animations?.firstObject)
        appendAlbum(selfPortraints?.firstObject)
        appendAlbum(livePhotos?.firstObject)

        appendAlbum(panoramas.firstObject)
        appendAlbum(timelapses.firstObject)
        
        if showVideo {
            appendAlbum(videos.firstObject)
        }
        
        userAlbums.enumerateObjects { album, index, stop in
            appendAlbum(album as? PHAssetCollection)
        }

        var result = [AlbumAsset]()
        
        albumList.forEach { album in
            
            let photoList = fetchPhotoList(options: photoFetchOptions, album: album)
            let photoCount = photoList.count
            
            if showEmptyAlbum || photoCount > 0 {
                // 缩略图显示最后一个
                result.append(
                    AlbumAsset(
                        collection: album,
                        poster: photoCount > 0 ? PhotoAsset(asset: photoList[photoCount - 1]) : nil,
                        count: photoCount
                    )
                )
            }
            
        }
        
        return result
        
    }
    
    public func requestImage(asset: PHAsset, size: CGSize, options: PHImageRequestOptions, completion: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        // 要转成像素值
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        return PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: completion)
    }
    
    public func cancelImageRequest(_ requestID: PHImageRequestID) {
        PHImageManager.default().cancelImageRequest(requestID)
    }

}

extension PhotoPickerManager: PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            
            allPhotos = updateChange(changeInstance: changeInstance, fetchResult: allPhotos)
            favorites = updateChange(changeInstance: changeInstance, fetchResult: favorites)
            screenshots = updateChange(changeInstance: changeInstance, fetchResult: screenshots)
            animations = updateChange(changeInstance: changeInstance, fetchResult: animations)
            selfPortraints = updateChange(changeInstance: changeInstance, fetchResult: selfPortraints)
            livePhotos = updateChange(changeInstance: changeInstance, fetchResult: livePhotos)
            panoramas = updateChange(changeInstance: changeInstance, fetchResult: panoramas)
            timelapses = updateChange(changeInstance: changeInstance, fetchResult: timelapses)
            userAlbums = updateChange(changeInstance: changeInstance, fetchResult: userAlbums)
            
        }
    }
}

extension PhotoPickerManager {
    
    private func updateChange(changeInstance: PHChange, fetchResult: PHFetchResult<PHAssetCollection>?) -> PHFetchResult<PHAssetCollection>? {
        
        guard let fetchResult = fetchResult else {
            return nil
        }
        
        if let changeDetails = changeInstance.changeDetails(for: fetchResult) {
            return changeDetails.fetchResultAfterChanges
        }
        
        return nil
        
    }
    
    private func updateChange(changeInstance: PHChange, fetchResult: PHFetchResult<PHCollection>?) -> PHFetchResult<PHCollection>? {
        
        guard let fetchResult = fetchResult else {
            return nil
        }
        
        if let changeDetails = changeInstance.changeDetails(for: fetchResult) {
            return changeDetails.fetchResultAfterChanges
        }
        
        return nil
        
    }
    
}
