//
//  ImagePicker.swift
//  BClean!
//
//  Created by Julien Le ber on 04/02/2023.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker:UIViewControllerRepresentable{
    @Binding var selectedImage:UIImage?
    @Binding var isSheetShowing:Bool
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}

class Coordinator:NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var parent:ImagePicker
    
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("It got cancelled")
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Success")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.parent.selectedImage = image
            self.parent.isSheetShowing = false
        }
    }
}
