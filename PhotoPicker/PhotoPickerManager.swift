
import Foundation
import Photos

// https://www.jianshu.com/p/6f051fe88717
// http://kayosite.com/ios-development-and-detail-of-photo-framework-part-two.html
// http://blog.imwcl.com/2017/01/11/iOS%E5%BC%80%E5%8F%91%E8%BF%9B%E9%98%B6-Photos%E8%AF%A6%E8%A7%A3%E5%9F%BA%E4%BA%8EPhotos%E7%9A%84%E5%9B%BE%E7%89%87%E9%80%89%E6%8B%A9%E5%99%A8/
class PhotoPickerManager {
    
    
    // 获取相册列表
    func getAlbumList() {
        
        let options = PHFetchOptions()
        
        // 创建时间排序
        options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        
        // 检索什么格式
        options.predicate = NSPredicate.init(format: "mediaType IN %@", [PHAssetMediaType.image.rawValue])
        
        // 开始检索
        let allResult = PHAsset.fetchAssets(with: options)
        
    }
}
