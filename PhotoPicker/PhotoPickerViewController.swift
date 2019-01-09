
import UIKit
import Photos

public class PhotoPickerViewController: UIViewController {
    
    public var configuration: PhotoPickerConfiguration!
    
    private var albumListHeightLayoutConstraint: NSLayoutConstraint!
    private var albumListBottomLayoutConstraint: NSLayoutConstraint!
    
    // 默认给 1，避免初始化 albumListView 时读取到的高度为 0，无法判断是显示还是隐藏状态
    private var albumListHeight: CGFloat = 1 {
        didSet {
            
            guard albumListHeight != oldValue, albumListHeightLayoutConstraint != nil else {
                return
            }
            
            albumListHeightLayoutConstraint.constant = albumListHeight
            
            // 隐藏状态
            if albumListBottomLayoutConstraint.constant < 0 {
                albumListBottomLayoutConstraint.constant = -albumListHeight
            }
            
            if !albumListView.isHidden {
                view.setNeedsLayout()
            }
            
        }
    }
    
    // 当前选中的相册
    private var currentAlbum: PHAssetCollection! {
        didSet {
            
            guard currentAlbum !== oldValue else {
                return
            }
            
            photoGridView.fetchResult = PhotoPickerManager.shared.fetchPhotoList(
                album: currentAlbum,
                options: configuration.photoFetchOptions
            )
            
            topBar.titleView.title = currentAlbum.localizedTitle!
            
        }
    }
    
    private lazy var albumListView: AlbumList = {
        
        let albumListView = AlbumList(configuration: configuration)
        
        albumListView.albumList = PhotoPickerManager.shared.albumList
        
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
            toItem: view,
            attribute: .bottom,
            multiplier: 1,
            constant: -albumListHeight
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
        
        view.insertSubview(photoGridView, belowSubview: topBar)
        
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
        
        topBar.titleView.addTarget(self, action: #selector(onTitleClick), for: .touchUpInside)
        
        view.addSubview(topBar)
        
        view.addConstraints([
            NSLayoutConstraint(item: topBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
        ])
        
        return topBar
        
    }()
    
    private lazy var bottomBar: BottomBar = {
       
        let bottomBar = BottomBar(configuration: configuration)
        
        bottomBar.isRawChecked = false
        bottomBar.selectedCount = 0
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(bottomBar, belowSubview: topBar)
        
        view.addConstraints([
            NSLayoutConstraint(item: bottomBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
        return bottomBar
        
    }()
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let manager = PhotoPickerManager.shared
        
        manager.requestPermissions {
            manager.setup(
                photoFetchOptions: self.configuration.photoFetchOptions,
                showEmptyAlbum: self.configuration.showEmptyAlbum,
                showVideo: self.configuration.showVideo
            )
            self.currentAlbum = manager.albumList[0].collection
        }
        
        manager.onPermissionsGranted = {
            
        }
        
        manager.onPermissionsDenied = {
            
        }
        
        manager.onFetchWithoutPermissions = {
            
        }

    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        albumListHeight = UIScreen.main.bounds.height - topBar.frame.height
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func toggleAlbumList() {
        
        let checked = !topBar.titleView.checked
        
        // 因为 albumListView 是惰性初始化的
        // 当第一次 toggle 时，下面这句会创建 albumListView
        // 如果不加 DispatchQueue.main.asyncAfter，创建 albumListView 时的 auto layout 会参与动画
        // 但这是不必要的
        if checked {
            albumListView.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            self.albumListBottomLayoutConstraint.constant = checked ? 0 : -self.albumListHeight

            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.topBar.titleView.checked = checked
                    self.view.layoutIfNeeded()
                },
                completion: { success in
                    if !checked {
                        self.albumListView.isHidden = true
                    }
                }
            )
            
        }
        
    }
    
    @objc private func onCancelClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func onTitleClick() {
        toggleAlbumList()
    }
    
}


