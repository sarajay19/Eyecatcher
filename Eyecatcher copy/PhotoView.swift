//
//  PhotoView.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import SwiftUI
import Photos
import SwiftData

struct PhotoView: View {
    @Binding var imageData: Data?
    @Binding var image: Image?
    @Environment(\.dismiss) var dismiss
    var textToSpeech = SpeechSynthesizer()
    var labeler: Labeling // Receive Labeling object from outside
    @StateObject private var model = DataModel()
    @State private var showSaveInCategorySheet = false
    
    
    @State private var selectedCategory: Category? // Add state variable to store selected category
    @Query var savedPhoto: [Photo]
    
    var body: some View {
        NavigationView {
            ViewfinderView(image: $model.viewfinderImage)
                .overlay {
                    ZStack {
                        if let image = image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .edgesIgnoringSafeArea(.all)
                        } else {
                            ProgressView()
                        }
                        
                        VStack {
                            HStack(alignment: .top) {
                                Button(action: { dismiss() }) {
                                    Image(systemName: "xmark")
                                        .padding(.vertical)
                                        .padding(.leading, 310)
//                                        .padding(.leading, 870)
                                }
                                .foregroundColor(.white)
                                .font(.title)
                            }
                            .padding(.top, 45)
                            .padding(.horizontal, 15)

                            
                            Spacer()
                            
                            HStack(alignment: .bottom, spacing: 20) {
                               //here
//                                Text("\(savedPhoto.count)")
                                Button(action: {
                                    print("Mic button pressed, label: \(labeler.mostProminentLabel)")
                                    textToSpeech.detectAndSpeak(label: labeler.mostProminentLabel)
                                }) {
                                    Image(systemName: "speaker.wave.2.circle.fill")
                                        .foregroundColor(.white)
//                                        .font(.title)
                                        .font(.custom("Speaker Button" ,size: 50))
                                }
                                
//                                Button(action: {
//                                    // Check if image data exists in the model
//                                    //                                    guard let imageData = model.imageData else { return }
//                                    // Show the "SaveInCategory" sheet
//                                    showSaveInCategorySheet.toggle()
//                                }) {
//                                    Image(systemName: "square.and.arrow.down")
//                                        .foregroundColor(.white)
//                                        .font(.largeTitle)
//                                }
//                                .sheet(isPresented: $showSaveInCategorySheet) {
//                                    SaveInCategory(uiImage: $model.uiImage, image: $image, selectedCategory: $selectedCategory, showSaveInCategorySheet: $showSaveInCategorySheet) { // Pass closure for dismissal
//                                        dismiss() // Call dismiss from PhotoView
//                                    }
//                                }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            }
                        .padding(.bottom, 20)
                            .ignoresSafeArea()
                        }
                        
                    }
                }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
    
//struct SaveInCategory: View {
//    @Binding var uiImage: UIImage?
//    @Binding var image: Image?
//    @Binding var selectedCategory: Category? // Add binding for selectedCategory
//    @Binding var showSaveInCategorySheet: Bool
//    let onDismiss: () -> Void
//    @Environment(\.modelContext) private var modelContext
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let image = image, let selectedCategory = selectedCategory {
//                    // Display message and category name
//                    Text("Saving image \(image) in category \(selectedCategory.name)")
//                } else {
//                    Text("Please select a category")
//                }
//                Spacer()
//                HStack(alignment: .bottom) {
//                        Button(action: {
//                        //action
//                            let uiImage: UIImage = image.asUIImage()
//                            let imageData = uiImage.pngData()
//                            if let imageData{
//                                let photo =  Photo(imageData: imageData)
////                                photo.category =
//                                  modelContext.insert(photo)
//                                  try? modelContext.save()
//                                  print("saved successfuly❤️")
//                            }
////                            else{
////                                print("Save failed !!!!")
////                            }
//                          
//                        }) {
//                            Text("Save")
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical)
//                                .background(Color("Orange"))
//                                .foregroundColor(.white)
//                                .fontWeight(.bold)
//                                .cornerRadius(16)
//                        }
//                    }
//                .padding()
//                .frame(alignment: .bottom)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Text("Save to")
//                        .font(.title3)
//                        .bold()
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        onDismiss()
//                        showSaveInCategorySheet = false
//                        // Your button action goes here
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                            .bold()
//                            .font(.title3)
//                    }
//                }
//            }
//        }
//    }
//}



extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
