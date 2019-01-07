
import UIKit

public class PhotoGrid: UIView {
    
    public var photoList = [PhotoAsset]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var configuration: PhotoPickerConfiguration!
    
    private let cellIdentifier = "cell"
    
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

        cell.configuration = configuration
        cell.photo = photo
        
        return cell
    }
    
}

extension PhotoGrid: UICollectionViewDelegate {
    
    // 点击事件
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
    }
    
    // 按下事件
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
    }
    
    // 松手事件
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
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
        return getCellSize()
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
    
}
