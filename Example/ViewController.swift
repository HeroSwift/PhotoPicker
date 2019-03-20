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
        controller.delegate = self
        controller.configuration = configuration
        controller.modalPresentationStyle = .overCurrentContext

        configuration.maxSelectCount = 1
        configuration.countable = false
        
        configuration.cancelButtonTitle = "Cancel 11"
        configuration.rawButtonTitle = "肉啊揉揉揉揉"
        configuration.submitButtonTitle = "Submit1234123"
        present(controller, animated: true, completion: nil)


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }


}

extension ViewController: PhotoPickerDelegate {
    
    func photoPickerDidCancel(_ photoPicker: PhotoPickerViewController) {
        photoPicker.dismiss(animated: true, completion: nil)
    }
    
    // 点击确定按钮
    func photoPickerDidSubmit(_ photoPicker: PhotoPickerViewController, assetList: [PickedAsset]) {
        photoPicker.dismiss(animated: true, completion: nil)
        print(assetList[0].path)
    }
    
    func photoPickerDidPermissionsNotGranted(_ photoPicker: PhotoPickerViewController) { }
    
    func photoPickerDidPermissionsGranted(_ photoPicker: PhotoPickerViewController) { }
    
    func photoPickerDidPermissionsDenied(_ photoPicker: PhotoPickerViewController) { }
    
}
