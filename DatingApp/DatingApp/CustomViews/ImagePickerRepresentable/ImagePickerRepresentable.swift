//
//  ImagePickerRepresentable.swift
//  DatingApp
//
//  Created by Radley Hoang on 27/11/2021.
//

import SwiftUI

enum ImagePickerType {
    case photoLibrary
    case stillImage
    case videoLibrary
    case videoWithMic
}

struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: ImagePickerType = .photoLibrary
    
    @Binding var selectedImage: UIImage?
    @Binding var selectedVideoUrl: URL?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        
        imagePicker.delegate = context.coordinator
        switch sourceType {
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        case .stillImage:
            imagePicker.sourceType = .camera
        case .videoLibrary:
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = ["public.movie"]
        case .videoWithMic:
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = ["public.movie"]
        }
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            switch parent.sourceType {
            case .photoLibrary, .stillImage:
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    parent.selectedImage = image
                }
                
            default:
                if let videoUrl = info[.mediaURL] as? URL {
                    parent.selectedVideoUrl = videoUrl
                }
                
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
