//
//  ViewController.swift
//  firestorage
//
//  Created by Lakith Jayalath on 2021-11-16.
//

import UIKit
import Photos
import FirebaseStorage
import Firebase
import FirebaseStorageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageDownloaded: UIImageView!
    var imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        
        checkPermissions()
    }

    @IBAction func uploadImageTapped(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pullImageTapped(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let ref = storageRef.child("UploadPhotoOne")
        imageDownloaded.sd_setImage(with: ref)
    }
    
    func checkPermissions() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
                                 PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                                     ()
                                 })
                             }

                             if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                             } else {
                                 PHPhotoLibrary.requestAuthorization(requestAuthroizationHandler)
                             }
    }
    
    // if the user allow to view their photos
    func requestAuthroizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            print("We have access to photos")
        } else {
            print("We dont have access to photos")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(url)
            uploadToCloud(fileURL: url)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func uploadToCloud(fileURL: URL) {
        let storage = Storage.storage()
        
        let data = Data()
        
        let storageRef = storage.reference()
        
        let localFile = fileURL
        
        let photoRef = storageRef.child("UploadPhotoOne")
        
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil) { metadata, err in
            guard let metadata = metadata else {
                print(err?.localizedDescription)
                return
            }
            print("Photo Upload")
        }
    }
    
}

