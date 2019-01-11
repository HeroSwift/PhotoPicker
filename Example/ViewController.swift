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
    
    }


}

