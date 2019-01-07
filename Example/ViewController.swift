//
//  ViewController.swift
//  Example
//
//  Created by zhujl on 2019/1/5.
//  Copyright © 2019年 finstao. All rights reserved.
//

import UIKit
import PhotoPicker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let configuration = PhotoPickerConfiguration()
        
//        let grid = PhotoGrid(configuration: PhotoPickerConfiguration())
//        grid.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(grid)
//
//        view.addConstraints([
//
//            NSLayoutConstraint(item: grid, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: grid, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: grid, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: grid, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
//
//        ])
//
//        grid.photoList = PhotoPickerManager.shared.fetchPhotoList(album: nil)
        
        let list = AlbumList(configuration: configuration)
        list.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(list)
        
        view.addConstraints([
            
            NSLayoutConstraint(item: list, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: list, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: list, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: list, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            
        ])
        
        list.albumList = PhotoPickerManager.shared.fetchSmartAlbumList(albumFetchOptions: configuration.albumFetchOptions, photoFetchOptions: configuration.photoFetchOptions)
        
    }


}

