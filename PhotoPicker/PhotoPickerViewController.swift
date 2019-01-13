
import UIKit
import Photos

public class PhotoPickerViewController: UIViewController {
    
    public var delegate: PhotoPickerDelegate!
    public var configuration: PhotoPickerConfiguration!
    
    private var topBarHeightLayoutConstraint: NSLayoutConstraint!
    private var bottomBarHeightLayoutConstraint: NSLayoutConstraint!
    
    private var albumListHeightLayoutConstraint: NSLayoutConstraint!
    private var albumListBottomLayoutConstraint: NSLayoutConstraint!
    
    private var albumListVisible = false
    
    // 默认给 1，避免初始化 albumListView 时读取到的高度为 0，无法判断是显示还是隐藏状态
    private var albumListHeight: CGFloat = 1 {
        didSet {
            
            guard albumListHeight != oldValue, albumListHeightLayoutConstraint != nil else {
                return
            }
            
            albumListHeightLayoutConstraint.constant = albumListHeight
            
            if albumListBottomLayoutConstraint.constant > 0 {
                albumListBottomLayoutConstraint.constant = albumListHeight
            }
            
        }
    }
    
    // 当前选中的相册
    private var currentAlbum: PHAssetCollection? {
        didSet {
            
            guard currentAlbum !== oldValue else {
                return
            }
            
            let title: String
            let fetchResult: PHFetchResult<PHAsset>
            
            if let album = currentAlbum {
                title = album.localizedTitle!
                fetchResult = PhotoPickerManager.shared.fetchPhotoList(
                    album: album,
                    configuration: configuration
                )
            }
            else {
                title = ""
                fetchResult = PHFetchResult<PHAsset>()
            }
            
            topBar.titleButton.title = title
            photoGridView.fetchResult = fetchResult

        }
    }

    private lazy var albumListView: AlbumList = {
        
        let albumListView = AlbumList(configuration: configuration)

        albumListView.onAlbumClick = { album in
            self.currentAlbum = album.collection
            self.toggleAlbumList()
        }
        
        albumListView.isHidden = true
        
        albumListView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(albumListView, belowSubview: topBar)
        
        albumListBottomLayoutConstraint = NSLayoutConstraint(
            item: albumListView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: topBar,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        
        albumListHeightLayoutConstraint = NSLayoutConstraint(
            item: albumListView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: albumListHeight
        )
        
        view.addConstraints([
    
            NSLayoutConstraint(item: albumListView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: albumListView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            albumListBottomLayoutConstraint,
            albumListHeightLayoutConstraint
            
        ])
        
        return albumListView
        
    }()
    
    private lazy var photoGridView: PhotoGrid = {
    
        let photoGridView = PhotoGrid(configuration: configuration)
        
        photoGridView.translatesAutoresizingMaskIntoConstraints = false
        
        photoGridView.onSelectedPhotoListChange = {
            self.bottomBar.selectedCount = photoGridView.selectedPhotoList.count
        }
        
        view.insertSubview(photoGridView, belowSubview: albumListView)
        
        view.addConstraints([
            
            NSLayoutConstraint(item: photoGridView, attribute: .top, relatedBy: .equal, toItem: topBar, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoGridView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoGridView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoGridView, attribute: .bottom, relatedBy: .equal, toItem: bottomBar, attribute: .top, multiplier: 1, constant: 0),
            
        ])
        
        return photoGridView
        
    }()
    
    private lazy var topBar: TopBar = {
        
        let topBar = TopBar(configuration: configuration)
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.cancelButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
        
        topBar.titleButton.addTarget(self, action: #selector(onTitleClick), for: .touchUpInside)
        
        view.addSubview(topBar)
        
        topBarHeightLayoutConstraint = NSLayoutConstraint(
            item: topBar,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: configuration.topBarHeight
        )
        
        view.addConstraints([
            NSLayoutConstraint(item: topBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBar, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            topBarHeightLayoutConstraint
        ])
        
        return topBar
        
    }()
    
    private lazy var bottomBar: BottomBar = {
       
        let bottomBar = BottomBar(configuration: configuration)
        
        bottomBar.isRawChecked = false
        bottomBar.selectedCount = 0
        
        bottomBar.submitButton.onClick = {
            self.onSubmitClick()
        }
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(bottomBar, belowSubview: albumListView)
        
        bottomBarHeightLayoutConstraint = NSLayoutConstraint(
            item: bottomBar,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: configuration.bottomBarHeight
        )
        
        view.addConstraints([
            NSLayoutConstraint(item: bottomBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomBar, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            bottomBarHeightLayoutConstraint
        ])
        
        return bottomBar
        
    }()
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()

        let manager = PhotoPickerManager.shared

        manager.requestPermissions {
            guard manager.scan() else {
                return
            }
            self.setup()
        }
        
        manager.onPermissionsGranted = {
            self.delegate.photoPickerDidPermissionsGranted(self)
        }
        
        manager.onPermissionsDenied = {
            self.delegate.photoPickerDidPermissionsDenied(self)
        }
        
        manager.onFetchWithoutPermissions = {
            self.delegate.photoPickerWillFetchWithoutPermissions(self)
        }
        
        manager.onAlbumListChange = {
            self.updateAlbumList()
        }

    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var height = view.bounds.height
        
        if #available(iOS 11.0, *) {
            
            let top = view.safeAreaInsets.top
            let bottom = view.safeAreaInsets.bottom
            
            height -= bottom
            
            topBarHeightLayoutConstraint.constant = configuration.topBarHeight + top
            bottomBarHeightLayoutConstraint.constant = configuration.bottomBarHeight + bottom
            
        }
        
        height -= topBarHeightLayoutConstraint.constant
        
        albumListHeight = height
        
        view.setNeedsLayout()
        
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setup() {

        updateAlbumList()
        
        let albumList = albumListView.albumList
        currentAlbum = albumList.count > 0 ? albumList[0].collection : nil
        
    }

    private func updateAlbumList() {
        
        albumListView.albumList = PhotoPickerManager.shared.fetchAlbumList(configuration: configuration)
        
    }
    
    private func toggleAlbumList() {
        
        let visible = !albumListVisible
        
        if visible {
            albumListView.isHidden = false
        }
        
        // 位移动画
        albumListBottomLayoutConstraint.constant = visible ? albumListHeight : 0
        
        // 旋转动画
        // - 0.01 可以让动画更舒服，不信可去掉试试
        let pi = CGFloat.pi - 0.01
        let transform = visible ? topBar.titleButton.arrowView.transform.rotated(by: -pi) : CGAffineTransform.identity

        UIView.animate(
            withDuration: configuration.titleButtonArrowAnimationDuration,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.topBar.titleButton.arrowView.transform = transform
                self.view.layoutIfNeeded()
            },
            completion: { success in
                if !visible {
                    self.albumListView.isHidden = true
                }
            }
        )
        
        albumListVisible = visible
        
    }
    
    private func onSubmitClick() {

        var selectedList = [PhotoAsset]()
        
        // 先排序
        photoGridView.selectedPhotoList.forEach { photo in
            selectedList.append(photo)
        }
        
        // 不计数就用照片原来的顺序
        if !configuration.countable {
            selectedList.sort { a, b in
                return a.index > b.index
            }
        }
        
        // 排序完成之后，转成 PickedAsset
        
        var result = [PickedAsset]()
        var count = 0
        
        let isRawChecked = bottomBar.isRawChecked
        
        selectedList.forEach { photo in
            
            PhotoPickerManager.shared.getAssetURL(asset: photo.asset) { url in
                count += 1
                if let url = url {
                    result.append(
                        PickedAsset(path: url.absoluteString, width: photo.width, height: photo.height, size: 0, isVideo: photo.type == .video, isRaw: isRawChecked)
                    )
                }
                if count == selectedList.count {
                    self.delegate.photoPickerDidPick(self, assetList: result)
                }
            }
        
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func onCancelClick() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func onTitleClick() {
        toggleAlbumList()
    }
    
}


