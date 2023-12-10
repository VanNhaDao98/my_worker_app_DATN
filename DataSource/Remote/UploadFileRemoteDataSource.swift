//
//  UploadFileRemoteDataSource.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/10/2023.
//

import Foundation
import UIKit
import PromiseKit
import FirebaseStorage

struct UploadFileRemoteDataSource {
    func uploadImage(image: UIImage?) -> Promise<URL?> {
        Promise { resolver in
            let storage = Storage.storage()
            let storageReference = storage.reference()
            let uuid = UUID().uuidString
            let imageReference = storageReference.child("images/\(uuid).jpg")
            
            guard let originalImage = image else { return resolver.fulfill(nil)}
            let targetSize = CGSize(width: 300, height: 300)
            let resizedSize = resizeImage(image: originalImage, targetSize: targetSize)
            guard let resizedSize = resizedSize else { return resolver.fulfill(nil)}
            guard let compressedImageData = compressImage(image: resizedSize, compressionQuality: 0.10) else { return resolver.fulfill(nil)}
            let _ = imageReference.putData(compressedImageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    resolver.reject(error)
                } else {
                    imageReference.downloadURL { (url, error) in
                        guard let error = error else { return resolver.fulfill(url)}
                        resolver.reject(error)
                    }
                }
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    func compressImage(image: UIImage, compressionQuality: CGFloat) -> Data? {
        return image.jpegData(compressionQuality: compressionQuality)
    }
}
