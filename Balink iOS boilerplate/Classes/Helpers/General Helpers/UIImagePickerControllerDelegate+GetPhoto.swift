//
//  UIImagePickerControllerDelegate+GetPhoto.swift
//  Berluti
//
//  Created by elie buff on 31/10/2017.
//  Copyright © 2017 elie buff. All rights reserved.
//

import UIKit

extension UIImagePickerControllerDelegate{
    
    func launchTakePhoto(viewController :UIViewController, picker :UIImagePickerControllerDelegate&UINavigationControllerDelegate){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = picker
        imagePicker.allowsEditing = true
        
        let takePicture = UIAlertAction(title: "Take a New Picture", style: .default) { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera;
                viewController.present(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(takePicture)
        
        
        let fromLibrary = UIAlertAction(title: "Select from Library", style: .default) { (alertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.sourceType = .photoLibrary;
                viewController.present(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(fromLibrary)
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            print("Test")
        }
        alertController.addAction(CancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

