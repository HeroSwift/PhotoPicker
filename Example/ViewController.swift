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

    let configuration = PhotoPickerConfiguration()
    
    @IBAction func onClick(_ sender: Any) {
        
        let controller = PhotoPickerViewController()
        controller.configuration = configuration
        controller.modalPresentationStyle = .overCurrentContext
        
        present(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
//        let list = AlbumList(configuration: configuration)
//        list.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(list)
//
//        view.addConstraints([
//
//            NSLayoutConstraint(item: list, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: list, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: list, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0),
//            NSLayoutConstraint(item: list, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
//
//        ])
//
//        list.albumList = PhotoPickerManager.shared.fetchAlbumList(photoFetchOptions: configuration.photoFetchOptions, showEmptyAlbum: false, showVideo: true)
        
    }


}

