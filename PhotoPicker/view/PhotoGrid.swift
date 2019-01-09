
import UIKit
import Photos

public class PhotoGrid: UIView {
    
    var onSelectedPhotoListChange: (() -> Void)?
    
    public var fetchResult: PHFetchResult<PHAsset>! {
        didSet {
            
            var list = [PhotoAsset]()
            
            fetchResult.enumerateObjects { asset, _, _ in
                list.append(PhotoAsset(asset: asset))
            }
            
            photoList = list
            
        }
    }
    
    var photoList = [PhotoAsset]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedPhotoList = [PhotoAsset]() {
        didSet {
            onSelectedPhotoListChange?()
        }
    }
    
    private var configuration: PhotoPickerConfiguration!
    
    private let cellIdentifier = "cell"
    
    private var cellSize: CGSize! {
        didSet {
            cellPixelSize = PhotoPickerManager.shared.getPixelSize(size: cellSize)
        }
    }
    
    private var cellPixelSize: CGSize!
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        
        let view = UICollectionViewFlowLayout()
        
        view.scrollDirection = .vertical
        
        return view
        
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let view = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = false
        
        view.register(PhotoCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = configuration.photoGridBackgroundColor
        
        addSubview(view)
        
        addConstraints([
            
            NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            
        ])
        
        return view
        
    }()
    
    public convenience init(configuration: PhotoPickerConfiguration) {
        self.init()
        self.configuration = configuration
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    public func scrollToBottom(animated: Bool) {
        guard photoList.count > 0 else {
            return
        }
        collectionView.scrollToItem(at: IndexPath(item: photoList.count - 1, section: 0), at: .bottom, animated: animated)
    }
    
    public func getSelectedPhotoList() -> [PhotoAsset] {
        
        var result = [PhotoAsset]()
        
        selectedPhotoList.forEach { photo in
            result.append(photo)
        }
        
        // 不计数就用照片原来的顺序
        if !configuration.countable {
            result.sort { a, b in
                return a.index > b.index
            }
        }
        
        return result
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        cellSize = getCellSize()
    }

}

extension PhotoGrid: UICollectionViewDataSource {
    
    // 获取照片数量
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    // 复用 cell 组件
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCell
        
        let index = indexPath.item
        let photo = photoList[index]

        photo.index = index
        
        // 选中状态下可以反选
        if photo.checkedIndex >= 0 {
            photo.selectable = true
        }
        else {
            photo.selectable = selectedPhotoList.count < configuration.maxSelectCount
        }
        
        cell.configuration = configuration
        cell.size = cellPixelSize
        cell.photo = photo
        
        cell.onToggleChecked = {
            self.toggleChecked(photo: photo)
        }
        
        return cell
    }
    
}

extension PhotoGrid: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        guard cell.photo.selectable else {
            return
        }
    }
    
}

extension PhotoGrid: UICollectionViewDelegateFlowLayout {
    
    // 设置内边距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: configuration.photoGridPaddingVertical,
            left: configuration.photoGridPaddingHorizontal,
            bottom: configuration.photoGridPaddingVertical,
            right: configuration.photoGridPaddingHorizontal
        )
    }
    
    // 行间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return configuration.photoGridRowSpacing
    }
    
    // 列间距
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return configuration.photoGridColumnSpacing
    }
    
    // 设置单元格尺寸
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}

extension PhotoGrid {
    
    private func getCellSize() -> CGSize {
        
        let photoNumber = configuration.numberOfPhotoPerLine
        
        let paddingHorizontal = configuration.photoGridPaddingHorizontal * 2
        let insetHorizontal = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let gapHorizontal = configuration.photoGridColumnSpacing * (photoNumber - 1)
        
        let spacing = paddingHorizontal + insetHorizontal + gapHorizontal
        let width = ((collectionView.frame.width - spacing) / photoNumber).rounded(.down)
        
        // 正方形就行
        return CGSize(width: width, height: width)
        
    }
    
    private func toggleChecked(photo: PhotoAsset) {
        
        // checked 获取反选值
        let checked = photo.checkedIndex < 0
        let selectedCount = selectedPhotoList.count
        
        if checked {
            
            // 因为有动画，用户可能在动画过程中快速点击了新的照片
            // 这里应该忽略
            if selectedCount == configuration.maxSelectCount {
                return
            }
            
            photo.checkedIndex = selectedCount
            selectedPhotoList.append(photo)
            
            // 到达最大值，就无法再选了
            if selectedCount + 1 == configuration.maxSelectCount {
                collectionView.reloadData()
            }
            else {
                collectionView.reloadItems(at: [getIndexPath(index: photo.index)])
            }
            
        }
        else {
            
            selectedPhotoList.remove(at: photo.checkedIndex)
            photo.checkedIndex = -1
            
            var changes = [IndexPath]()
            
            changes.append(getIndexPath(index: photo.index))
            
            // 重排顺序
            for i in 0..<selectedPhotoList.count {
                let selectedPhoto = selectedPhotoList[i]
                if i != selectedPhoto.checkedIndex {
                    selectedPhoto.checkedIndex = i
                    changes.append(getIndexPath(index: selectedPhoto.index))
                }
            }
            
            // 上个状态是到达上限
            if selectedCount == configuration.maxSelectCount {
                collectionView.reloadData()
            }
            else {
                collectionView.reloadItems(at: changes)
            }
            
        }

    }
    
    private func getIndexPath(index: Int) -> IndexPath {
        return IndexPath(item: index, section: 0)
    }
    
}

extension PhotoGrid: PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync {
            
            if let changeDetails = changeInstance.changeDetails(for: fetchResult) {
                fetchResult = changeDetails.fetchResultAfterChanges
            }
            
        }
    }
}

