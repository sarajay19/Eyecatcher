//
//  CameraView.swift
//  Eyecatcher
//
//  Created by Sara AlQuwaifli on 19/05/2024.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @State private var isFlashOn = false
    
    @StateObject private var model = DataModel()
    
    private static let barHeightFactor = 0.000003
    
    @State private var activeCategory: Category?
    
    @State private var isImageTaken = false
    
    @State private var isCategorySelected = false
    
    @State private var selectedCategoryForSheet: Category?
    
    private let languages = ["English", "Arabic"]
    
    @State private var selectedLanguage: String = "English" // Default language
    
//    @State private var categories : [Category] = [
//        Category( name: "All names", icon: "square.and.arrow.down.fill"),
//        Category( name: "Home", icon: "house.fill"),
//        Category(name: "Transportation", icon: "car.fill"),
//        Category(name: "Devices", icon: "desktopcomputer"),
//        Category(name: "Create New", icon: "plus.circle.fill")
//    ]
    
//    @State private var selectedCategory: Category? // Track the selected category
    
//    @State private var savedObjects: [Any] = [] // Replace 'Any' with the appropriate data type for your saved objects
    
    var body: some View {
        NavigationView {
            VStack {
                ViewfinderView(image: $model.viewfinderImage)
                    .overlay {
//                    HStack(alignment: .top) {
//
//                        // Flash toggle button
//
//                        Button(action: {
//                            isFlashOn.toggle()
//                            // Update the state to reflect the change
//                        }) {
//                            Image(systemName: isFlashOn ? "bolt.fill" : "bolt.slash")
//                                .font(.title)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                        Spacer().frame(maxWidth:.infinity, maxHeight: . infinity)
//
//                    }
//                    .padding(.top, 20)
//                    .padding(.horizontal, 15)
                    
                    // Main content area
                    
                        ZStack(alignment: .bottom) {
                            VStack {
                                Spacer()
//                                cardsView()
//
//                                 if let category = activeCategory {
//                                    Button(action: {
//                                        selectedCategoryForSheet = category
//                                        isCategorySelected = true
//                                    }) {
//                                        CategoryCardView(category: category)
//                                                            }
//                                                            .frame(height: 100)
//                                                            .padding(.bottom, 30)
//                                                        }
                            languageSelectionView() // Position the language selector here
                                .padding()
                                buttonsView()
                                  .padding(.horizontal) // Padding on both sides
                                  .padding(.bottom, 20) // Adjust bottom padding to move buttons up or down
                                  .fullScreenCover(isPresented: $isImageTaken) {
                                      PhotoView(imageData: $model.imageData, image: $model.thumbnailImage, labeler: model.labeler)
                                      .onAppear {
                                        model.camera.isPreviewPaused = true
                                        model.selectedLanguage = selectedLanguage
                                      }
                                      .onDisappear {
                                        model.camera.isPreviewPaused = false
                                        model.thumbnailImage = nil
                                      }
                                  }
                            
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
            
                .task {
                    await model.camera.start()
                }
                .ignoresSafeArea()
                .statusBar(hidden: true)
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }.onDisappear {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
        }
    }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
//    private func cardsView() -> some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(categories) { category in
//                    Button(action: {
//                        self.selectedCategory = category
//                        isCategorySelected = true
//                        // Fetch the saved objects for the selected category
////                        fetchSavedObjects(for: category)
//                    }) {
//                        CategoryCardView(category: category)
//                    }
//                    .sheet(item: $selectedCategory) { category in
//                        SheetView(category: category, onDismiss: {
//                            isCategorySelected = false
//                        }, savedObjects: $savedObjects, isCategorySelected: $isCategorySelected, labeler: Labeling())
//                    }
//                }
//            }
//        }
//    }
    
    private func buttonsView() -> some View {
        HStack {
            
//            Button(action: {
//                //
//            }) {
//                Image(systemName: "rectangle.fill")
//                    .font(.largeTitle)
//                //                    .foregroundColor(Color("Orange").opacity(0.30))
//                    .foregroundColor(.white)
//                    .padding()
//                    .cornerRadius(10)
//            }
            
            // Camera button

            Button {
                if isFlashOn {
//                    toggleTorch(on: true)
//                    // Ensure flash is on if it's supposed to be
                }
                model.camera.takePhoto()
                isImageTaken.toggle()
                navigateToPhotoView()
                //toggleTorch(on: false)
                // Turn off the flash after taking the photo
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 72, height: 72)
                        Circle()
                            .fill(.white)
                            .frame(width: 55, height: 55)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
//            Button(action: {
//                //
//            }) {
//                Image(systemName: "exclamationmark.circle.fill")
//                    .font(.largeTitle)
//                    .foregroundColor(.white)
//                    .padding()
//                    .cornerRadius(10)
//            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
    private func showPhotoView() {
      model.camera.isPreviewPaused = true
      navigateToPhotoView()
    }

    private func navigateToPhotoView() {
        // Logic to navigate to PhotoView
        let photoView = PhotoView(imageData: $model.imageData, image: $model.thumbnailImage, labeler: model.labeler)
        // You can use various presentation styles here
        // - Presenting as a full screen modal:
//            UIApplication.shared.rootViewController?.present(photoView, animated: true)
        
        // - Presenting with a custom transition:
        //    let transition = ... // Define your custom transition
//            photoView.transition(.custom(animation: transition))
//            UIApplication.shared.rootViewController?.present(photoView, animated: true)
      }
    
//    // Modify the takePhoto() method in your Camera model to return an Image
//    func takePhoto() -> Image {
//      // Capture the photo using your camera model's logic
//      if let capturedPhoto = model.camera.takePhoto() {
//        return Image(uiImage: capturedPhoto)
//      } else {
//        // Handle cases where capturing photo fails (optional)
//        return Image("defaultPlaceholderImage") // Or provide a default image
//      }
//    }
//    model.photoStream.next { photo in
//        // Handle the captured photo here
//        // You can use the photo object to display the image or perform further processing
//        self.isImageTaken.toggle()
//        self.showPhotoView()
//    }
    func capturePhoto() -> UIImage? {
      // Implement your camera capture logic here using AVCaptureSession etc.
      // This logic should capture an image and return it as a UIImage
      // (This is a placeholder, replace with your actual implementation)
      return nil // Replace with actual captured image or nil if unsuccessful
    }
//struct CategoryCardView: View {
//       // let category: CategoryModel
//       let category: Category
//        var body: some View {
//            ZStack {
//                VStack {
//                    HStack(alignment: .top) {
//                        Button(action: {
//                            // Handle edit or delete actions for the category
//                        }) {
//                            Image(systemName: "arrow.up.left.and.arrow.down.right")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.white)
//                                .frame(width: 16, height: 20)
//                                .padding(.leading, 175)
//                        }
//                    }
//                    .padding(.vertical, -10)
//
//                    Image(systemName: category.icon)
//                        .resizable()
//                        .foregroundColor(.white)
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 65, height: 40)
//                        .cornerRadius(5)
//
//                    Text(category.name)
//                        .foregroundColor(.white)
//                        .font(.headline)
//
//                    Text("words count")
//                        .foregroundColor(.white)
//                        .font(.caption)
//                }
//                .padding(.top, 5)
//                .frame(width: 210, height: 120)
//                .background(Color("Orange").opacity(0.30))
//                .cornerRadius(10)
//            }
//        }
//    }
    
    
    private func languageSelectionView() -> some View {
        Menu {
            ForEach(languages, id: \.self) { language in
                Button(language) {
                    selectedLanguage = language
                    model.selectedLanguage = language
                }
            }
        } label: {
            HStack {
                Text(selectedLanguage)
                    .font(.body)
                Image(systemName: "chevron.down")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .foregroundColor(.white)
            .cornerRadius(30)
        }
    }
}
//func toggleTorch(on: Bool) {
//    guard let device = AVCaptureDevice.default(for: .video) else { return }
//    if device.hasTorch {
//        do {
//            try device.lockForConfiguration()
//            device.torchMode = on ? .on : .off
//            device.unlockForConfiguration()
//        } catch {
//            print("Torch could not be used")
//        }
//    } else {
//        print("Torch is not available")
//    }
//}

//
//import SwiftData
//struct SheetView: View {
//    @Environment(\.presentationMode) var presentationMode
//    let category: Category
//    let onDismiss: () -> Void
//    @Binding var savedObjects: [Any] // Access the savedObjects from CameraView
//    @Binding var isCategorySelected: Bool
//    var labeler: Labeling
//    var textTospeech = SpeechSynthesizer()
//   // var labler_2 : Labeling
//    
//    
//    @Query var savedPhotos: [Photo]
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Text("\(savedPhotos.count)💻")
//                //Text(labler_2.mostProminentLabel)
//                
//                ForEach(savedPhotos){ photo in
//                    HStack{
//                        if let uiImage = UIImage(data: photo.imageData) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .frame(width: 110, height: 110)
//                                .cornerRadius(10)
//                        }
//                        VStack(alignment: .leading) {
//                            Text(labeler.mostProminentLabel)
//                            .fontWeight(.medium)
//                            Button(action: {
//                                textTospeech.detectAndSpeak(label: labeler.mostProminentLabel)
//                             }) {
//                             Image(systemName: "speaker.wave.2.fill")
//                             .foregroundColor(.blue)
//                            }
//
//                        }
//                        
//                }
//                        VStack(alignment: .leading) {
//                            let label = labler_2.mostProminentLabel
//                            if !label.isEmpty {
//                                Text(label)
//                                    .font(.headline)
//                                    .foregroundColor(.primary)
//                                    .padding(.leading, 10)
//                            }
//                            
//                            
//                            
//                        }
                   // }
                    
                    
                    //            if let category = category {
                    //                Text("Details for \(category.name)")
                    //                List(savedObjects) { object in
                    //                    // Display the object details
                    //                }
                    //                Button("Add Object") {
                    //                    // Add functionality to add a new object
                    //                    savedObjects.append(/*newObject*/)
                    //                }
                    //            } else {
                    //                Text("Category not selected")
                    //            }
//                }
//                .padding()
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Text(category.name)
//                            .font(.title3)
//                            .bold()
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                            isCategorySelected = false
//                        }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundColor(.gray)
//                                .bold()
//                                .font(.title3)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

private func fetchSavedObjects(for category: Category) {
    // Fetch the saved objects for the selected category and update the `savedObjects` state
    //    savedObjects = [...] // Replace with your actual data fetching logic
    
    
    
    struct CategoryView: View {
        @Binding var category: Category?
        
        var body: some View {
            if let category = category {
                Text("Details for \(category.name)")
            } else {
                Text("Category not selected")
            }
        }
    }
}
