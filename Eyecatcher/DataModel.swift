//
//  DataModel.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import AVFoundation
import SwiftUI

@MainActor final class DataModel: NSObject,ObservableObject {
    @Published var imageData: Data?
    @Published var uiImage: UIImage?
    
    let camera = Camera()
    var detector = ObjectDetection()
    var labeler = Labeling()
    
    @Published var viewfinderImage: Image?
    @Published var thumbnailImage: Image?
    @Published  var selectedLanguage = "English"

    var isPhotosLoaded = false
    
    override init() {
        super.init()
        Task {
            await handleCameraPreviews()
        }
        
        Task {
            await handleCameraPhotos()
        }
    }
    
    func handleCameraPreviews() async {
        let imageStream = camera.previewStream
            .map { $0 }

        for await image in imageStream {
            Task { @MainActor in
                
                if !detector.ready {
                    viewfinderImage = image.image
                    return
                }
                camera.isPreviewPaused = true
                
                
                let observations = self.detector.detectAndProcess(image:   image)
                let labeledImage = labeler.labelImage(image: UIImage(ciImage: image), observations: observations , language : selectedLanguage , shouldLabel : false)
                self.uiImage = UIImage(ciImage: image)
                viewfinderImage = Image(uiImage: labeledImage ?? UIImage(ciImage: image))
                camera.isPreviewPaused = false
                
            }
        }
    }
    
    
    //Hrer💻
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { await self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                thumbnailImage = photoData.thumbnailImage
                uiImage =  photoData.imageData
                print(uiImage,"💻")
            }
            // Removed Automatic Saving in DataModel:
//            savePhoto(imageData: photoData.imageData)
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> PhotoData? {
        if !self.detector.ready { return nil}
        guard let imageData = photo.fileDataRepresentation() else { return nil }
        
        guard let detImage = CIImage(data: imageData,options: [.applyOrientationProperty:true]) else {return nil}
        
        let observations = self.detector.detectAndProcess(image: detImage)
        let labeledImage = labeler.labelImage(image: UIImage(ciImage: detImage), observations: observations , language : selectedLanguage , shouldLabel : true)!
        uiImage = UIImage(data: imageData)
        let thumbnailImage = Image(uiImage: labeledImage)
        let firstLabel = observations.first?.label ?? "Unknown"  // Default to "Unknown" if no observations

    return PhotoData(thumbnailImage: thumbnailImage, imageData: labeledImage, label: firstLabel)
        
    }

    
    func savePhoto(imageData: UIImage) {
        Task {
            /// Save `image` into Photo Library
//             UIImageWriteToSavedPhotosAlbum(imageData, self,
//                 #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            print("Saving image data to custom location (placeholder).")

        }
    }

    
    /// Process photo saving result
    @objc func image(_ image: UIImage,
        didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("ERROR: \(error)")
            
        }
    }
    
}

fileprivate struct PhotoData {
    var thumbnailImage: Image
    var imageData: UIImage
    var label : String
}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
