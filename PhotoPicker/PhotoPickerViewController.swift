
import UIKit
import Photos

public class PhotoPickerViewController: UIViewController {
    
    public var configuration: PhotoPickerConfiguration!
    
    private var topBarHeightLayoutConstraint: NSLayoutConstraint!
    private var bottomBarHeightLayoutConstraint: NSLayoutConstraint!
    
    private var albumListHeightLayoutConstraint: NSLayoutConstraint!
    private var albumListBottomLayoutConstraint: NSLayoutConstraint!
    
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
    private var currentAlbum: PHAssetCollection! {
        didSet {
            
            guard currentAlbum !== oldValue else {
                return
            }
            
            photoGridView.fetchResult = PhotoPickerManager.shared.fetchPhotoList(
                album: currentAlbum,
                configuration: configuration
            )
            
            topBar.titleView.title = currentAlbum.localizedTitle!
            
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
        
        topBar.titleView.addTarget(self, action: #selector(onTitleClick), for: .touchUpInside)
        
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
            print(self.photoGridView.getSelectedPhotoList())
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
            guard manager.setup() else {
                return
            }
            self.updateAlbumList()
            self.currentAlbum = self.albumListView.albumList[0].collection
        }
        
        manager.onPermissionsGranted = {
            
        }
        
        manager.onPermissionsDenied = {
            
        }
        
        manager.onFetchWithoutPermissions = {
            
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

    private func updateAlbumList() {
        
        albumListView.albumList = PhotoPickerManager.shared.fetchAlbumList(configuration: configuration)
        
    }
    
    private func toggleAlbumList() {
        
        let checked = !topBar.titleView.checked
        
        if checked {
            albumListView.isHidden = false
        }
        
        albumListBottomLayoutConstraint.constant = checked ? albumListHeight : 0

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
    
    @objc private func onCancelClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func onTitleClick() {
        toggleAlbumList()
    }
    
}


