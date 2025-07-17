//
//  PhotoLibrarFloatingButton.swift
//  Glyme
//
//  Created by Nana Bonsu on 6/25/25.
//

import SwiftUI
import PhotosUI

/// This view provides a floating button to open the photo library and detect fruits in selected images.
struct PhotoLibraryFloatingButton: View {
    
    @EnvironmentObject var openaiViewModel: OpenAIViewModel // Access the shared OpenAI view model
    @EnvironmentObject var cameraViewModel: CameraViewModel // Access the shared camera view model
    @State private var showPicker = false // Controls PhotosPicker presentation (not used here)
    @State private var selectedImage: UIImage? = nil // Holds the selected image from the picker
    @State private var selectedItem: PhotosPickerItem? = nil // Holds the selected PhotosPicker item
    @State private var detectedFruitLabel: String = "" // Stores the detected fruit label
    @State private var showResults = false // Controls the results sheet presentation
    @State private var isDetecting  = false // Indicates if fruit detection is in progress
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // Floating button to open the photo picker
                PhotoPickerButton(selectedItem: $selectedItem)
                    Spacer()
            }
        }
        // Handle changes to the selected photo picker item
        .onChange(of: selectedItem) { newItem in
            handleSelectedItem() // Call the function to handle the selected item
        }
        .sheet(isPresented: $showResults) {
            if openaiViewModel.isLoading || openaiViewModel.currentNutritionData == nil {
                ProgressView("Loading nutrition data...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .presentationDetents([.medium, .large])
            } else {
                NutritionDetailView(nutritionData: openaiViewModel.currentNutritionData!)
                
                //ne to chck this tho anmakes ure firsgt
            }
        }

    }
    
    // Handle the selected item from the photo picker and perform fruit detection
    func handleSelectedItem() {
        guard let newItem = selectedItem else { return }
        Task {
            // Load image data from the selected item
            if let data = try? await newItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
                isDetecting = true // Start detection
                // Call fruit detection on the selected image
                cameraViewModel.detectFruit(in: image) { fruitLabel in
                    
                    cameraViewModel.stopSession() // Stop the camera session after detection
                    DispatchQueue.main.async {
                        print("D fruit")
                        detectedFruitLabel = fruitLabel ?? "No fruit detected"
                        isDetecting = false // Stop detection
                        showResults = true // Show results
                        // Call the closure to handle detected fruit
                        selectedItem = nil // Reset the selected item
                    }
                    
                    if let fruitLabel = fruitLabel {
                        Task {
                            await openaiViewModel.getNutritionDataForFruit(for: fruitLabel)
                        }
                    }
                        
                    print("The detected fruit is: \(detectedFruitLabel)")
                

                }
            }
        }
    }

}


struct PhotoPickerButton: View {
    @Binding var selectedItem: PhotosPickerItem? // Binding to the selected item from the photo picker
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(24)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
        .padding(.leading, 20)
        .padding(.bottom, 40)
    }
    
}
#Preview {
    PhotoLibraryFloatingButton()
        .environmentObject(CameraViewModel()) // Needed for preview to work
}
