
import UIKit

public class PhotoGridViewController: UIViewController {
    
    public var configuration: PhotoPickerConfiguration!
    
    private lazy var gridView: PhotoGrid = {
    
        let photoGrid = PhotoGrid(configuration: configuration)
        
        photoGrid.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(photoGrid)
        
        view.addConstraints([
            
            NSLayoutConstraint(item: photoGrid, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoGrid, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoGrid, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: photoGrid, attribute: .bottom, relatedBy: .equal, toItem: bottomBar, attribute: .top, multiplier: 1, constant: 0),
            
        ])
        
        return photoGrid
        
    }()
    
    private lazy var bottomBar: BottomBar = {
       
        let bottomBar = BottomBar(configuration: configuration)
        
        bottomBar.isRawChecked = false
        bottomBar.count = 0
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomBar)
        
        view.addConstraints([
            NSLayoutConstraint(item: bottomBar, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: bottomBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
        ])
        
        return bottomBar
        
    }()
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        gridView.fetchResult = PhotoPickerManager.shared.fetchPhotoList(options: configuration.photoFetchOptions)

    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


