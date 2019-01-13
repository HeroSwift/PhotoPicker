
import UIKit

public protocol PhotoPickerDelegate {
    
    // 点击确定按钮
    func photoPickerDidPick(_ photoPicker: PhotoPickerViewController, assetList: [PickedAsset])
    
    // 获取相册数据时发现没权限
    func photoPickerWillFetchWithoutPermissions(_ photoPicker: PhotoPickerViewController)
    
    // 用户点击同意授权
    func photoPickerDidPermissionsGranted(_ photoPicker: PhotoPickerViewController)
    
    // 用户点击拒绝授权
    func photoPickerDidPermissionsDenied(_ photoPicker: PhotoPickerViewController)
    
}

public extension PhotoPickerDelegate {
    
    func photoPickerDidPick(_ photoPicker: PhotoPickerViewController, assetList: [PickedAsset]) { }
    
    func photoPickerWillFetchWithoutPermissions(_ photoPicker: PhotoPickerViewController) { }
    
    func photoPickerDidPermissionsGranted(_ photoPicker: PhotoPickerViewController) { }
    
    func photoPickerDidPermissionsDenied(_ photoPicker: PhotoPickerViewController) { }
    
}
